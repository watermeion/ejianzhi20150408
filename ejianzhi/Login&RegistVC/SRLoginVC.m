//
//  SRLoginVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/21.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "SRLoginVC.h"
#import "SRRegisterVC.h"

#import "MLLoginViewModel.h"
#import "MLLoginManger.h"
#import "MLTabbarVC.h"
#import "MLTabbar1.h"

@interface SRLoginVC ()<successRegistered>
{
    NSInteger loginType;
}
@property (weak,nonatomic) MLLoginManger *loginManager;
@property (strong, nonatomic) IBOutlet UIButton *otherLoginBtn;
@property (strong, nonatomic) IBOutlet UIButton *lookAroundBtn;

@end

@implementation SRLoginVC
//@synthesize userAccount=_userAccount;
//@synthesize userPassword=_userPassword;

static  SRLoginVC *thisController=nil;

+(id)shareLoginVC
{
    if (thisController==nil) {
        thisController=[[SRLoginVC alloc] initWithNibName:@"SRLoginVC" bundle:nil];
    }
    return thisController;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];

    if ([[mySettingData objectForKey:@"userType"]isEqualToString:@"0"]) {
        MLTabbarVC *tabbar=[MLTabbarVC shareInstance];
        [self.navigationController pushViewController:tabbar animated:NO];
    }else if ([[mySettingData objectForKey:@"userType"]isEqualToString:@"1"]){
        MLTabbar1 *tabbar=[MLTabbar1 shareInstance];
        [self.navigationController pushViewController:tabbar animated:NO];
    }
    
    loginType=0;
    self.loginManager=[MLLoginManger shareInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.rect1=self.floatView2.frame;
    
    loginer=[[SRLoginBusiness alloc]init];
    loginer.loginDelegate=self;
    
    
    [self.userAccount.rac_textSignal subscribeNext:^(NSString *text) {
        loginer.username=text;
    }];
    
    
    [self.userPassword.rac_textSignal subscribeNext:^(NSString *text) {
        loginer.pwd=text;
    }];
    
    [self.otherLoginBtn.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 33/255.0, 174/255.0, 148/255.0, 1.0 });
    [self.otherLoginBtn.layer setBorderColor:colorref];
    [self.otherLoginBtn.layer setCornerRadius:5.0];

    [self.lookAroundBtn.layer setBorderWidth:1.0f];
    [self.lookAroundBtn.layer setBorderColor:colorref];
    [self.lookAroundBtn.layer setCornerRadius:5.0];

    
//    //初始化检验步骤  误删后续有用
//        RACSignal *validUsernameSignal = [self.userAccount.rac_textSignal map:^id(NSString *value) {
//            return @(value.length > 0);
//        }];
//    
//        RACSignal *validPasswordSignal = [self.userPassword.rac_textSignal map:^id(NSString *value) {
//            return @(value.length > 0);
//        }];
    //
    //
//        [validUsernameSignal subscribeNext:^(NSNumber *usernameValid) {
////            if ([usernameValid boolValue]==NO) {
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入账户名或手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////                [alert show];
////            }
//        }];
    //
//        [validPasswordSignal subscribeNext:^(NSNumber *passwordValid) {
//            if ([passwordValid boolValue]==NO) {
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入登陆密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//            }
//    
//        }];
    //
    //
    //    //创建login信号
//        RACSignal *loginActiveSignal=[RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal]
//           reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
//               return @(([usernameValid boolValue]&&[passwordValid boolValue]));
//           }];
//    
    //设置loginbutton 的rac_command
//    @weakify(self)
//    self.loginButton.rac_command=[[RACCommand alloc]initWithEnabled:loginActiveSignal signalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        [self touchLoginButton:nil];
//        //监控这个这个信号，应该监控operation操作完成的信号
//        return RACObserve(self.loginManager,LoginState);
//    }];
    
//    RAC(self.loginButton,backgroundColor)=[loginActiveSignal map:^id(NSNumber *value) {
//        @strongify(self)
//        return self.loginButton.enabled? [UIColor colorWithRed:0.13 green:0.62 blue:0.52 alpha:1.0f]:[UIColor grayColor];
//    }];
    
}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=NO;
    
}

- (IBAction)touchBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchRegister:(id)sender {
    SRRegisterVC *registerVC=[[SRRegisterVC alloc]init];
    registerVC.registerDelegate=self;
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userAccount resignFirstResponder];
    [_userPassword resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        CGRect rect2=CGRectMake(self.rect1.origin.x, self.rect1.origin.y-50, self.rect1.size.width, self.rect1.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            self.floatView2.frame=rect2;
        }];
    }
}

- (void)keyboardWillhide:(NSNotification *)notification{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.floatView2.frame=self.rect1;
        }];
    }
}

- (IBAction)touchLoginButton:(id)sender{
    
    if ([loginer.username length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入账户名或手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else if ([loginer.pwd length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入登陆密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [loginer loginInbackground:loginer.username Pwd:loginer.pwd loginType:loginType withBlock:^(BOOL succeed) {
            if (succeed) {
                MLTabbarVC *tabbar=[MLTabbarVC shareInstance];
                [self.navigationController pushViewController:tabbar animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loginer.feedback message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (void)successRegistered{
    //[self logIn];
}

- (IBAction)lookAround:(id)sender {
    MLTabbarVC *tabbar=[MLTabbarVC shareInstance];
    [self.navigationController pushViewController:tabbar animated:YES];
}

- (IBAction)otherLogin:(id)sender {
    if ([self.navItem.title isEqualToString:@"求职者登录"]) {
        self.navItem.title=@"企业登录";
        self.userAccount.placeholder=@"请输入企业登录账户";
        [self.otherLoginBtn setTitle:@"求职者登录" forState:UIControlStateNormal];
        loginType=1;
    }else{
        self.navItem.title=@"求职者登录";
        [self.otherLoginBtn setTitle:@"企业登录" forState:UIControlStateNormal];
        loginType=0;
    }
    self.userAccount.placeholder=@"请输入用户登录账户";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
