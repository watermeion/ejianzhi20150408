//
//  RTLoginBusiness.m
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//


#import "SRLoginBusiness.h"
#import "MLLoginManger.h"

@implementation SRLoginBusiness


-(instancetype)init
{
    if (self=[super init]) {
        
        self.loginManager=[MLLoginManger shareInstance];
        return self;
    }
    return nil;


}


-(void)loginInbackground:(NSString *)username Pwd:(NSString *)pwd
{
    
    [AVUser logInWithUsernameInBackground:username password:pwd block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [self loginIsSucceed:YES];
            SRUserInfo *userInfo=[[SRUserInfo alloc]init];
            userInfo.username=user.username;
            [self saveUserInfoLocally:userInfo];
            //完成一些本地化操作
        } else {
            [self loginIsSucceed:NO];
        }
    }];
}

-(BOOL)loginIsSucceed:(BOOL)result
{
    if (result) {
        self.feedback=@"登录成功";
        [self.loginManager setLoginState:active];
        [self.loginDelegate loginSucceed:YES];
    }
    else
    {
        self.feedback=@"登录失败";
        [self.loginDelegate loginSucceed:NO];

    }
    return result;
}

-(BOOL)saveUserInfoLocally:(SRUserInfo*)_currentInfo
{
    //本地化常用数据
    //currentUserName 当前用户名
    
    if (_currentInfo!=nil) {
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        [mySettingData setObject:_currentInfo.username forKey:@"currentUserName"];
        [mySettingData synchronize];
    }
    return YES;
}

-(BOOL)checkIfAuto_login
{
    AVUser *cuser=[AVUser currentUser];
    if(cuser!=nil)
    {
        return YES;
    }
    else
    {
     return NO;
    }
}


-(BOOL)logOut
{
    //退出机制

    
    [AVUser logOut];
    [self.loginManager setLoginState:unactive];
        if ([AVUser currentUser]==nil) {
            //设置NSUserdefault
    
            NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
            [mySettingData setBool:NO forKey:@"auto_login"];
    
            [mySettingData removeObjectForKey: @"currentUserName"];
    
            [mySettingData synchronize];
            return YES;
        }
        else
            return NO;
    
    
//    [BmobUser logout];  //清除缓存用户对象
//    
//    if ([BmobUser getCurrentUser]==nil) {
//        //设置NSUserdefault
//        
//        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
//        
//        [mySettingData setBool:NO forKey:@"auto_login"];
//        
//        [mySettingData removeObjectForKey: @"currentUserName"];
//        
//        [mySettingData synchronize];
//        
//        return YES;
//    }
//    else
//        return NO;
}

//-(void)dragUserDataFromBmob
//{
//    BmobQuery *query  = [BmobUser query];
//    BmobUser *currentUser=[BmobUser getCurrentObject];
//    
//    [query getObjectInBackgroundWithId:[currentUser objectId] block:^(BmobObject *object, NSError *error) {
//        if (error == nil) {
//            SRUserInfo *user=[SRUserInfo shareInstance];
//            user.username=[object objectForKey:@"username"];
//            user.email=[object objectForKey:@"email"];
//            user.phone=[object objectForKey:@"phone"];
//            
//            //本地化
//            [self saveUserInfoLocally:user];
//            
//            [self loginIsSucceed:YES];
//            
//        } else {
//            
//            [self loginIsSucceed:NO];
//        }
//    }];
//}

@end
