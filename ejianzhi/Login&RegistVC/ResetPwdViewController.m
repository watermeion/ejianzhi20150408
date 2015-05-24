//
//  ResetPwdViewController.m
//  ejianzhi
//
//  Created by Mac on 5/11/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface ResetPwdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitResetPWDAction:(id)sender;
- (IBAction)getSMSAction:(id)sender;
- (IBAction)backAction:(id)sender;


@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"找回密码";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    
    //RAC
    
    
    [self.phoneText.rac_textSignal subscribeNext:^(NSString *phoneNum) {
        if (phoneNum.length==11) {
            //手机号输入正确
            self.submitBtn.enabled=YES;
        }
    }];
    
    
    
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

- (IBAction)submitResetPWDAction:(id)sender {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    
    [AVUser resetPasswordWithSmsCode:self.smsCode.text newPassword:self.pwdText.text block:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(succeeded && !error)
        {
            [MBProgressHUD showSuccess:@"密码修改成功,请返回用新密码登录" toView:self.view];
        
        }else
        {
            NSString *string=[NSString stringWithFormat:@"错误：%@,请重新尝试",error.description];
            [MBProgressHUD showError:string toView:self.view];
        }
    }];
}

- (IBAction)getSMSAction:(id)sender {
    
    
    [AVUser requestPasswordResetWithPhoneNumber:self.phoneText.text block:^(BOOL succeeded, NSError *error) {
        if (!error && succeeded) {
            NSString *string=[NSString stringWithFormat:@"验证码，已经发送到您的手机：%@请查收。",self.phoneText.text];
            TTAlert(string);
        }else{
            
            NSString *string1=[NSString stringWithFormat:@"验证码发送错误：%@",error.description];
            TTAlert(string1);
        }
    }];
    
    
//    [AVUser  requestMobilePhoneVerify:self.phoneText.text withBlock:^(BOOL succeeded, NSError *error) {
//        if (!error && succeeded) {
//            NSString *string=[NSString stringWithFormat:@"验证码，已经发送到您的手机：%@请查收。",self.phoneText.text];
//            TTAlert(string);
//        }else{
//            
//            NSString *string1=[NSString stringWithFormat:@"验证码发送错误：%@",error.description];
//            TTAlert(string1);
//        }
//    }];
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
