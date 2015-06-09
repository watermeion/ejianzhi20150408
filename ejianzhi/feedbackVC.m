//
//  feedbackVC.m
//  ejianzhi
//
//  Created by RAY on 15/6/9.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "feedbackVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

@interface feedbackVC ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *button1;

@end

@implementation feedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textView.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){0.0/255.0,0.0/255.0,0.0/255.0,1.0});
    [self.textView.layer setBorderColor:colorref];
    [self.textView.layer setCornerRadius:5.0];
    
    [self.button1.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){255.0/255.0,255.0/255.0,255.0/255.0,1.0});
    [self.button1.layer setBorderColor:colorref1];
    [self.button1.layer setCornerRadius:5.0];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.textView resignFirstResponder];
}
- (IBAction)submit:(id)sender {
    
    if ([self.textView.text length]>0) {
        
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        
        if ([[mySettingData objectForKey:@"userType"] isEqualToString:@"1"]) {
            
            AVQuery *userQuery=[AVUser query];
            AVUser *usr=[AVUser currentUser];
            [userQuery whereKey:@"objectId" equalTo:usr.objectId];
            
            AVQuery *innerQuery=[AVQuery queryWithClassName:@"QiYeInfo"];
            
            [innerQuery whereKey:@"qiYeUser" matchesQuery:userQuery];
            
            [innerQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (!error) {
                    AVObject *feedbackObject=[AVObject objectWithClassName:@"FeedBack"];
                    [feedbackObject setObject:self.textView.text forKey:@"feedBackContent"];
                    [feedbackObject setObject:object forKey:@"userDetail"];
                    [feedbackObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"反馈成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }else{
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"反馈失败" message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }];
                }
            }];
            
        }else{
            AVQuery *query=[AVQuery queryWithClassName:@"UserDetail"];
            
            [query whereKey:@"userObjectId" equalTo:[AVUser currentUser].objectId];
            
            [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (!error) {
                    AVObject *feedbackObject=[AVObject objectWithClassName:@"FeedBack"];
                    [feedbackObject setObject:self.textView.text forKey:@"feedBackContent"];
                    [feedbackObject setObject:object forKey:@"userDetail"];
                    [feedbackObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"反馈成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }else{
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"反馈失败" message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }];
                }
            }];
        }
    }else{
        [MBProgressHUD showSuccess:@"请您先输入意见哦~" toView:self.view];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
