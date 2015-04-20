//
//  QiYeInfo.h
//  ejianzhi
//
//  Created by RAY on 15/4/18.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVObject+Subclass.h"
#import "User.h"

@interface QiYeInfo : AVObject<AVSubclassing>

@property (nonatomic,strong) NSString *userObjectId;
@property (nonatomic,strong) NSString *qiYeProvince;
@property (nonatomic,strong) NSString *qiYeCity;
@property (nonatomic,strong) NSString *qiYeDistrict;
@property (nonatomic,strong) NSString *qiYeDetailAddress;
@property (nonatomic,strong) User *qiYeUser;
@property (nonatomic,strong) AVFile *qiYeBusinessLicense;
@property (nonatomic,strong) NSString *qiYeIntroduction;
@property (nonatomic,strong) NSString *qiYeName;
@property (nonatomic,strong) NSString *qiYeEmail;
@property (nonatomic,strong) NSString *qiYeProperty;
@property (nonatomic,assign) BOOL *qiYeIsValidate;
@property (nonatomic,strong) NSString *qiYeLicenseNumber;
@property (nonatomic,strong) NSString *qiYeIndustry;
@property (nonatomic,strong) NSString *qiYeLinkName;
@property (nonatomic,strong) NSString *qiYeMobile;
@property (nonatomic,strong) AVGeoPoint *qiYePoint;
@property (nonatomic,strong) AVFile *qiYeIdCard;
@property (nonatomic,strong) NSString *qiScale;
@property (nonatomic,strong) AVFile *qiYeAgreement;
@end
