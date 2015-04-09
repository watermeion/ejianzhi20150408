//
//  UserDetail.h
//  EJianZhi
//
//  Created by RAY on 15/4/1.
//  Copyright (c) 2015年 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVObject+Subclass.h"

@interface UserDetail : AVObject<AVSubclassing>
@property (nonatomic,strong) NSString *userMobile;
@property (nonatomic,strong) NSString *userSchoolNumber;
@property (nonatomic,strong) NSString *userIdentifyFileURL;
@property (nonatomic,strong) AVGeoPoint *userPoint;
@property (nonatomic,strong) NSString *userIntroduction;
@property (nonatomic,strong) NSString *userProfesssion;
@property (nonatomic,strong) NSString *userHeight;
@property (nonatomic,strong) NSString *userObjectId;
@property (nonatomic,strong) NSString *userQQ;
@property (nonatomic,strong) NSString *userGender;
@property (nonatomic,strong) NSString *userRealName;
@property (nonatomic,assign) BOOL *isValidate;
@property (nonatomic,strong) NSNumber *userBrowseTime;
@property (nonatomic,strong) NSString *userSchool;
@property (nonatomic,strong) NSString *userProvince;
@property (nonatomic,strong) NSString *userCity;
@property (nonatomic,strong) NSString *userDistrict;
@property (nonatomic,strong) NSNumber *userLuYongValue;
@property (nonatomic,strong) NSString *userJobIntention;
@property (nonatomic,strong) NSString *userIdleTime;
@property (nonatomic,strong) NSNumber *userSecretType;
@property (nonatomic,strong) NSDate *userBirthYear;
@property (nonatomic,strong) AVFile *userIdentifyFile;
@property (nonatomic,strong) NSString *userEmail;
@property (nonatomic,strong) NSString *userWorkExperience;
@property (nonatomic,strong) NSArray *userImageArray;
@end
