//
//  FogetPWDViewController.m
//  ejianzhi
//
//  Created by Mac on 5/7/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "FogetPWDViewController.h"
#import "SMS_SDK/SMS_SDK.h"
@interface FogetPWDViewController ()
@property (nonatomic,strong)NSString *currentUserPhone;
@end

@implementation FogetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentUserPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
    //RAC signal
    
   
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

- (IBAction)sendMsgAction:(id)sender {
    
    [SMS_SDK getVerifyCodeByPhoneNumber:self.currentUserPhone AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (1==state) {
            
            [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码已发送" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码获取失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码申请次数超限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起，你的操作太频繁啦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}







- (IBAction)submitAction:(id)sender {
    
    [SMS_SDK commitVerifyCode:self.smscodeText.text result:^(enum SMS_ResponseState state) {
        if (1==state) {
//修改密码业务逻辑业务逻辑
            
            
            
            
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];

    
    
    
    
    
}
@end
