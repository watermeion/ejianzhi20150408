//
//  EnterpriseForthVC.m
//  ejianzhi
//
//  Created by RAY on 15/5/2.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "EnterpriseForthVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+EMWebCache.h"
#import "AppDelegate.h"
#import "MLTextUtils.h"
#import "settingVC.h"
#import "MLLoginManger.h"
#import "SRLoginVC.h"
#import "MLTabbar1.h"
#import "CompanyInfoViewController.h"


#define  PIC_WIDTH 80
#define  PIC_HEIGHT 80

@interface EnterpriseForthVC ()<finishLogin,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    BOOL pushing;
    BOOL imagePickerPushing;
}

//登录控制器
@property (weak,nonatomic) MLLoginManger *loginManager;

@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatarView;

@end

@implementation EnterpriseForthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.loginManager=[MLLoginManger shareInstance];
    
    pushing=NO;
    imagePickerPushing=NO;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAvatar)];
    tapGesture.delegate=self;
    [self.userAvatarView addGestureRecognizer:tapGesture];
    self.userAvatarView.userInteractionEnabled=YES;
    
    [self.userAvatarView.layer setCornerRadius:40.0f];
    [self.userAvatarView.layer setMasksToBounds:YES];
    
    [self.logoutButton.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 247/255.0, 79/255.0, 92/255.0, 1.0 });
    [self.logoutButton.layer setBorderColor:colorref];
    [self.logoutButton.layer setCornerRadius:5.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (pushing) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        pushing=NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!imagePickerPushing) {
        if ([AVUser currentUser]!=nil) {
            [self finishLogin];
        }
        else {
            [self finishLogout];
        }
    }else{
        imagePickerPushing=NO;
    }
}

- (void)chooseAvatar{
    if ([AVUser currentUser]!=nil) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:Nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:Nil
                                      otherButtonTitles:@"从相册选择",@"拍照",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您尚未登录哦" message:nil delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"现在登录", nil];
        [alert show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{
                imagePickerPushing=YES;
            }];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{
                    imagePickerPushing=YES;
                }];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:ALERTVIEW_CAMERAWRONG delegate:nil cancelButtonTitle:ALERTVIEW_KNOWN otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }
        
    }
}

- (IBAction)touchLogin:(id)sender {
    if ([AVUser currentUser]==nil) {
        MLTabbar1 *tabbar=[MLTabbar1 shareInstance];
        [tabbar.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出账户？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag==1001) {
        if (buttonIndex==1) {
            NSString *telUrl = @"tel://010-62416324";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]]; //拨号

        }
    }else{
        if (buttonIndex==1) {
            
            BOOL isLogout=[[[SRLoginBusiness alloc]init]logOut];
            if (isLogout) {
                
                MLTabbar1 *tabbar=[MLTabbar1 shareInstance];
                [tabbar.navigationController popViewControllerAnimated:YES];
                [self finishLogout];
            }
            
        }
    }
}

- (void)finishLogout{
    
    self.buttonLabel.text=@"点击登录";
    self.userAvatarView.image=[UIImage imageNamed:@"placeholder"];
    self.logoutButton.hidden=YES;
    
    self.logoutButton.tag=10000;
    
    self.bottomConstraint.constant=-60;
}

- (void)finishLogin{
    
    if ([AVUser currentUser]) {
        self.buttonLabel.text=[AVUser currentUser].username;
    }
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:@"userAvatar"]) {
        [self.userAvatarView sd_setImageWithURL:[NSURL URLWithString:[mySettingData objectForKey:@"userAvatar"]]];
    }else{
        AVQuery *userQuery=[AVUser query];
        [userQuery whereKey:@"objectId" equalTo:[AVUser currentUser].objectId];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count]>0) {
                    AVUser *_user=[objects objectAtIndex:0];
                    AVFile *imageFile=[_user objectForKey:@"avatar"];
                    [self.userAvatarView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    [mySettingData setObject:imageFile.url forKey:@"userAvatar"];
                    [mySettingData synchronize];
                }
            }
        }];
    }
    
    self.logoutButton.hidden=NO;
    
    //动态绑定LoginButton响应函数
    self.logoutButton.tag=20000;
    
    self.bottomConstraint.constant=0;
}

//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    picker = Nil;
    
    [self dismissModalViewControllerAnimated:YES];
    
    self.userAvatarView.image=image;
    
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AVFile *imageFile = [AVFile fileWithName:@"AvatarImage" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            if (imageFile.url != Nil) {
                AVQuery *query=[AVUser query];
                [query whereKey:@"objectId" equalTo:[AVUser currentUser].objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                    NSUserDefaults *defaultData=[NSUserDefaults standardUserDefaults];
                    [defaultData setObject:imageFile.url forKey:@"userAvatar"];
                    [defaultData synchronize];
                    
                    AVUser *currentUser=[objects objectAtIndex:0];
                    [currentUser setObject:imageFile forKey:@"avatar"];
                    [currentUser saveEventually];
                    
                    AVQuery *userDetailQuery=[AVQuery queryWithClassName:@"UserDetail"];
                    [userDetailQuery whereKey:@"userObjectId" equalTo:currentUser.objectId];
                    [userDetailQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            if ([objects count]>0) {
                                AVObject *userDetailObject=[objects objectAtIndex:0];
                                NSMutableArray *imageArray=[userDetailObject objectForKey:@"userImageArray"];
                                [imageArray insertObject:imageFile.url atIndex:0];
                                [userDetailObject setObject:imageArray forKey:@"userImageArray"];
                                [userDetailObject saveEventually];
                            }else{
                                AVObject *userDetailObject = [AVObject objectWithClassName:@"UserDetail"];
                                NSMutableArray *imageArray=[[NSMutableArray alloc] initWithObjects:imageFile.url, nil];
                                [userDetailObject setObject:imageArray forKey:@"userImageArray"];
                                [userDetailObject saveEventually];
                            }
                        }
                    }];
                }];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showError:UPLOADFAIL toView:self.view];
            });
        }
        
    } progressBlock:^(NSInteger percentDone) {
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showEnterpriseInfo:(id)sender {
    
    if ([AVUser currentUser].objectId!=nil) {
        CompanyInfoViewController *companyInfoVC=[[CompanyInfoViewController alloc]initWithData:[AVUser currentUser].objectId];
        companyInfoVC.fromEnterprise=YES;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        pushing=YES;

        companyInfoVC.hidesBottomBarWhenPushed=YES;
        companyInfoVC.edgesForExtendedLayout=UIRectEdgeNone;
        [self.navigationController pushViewController:companyInfoVC animated:YES];

    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您尚未登录哦" message:nil delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"现在登录", nil];
        [alert show];
    }
    
}

- (IBAction)showSettingVC:(id)sender {
    settingVC *setting=[[settingVC alloc]init];
    setting.hidesBottomBarWhenPushed=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    pushing=YES;
    [self.navigationController pushViewController:setting animated:YES];
}

- (IBAction)makePhoneCall:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"是否呼叫客服中心？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=1001;
    [alert show];
    
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
