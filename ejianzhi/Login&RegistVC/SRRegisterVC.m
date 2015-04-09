//
//  SRRegisterVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/21.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "SRRegisterVC.h"
//#import <BmobSDK/Bmob.h>
#import "SRLoginVC.h"
#import "SMS_SDK/SMS_SDK.h"

@interface SRRegisterVC ()<registerComplete>

@end

@implementation SRRegisterVC
@synthesize phoneNumber=_phoneNumber;
@synthesize securityCode=_securityCode;
@synthesize userPassword=_userPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.frame = CGRectMake(25, 345, 25, 25);
    [_check1 setTitle:nil forState:UIControlStateNormal];
    [_check1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:_check1];
    [_check1 setChecked:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.rect1=self.floatView.frame;
    
    self.verificationButton.enabled=NO;
    
    self.registerButton.enabled=NO;
    
    self.agreed=YES;
    
    Register=[[SRRegistBussiness alloc]init];
    Register.registerDelegate=self;
    
    self.timerLabel.hidden=YES;
    
    self.phoneNumber.keyboardType=UIKeyboardTypeNumberPad;
    self.securityCode.keyboardType=UIKeyboardTypeNumberPad;
    
    
    //RAC  创建用户账号、密码、验证码校验信号
    RACSignal *validUsernameSignal =
    [self.phoneNumber.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPhone:text]);
     }];
    
    

    
    RACSignal *validUserPwdSignal=[self.userPassword.rac_textSignal map:^id(NSString *text) {
        return @(text.length>0);
    }];
    
    RACSignal *validVerifycodeSignal=[self.securityCode.rac_textSignal map:^id(NSString *text) {
        return @(text.length>0);
    }];
    
  
    
    //监听获取验证码按钮enabled
    RAC(self.verificationButton, enabled) =
    [validUsernameSignal
     map:^id(NSNumber *passwordValid){
         return @([passwordValid boolValue]);
     }];
    
    
    [self.phoneNumber.rac_textSignal subscribeNext:^(NSString *text) {
        inputPhoneNumber=text;
    }];
    
    
    [self.userPassword.rac_textSignal subscribeNext:^(NSString *text) {
        inputPassword=text;
    }];
    
    [self.securityCode.rac_textSignal subscribeNext:^(NSString *text) {
        verifyCode=text;
    }];
    
    
        
    //创建注册按钮激活信号
    RACSignal *signUpActiveSignal=[RACSignal combineLatest:@[validUsernameSignal,validUserPwdSignal,validVerifycodeSignal,RACObserve(self, agreed)]
                                                    reduce:^id(NSNumber *phoneNumValid,NSNumber *passwordValid,NSNumber *verifycodeValid){
                                                        
                                                        return @([phoneNumValid boolValue]&&[passwordValid boolValue]&&[verifycodeValid boolValue]&&self.agreed);
                          
                                                    }];
    //配置注册按钮信号监听
    [signUpActiveSignal subscribeNext:^(NSNumber *isActive) {
//        self.registerButton.enabled=[isActive boolValue];
        self.registerButton.backgroundColor=[isActive boolValue]? [UIColor colorWithRed:0.88 green:0.38 blue:0.22 alpha:1.0f]:[UIColor grayColor];
    }];
    
    RAC(self.registerButton,enabled)=[signUpActiveSignal map:^id(NSNumber *isActive) {
        return isActive;
    }];


}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=NO;
}

/**
 *  判断手机号是否正确
 *
 *  @param phoneNum 手机号
 *
 *  @return YES/NO123456
 */
- (BOOL)isValidPhone:(NSString *)phoneNum
{
    
    if (phoneNum.length==11) {
        return YES;
    }
    return NO;
}

/**
 *  注册完成回调，delegate 方法
 *
 *  @param isSucceed
 */
- (void)registerComplete:(BOOL)isSucceed{
    if (isSucceed) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.registerDelegate successRegistered];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:Register.feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


/**
 *  点击注册实践
 *
 *  @param sender
 */
- (IBAction)touchRegister:(id)sender {
    
    [SMS_SDK commitVerifyCode:verifyCode result:^(enum SMS_ResponseState state) {
        if (1==state) {
            Register.username=inputPhoneNumber;
            Register.pwd=inputPassword;
            Register.phone=inputPhoneNumber;
            
            [Register NewUserRegistInBackground:Register.username Pwd:Register.pwd Phone:Register.phone];
        }
        else if(0==state)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:Register.feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


/**
 *  请求验证码事件
 *
 *  @param sender
 */
- (IBAction)verification:(id)sender {
    
    [SMS_SDK getVerifyCodeByPhoneNumber:inputPhoneNumber AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (1==state) {
            
            [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码已发送" message:Register.feedback delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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

- (void)keyboardWillShow:(NSNotification *)notification{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        CGRect rect2=CGRectMake(self.rect1.origin.x, self.rect1.origin.y-100, self.rect1.size.width, self.rect1.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            
            self.floatView.frame=rect2;
        }];
    }
}

- (void)keyboardWillhide:(NSNotification *)notification{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.floatView.frame=self.rect1;
        }];
    }
}


- (IBAction)touchBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    self.agreed=checked;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumber resignFirstResponder];
    [_securityCode resignFirstResponder];
    [_userPassword resignFirstResponder];
}


-(void)initTimer
{
    self.timerLabel.text=[NSString stringWithFormat:@"%d秒",60];
    self.timerLabel.hidden=NO;
    self.verificationButton.hidden=YES;
    
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
    seconds=60;
    [[NSRunLoop currentRunLoop] run];
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    NSLog(@"%d",seconds);
    seconds--;
    
    [self performSelectorOnMainThread:@selector(showTimer) withObject:nil waitUntilDone:YES];
    
}

- (void)showTimer{
    self.timerLabel.text=[NSString stringWithFormat:@"%d秒",seconds];
    
    if (seconds==0) {
        [timer invalidate];
        self.timerLabel.hidden=YES;
        self.verificationButton.hidden=NO;
        seconds=60;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
