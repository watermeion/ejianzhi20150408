//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AVObject+Subclass.h"

@interface User : AVObject<AVSubclassing>

@property (nonatomic,assign) BOOL mobilePhoneVerified;
@property (nonatomic,strong) NSNumber *userType;
@property (nonatomic,strong) NSString *mobilePhoneNumber;
@property (nonatomic,strong) NSString *sessionToken;
@property (nonatomic,strong) NSString *salt;
@property (nonatomic,assign) BOOL emailVerified;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *email;

//@property (nonatomic,strong) NSString *createdAt;
//@property (nonatomic,strong) NSString *updatedAt;
//-(id)initWithJson:(NSDictionary *)json;

@end
