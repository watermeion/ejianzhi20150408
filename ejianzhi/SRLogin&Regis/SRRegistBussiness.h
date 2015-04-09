//
//  SRRegistBussiness.h
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLLoginManger.h"
@protocol registerComplete <NSObject>
@required
- (void)registerComplete:(BOOL)isSucceed;
@end

@interface SRRegistBussiness : NSObject
{

}
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *pwd;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *feedback;
@property (nonatomic,weak) MLLoginManger *loginManager;

-(void)NewUserRegistInBackground:(NSString*)username Pwd:(NSString*)password Phone:(NSString*) phone;

-(void) RegistHasSucceed;
-(void) RegistHasFailed:(NSError*)error;

@property(nonatomic,weak) id<registerComplete> registerDelegate;

@end
