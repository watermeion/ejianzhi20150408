//
//  MLLoginViewModel.h
//  EJianZhi
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//


// 作用写登录逻辑，保存登录的UserModel数据 此类暂时没有用到

#import <Foundation/Foundation.h>
#import "MLLoginManger.h"

@interface MLLoginViewModel: NSObject
@property (weak,nonatomic)MLLoginManger *loginManager;

-(void)loginWithAVOS: (void(^)(void)) completion;
-(void)logoutWithAVOS:(void(^)(void)) completion;
- (void)registerWithAVOS:(void(^)(void)) completion;
@end
