//
//  SRRegistBussiness.m
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import "SRRegistBussiness.h"

@implementation SRRegistBussiness
@synthesize feedback;
@synthesize username;
@synthesize pwd;
@synthesize phone;

-(void)NewUserRegistInBackground:(NSString*)_username Pwd:(NSString*)_password Phone:(NSString *)_phone{
    
    //环信注册接口
    
    //bomb注册接口
    
    AVUser *user = [AVUser user];
    user.username = _username;
    user.password = _password;
//    user.email = @"steve@company.com";
    [user setObject:_phone forKey:@"mobilePhoneNumber"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self RegistHasSucceed];
            //注册成功保存用户数据
            NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
            [mySettingData setObject:_username forKey:@"currentUserName"];
            [mySettingData synchronize];
            
        } else {
            [self RegistHasFailed:error];
        }
    }];
    
}

-(void) RegistHasFailed:(NSError*)error
{
    self.feedback=error.description;
    [self.registerDelegate registerComplete:NO];
}

-(void) RegistHasSucceed
{
    self.feedback=@"注册成功";
    [self.loginManager setLoginState:active];
    [self.registerDelegate registerComplete:YES];
}

@end
