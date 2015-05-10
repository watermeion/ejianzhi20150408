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


-(void)loginInbackground:(NSString *)username Pwd:(NSString *)pwd loginType:(NSUInteger)type withBlock:(loginBlock)loginBlock
{
    
    [AVUser logInWithUsernameInBackground:username password:pwd block:^(AVUser *user, NSError *error) {
        
        if (user != nil) {
            NSNumber *typenum=[user objectForKey:@"userType"];
            if ([typenum integerValue]!=type) {
                self.feedback=@"登录账户名不存在";
                loginBlock(NO,nil);
            }else{
                AVFile *avatarFile=[user objectForKey:@"avatar"];
                
                [self saveUserInfoLocally:avatarFile.url userType:[typenum stringValue]];
                
                self.feedback=@"登录成功";
                NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
                if([user objectForKey:@"mobilePhoneNumber"]){
                    [mySettingData setObject:[user objectForKey:@"mobilePhoneNumber"]forKey:@"userPhone"];
                    [mySettingData synchronize];
                }
                loginBlock(YES,[user objectForKey:@"userType"]);
            }
        } else {
            if (error.code==210) {
                self.feedback=@"登录密码错误";
            }else if (error.code==211)
                self.feedback=@"登录账户名不存在";
            loginBlock(NO,nil);
        }
    }];
    
}

//保存用户头像url
-(BOOL)saveUserInfoLocally:(NSString*)_avatarString userType:(NSString*)_type
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    [mySettingData setObject:_avatarString forKey:@"userAvatar"];
    [mySettingData setObject:_type forKey:@"userType"];
    [mySettingData synchronize];
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
    
    [AVUser logOut];
    
    [self.loginManager setLoginState:unactive];
    
    if ([AVUser currentUser]==nil) {
        
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        
        [mySettingData setBool:NO forKey:@"auto_login"];
        
        [mySettingData removeObjectForKey: @"currentUserName"];
        
        [mySettingData removeObjectForKey: @"userAvatar"];
        
        [mySettingData removeObjectForKey:@"userType"];
        
        [mySettingData synchronize];
        
        return YES;
    }
    else
        return NO;
}

@end
