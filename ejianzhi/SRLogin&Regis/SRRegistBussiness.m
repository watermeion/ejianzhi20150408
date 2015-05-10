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
  
    AVUser *user = [AVUser user];
    user.username = _username;
    user.password = _password;
    [user setObject:_phone forKey:@"mobilePhoneNumber"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self RegistHasSucceed];
            //注册成功保存用户数据
            NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
            [mySettingData setObject:_username forKey:@"currentUserName"];
            [mySettingData synchronize];
            
            [user setObject:[NSNumber numberWithInteger:self.registerType] forKey:@"userType"];
            [user saveEventually];
            
        } else {
            [self RegistHasFailed:error];
        }
    }];
    
}

-(void) RegistHasFailed:(NSError*)error
{
    if (error.code==214)
        self.feedback=@"用户名已被注册";

    [self.registerDelegate registerComplete:NO];
}

-(void) RegistHasSucceed
{
    self.feedback=@"注册成功";
    [self.loginManager setLoginState:active];
    [self.registerDelegate registerComplete:YES];
}




@end
