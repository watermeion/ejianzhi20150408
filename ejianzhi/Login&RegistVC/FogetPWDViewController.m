//
//  FogetPWDViewController.m
//  ejianzhi
//
//  Created by Mac on 5/7/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "FogetPWDViewController.h"
#import "SMS_SDK/SMS_SDK.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface FogetPWDViewController ()
{
    int  seconds;
     NSTimer *timer;
}
@property (nonatomic,strong)NSString *currentUserPhone;
@end

@implementation FogetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"重置密码";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.currentUserPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
    
    
    //RAC signal
    if([self.currentUserPhone length]!=11) self.sendMsgBtn.enabled=NO;
    RACSignal *pwdVerifySignal=[RACSignal combineLatest:@[self.pwdNewText.rac_textSignal,self.pwdNewAgainText.rac_textSignal,self.smscodeText.rac_textSignal]                                                    reduce:^id(NSString *pwdNew,NSString *pwdNewAgain,NSString *SMSSodeText){
        if (pwdNew!=nil && [pwdNew isEqualToString:pwdNewAgain] && [SMSSodeText length]>3 ) {
            return @YES;
        }
        
            return @NO;
        }];
    RAC(self.submitBtn,enabled)=pwdVerifySignal;

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



-(void)initTimer
{
    self.showTimerLabel.text=[NSString stringWithFormat:@"%d秒",60];
    self.showTimerLabel.hidden=NO;
//    self.verificationButton.hidden=YES;
    self.sendMsgBtn.enabled=NO;
    self.sendMsgBtn.titleLabel.text=[NSString stringWithFormat:@"验证码以发送,请无重复操作"];
    
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
    seconds=60;
    [[NSRunLoop currentRunLoop] run];
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    seconds--;
    
    [self performSelectorOnMainThread:@selector(showTimer) withObject:nil waitUntilDone:NO];
    
}

- (void)showTimer{
    self.showTimerLabel.text=[NSString stringWithFormat:@"%d秒",seconds];
    if (seconds==0) {
        [timer invalidate];
        self.showTimerLabel.hidden=YES;
//        self.verificationButton.hidden=NO;
        self.sendMsgBtn.enabled=YES;
        self.sendMsgBtn.tintColor=[UIColor whiteColor];
        self.sendMsgBtn.titleLabel.text=[NSString stringWithFormat:@"点击发送验证码"];
        seconds=60;
    }
}
 

- (IBAction)submitAction:(id)sender {
    
    [SMS_SDK commitVerifyCode:self.smscodeText.text result:^(enum SMS_ResponseState state) {
        if (1==state) {
            [MBProgressHUD showMessag:@"提交中..." toView:self.view];
//修改密码业务逻辑业务逻辑
//            [AVUser logInWithUsername:[AVUser currentUser].username password:[AVUser currentUser].password]; //请确保用户当前的有效登录状态
            [[AVUser currentUser] updatePassword:[AVUser currentUser].password newPassword:self.pwdNewText.text block:^(id object, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //处理结果
                if(!error)
                {
                    TTAlert(@"密码修改成功");
                }else
                {
                    TTAlert(@"密码修改失败，请重新尝试");
                }
            }];
            
            
            
            
            
            
            
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];

    
    
    
    
    
}
@end
