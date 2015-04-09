//
//  MLLoginManger.m
//  EJianZhi
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "MLLoginManger.h"
#import "SRLoginVC.h"
#import "SRRegisterVC.h"

@interface MLLoginManger()
@property (strong,nonatomic) SRLoginVC  *loginVC;
@property (strong,nonatomic) SRRegisterVC  *registerVC;

@property (strong,nonatomic) MLLoginViewModel *viewModel;
@end

static MLLoginManger * thisInstance;
@implementation MLLoginManger
@synthesize LoginState=_LoginState;

/**
 *  MLLoginManger 单例方法
 *
 *  @return MLLoginManger 实例
 */
+(MLLoginManger*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thisInstance=[[super alloc]init];
        thisInstance.loginVC=[[SRLoginVC alloc]init];
        thisInstance.registerVC=[[SRRegisterVC alloc]init];
        //判断初始化用户状态的
        [thisInstance initLoginState];
    });
    return thisInstance;
}


-(void)setLoginState:(State)state
{
    _LoginState=state;
}

+(instancetype)alloc
{
    if (thisInstance==nil) {
        [MLLoginManger shareInstance];
    }
    return thisInstance;
}






-(UIViewController*)showLoginVC
{
    return self.loginVC;
}


-(UIViewController*)showRegistVC
{
    return self.registerVC;
}

- (State)initLoginState
{
    if ([AVUser currentUser]!=nil) {
        _LoginState=active;
    }else
    {
        _LoginState=unactive;
    }
    return _LoginState;
}


@end
