//
//  MLStudentCard.m
//  EJianZhi
//
//  Created by RAY on 15/2/6.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLStudentCard.h"
#import "UIImage+RTTint.h"
#import "MLTextUtils.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+EMWebCache.h"

#define  PIC_WIDTH 120
#define  PIC_HEIGHT 120

@interface MLStudentCard ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    AVFile *failedImageFile;
    UIImage *temp;
}
@property (strong, nonatomic) IBOutlet UITextField *schoolNumberField;
@property (strong, nonatomic) NSString *schoolNumber;

@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation MLStudentCard

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"身份验证";
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    [self.schoolNumberField.rac_textSignal subscribeNext:^(NSString *text) {
        self.schoolNumber=text;
    }];
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    tapgesture.delegate=self;
    self.cardImage.userInteractionEnabled=YES;
    [self.cardImage addGestureRecognizer:tapgesture];
    self.progressLabel.hidden=YES;
    
    if (self.imageFile) {
        [self.cardImage sd_setImageWithURL:[NSURL URLWithString:self.imageFile.url] placeholderImage:[UIImage imageNamed:@"addCard.png"]];
    }
}


- (IBAction)uploadPicture:(id)sender {
    
    if ([self.schoolNumber length]>0&&[self.imageFile.url length]>0) {
        [MBProgressHUD showSuccess:@"已提交验证" toView:self.view];
        [self.identifyDelegate finishIdentify:self.schoolNumber imageUrl:self.imageFile];
        [self performSelector:@selector(returnResume) withObject:nil afterDelay:1.0];
    }
    else if (![self.imageFile.url length]>0){
        [MBProgressHUD showError:@"请上传学生证照片" toView:self.view];
    }
    else if ([self.schoolNumber length]==0){
        [MBProgressHUD showError:@"请填写学号" toView:self.view];
    }
}

- (void)returnResume{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectImage{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"从图库选择",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:ALERTVIEW_CAMERAWRONG delegate:nil cancelButtonTitle:ALERTVIEW_KNOWN otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }
    }
}

//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    temp = image;
    if (image.size.height > PIC_HEIGHT*3 || image.size.width>PIC_WIDTH*3) {
        CGSize size = CGSizeMake(PIC_HEIGHT*3, PIC_WIDTH*3);
        temp = [self scaleToSize:image size:size];
    }
    picker = Nil;
    [self dismissModalViewControllerAnimated:YES];

    //添加图片
    UIImage *darkTemp = [temp rt_darkenWithLevel:0.5f];
    self.cardImage.image=darkTemp;
    self.progressLabel.hidden=NO;
    self.progressLabel.text=@"等待上传...";
    
    //上传图片
    NSData *imageData = UIImagePNGRepresentation(temp);
    
    NSUserDefaults *defaultsData=[NSUserDefaults standardUserDefaults];
    
    NSString *imageName=[NSString stringWithFormat:@"schoolCard_%@.png",[defaultsData objectForKey:@"currentUserName"]];
    AVFile *imageFile = [AVFile fileWithName:imageName data:imageData];
    
    
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                self.cardImage.image=temp;
                self.imageFile=imageFile;
                self.progressLabel.hidden=YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressLabel.text=@"上传失败";
                [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                failedImageFile=imageFile;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:UPLOADFAIL message:@"是否重新上传？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                [alert show];
            });
        }
        
    } progressBlock:^(NSInteger percentDone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressLabel.text=[NSString stringWithFormat:@"正在上传:%ld％",percentDone];
        });
    }];

}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [failedImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                    self.cardImage.image=temp;
                    self.imageFile=failedImageFile;
                    self.progressLabel.hidden=YES;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressLabel.text=@"上传失败";
                    [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:UPLOADFAIL message:@"是否重新上传？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                    [alert show];
                });
            }
            
        } progressBlock:^(NSInteger percentDone) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressLabel.text=[NSString stringWithFormat:@"正在上传:%ld％",percentDone];
            });
        }];
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
