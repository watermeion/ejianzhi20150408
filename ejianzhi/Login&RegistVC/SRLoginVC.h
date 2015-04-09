//
//  SRLoginVC.h
//  EJianZhi
//
//  Created by RAY on 15/1/21.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SRLoginBusiness.h"
#import "MLLoginViewModel.h"
@protocol finishLogin <NSObject>
@required
- (void)finishLogin;
@end

@interface SRLoginVC : UIViewController{
    SRLoginBusiness *loginer;
}


@property (strong,nonatomic) MLLoginViewModel *viewModel;


@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UITextField *userAccount;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UIView *floatView2;

@property (nonatomic) CGRect rect1;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property(nonatomic,weak) id<finishLogin> finishLoginDelegate;

+(id)shareLoginVC;

@end

