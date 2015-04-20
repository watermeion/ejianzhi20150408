//
//  JianZhiShenQing.h
//  ejianzhi
//
//  Created by RAY on 15/4/18.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVObject+Subclass.h"
#import "QiYeInfo.h"
#import "JianZhi.h"
#import "UserDetail.h"

@interface JianZhiShenQing : AVObject<AVSubclassing>
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *enterpriseHandleResult;
@property (nonatomic,strong) QiYeInfo *qiYeInfo;
@property (nonatomic,strong) JianZhi *jianZhi;
@property (nonatomic,strong) UserDetail *userDetail;
@property (nonatomic,strong) NSString *userLiuYan;

@end
