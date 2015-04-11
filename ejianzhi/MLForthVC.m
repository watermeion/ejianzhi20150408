//
//  MLForthVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLForthVC.h"
#import "SRLoginVC.h"
#import "MLJobListViewController.h"
#import "MLCustomjobListViewController.h"
#import "MLLoginManger.h"
#import "MLResumePreviewVC.h"

//子视图控制器
#import "ResumeVC.h"
@interface MLForthVC ()<finishLogin,UIAlertViewDelegate>{
    BOOL pushing;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

//登录控制器
@property (weak,nonatomic) MLLoginManger *loginManager;

@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

- (IBAction)showResumeAction:(id)sender;

- (IBAction)showMyAppliedJob:(id)sender;

- (IBAction)showMyFavoriteAction:(id)sender;

@end

@implementation MLForthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        // 登录button 处理函数
        UIViewController *vc=[self.loginManager showLoginVC];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
     self.loginManager=[MLLoginManger shareInstance];
    
    pushing=NO;
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

    if ([AVUser currentUser]!=nil) {
        [self finishLogin];
    }
    else {
        [self finishLogout];
    }
}

- (IBAction)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出账户？" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.delegate=self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        BOOL isLogout=[[[SRLoginBusiness alloc]init]logOut];
        if (isLogout) {
            [self finishLogout];
        }
    }
}

- (void)finishLogout{
    
    self.buttonLabel.text=[NSString stringWithFormat:@"点击登录"];
    
    self.logoutButton.hidden=YES;
    //动态绑定LoginButton响应函数
    self.logoutButton.tag=10000;
    
    self.bottomConstraint.constant=-60;
}

- (void)finishLogin{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    self.buttonLabel.text=[NSString stringWithFormat:@"%@",[mySettingData objectForKey:@"currentUserName"]];
    
    self.logoutButton.hidden=NO;
    //动态绑定LoginButton响应函数
    self.logoutButton.tag=20000;
    
    self.bottomConstraint.constant=0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma --mark  显示简历
- (IBAction)showResumeAction:(id)sender {
    
    MLResumePreviewVC *previewVC=[[MLResumePreviewVC alloc]init];
    previewVC.hidesBottomBarWhenPushed=YES;
    previewVC.type=1;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    pushing=YES;
    [self.navigationController pushViewController:previewVC animated:YES];
}



#pragma --mark  显示我的申请界面
- (IBAction)showMyAppliedJob:(id)sender {
    //自定义列表
    
//    MLCustomjobListViewController *myAppliedJobListVC=[[MLCustomjobListViewController alloc]init];
//    myAppliedJobListVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:myAppliedJobListVC animated:YES];
    
}


#pragma --mark  显示我的收藏
- (IBAction)showMyFavoriteAction:(id)sender {

//    MLJobListViewController *myFavoriteListVC=[[MLJobListViewController alloc]init];
//    myFavoriteListVC.navigationController.navigationItem.title=@"我的收藏";
//    myFavoriteListVC.hidesBottomBarWhenPushed=YES;
//    myFavoriteListVC.navigationController.navigationBar.hidden=NO;
//    [self.navigationController pushViewController:myFavoriteListVC animated:YES];
}


@end
