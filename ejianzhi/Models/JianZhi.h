//
//  JianZhi.h
//  EJianZhi
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "AVObject+SubClass.h"
#import "JianZhiPointEntity.h"
@interface JianZhi : AVObject<AVSubclassing>

@property (nonatomic,strong) NSNumber *jianZhiQiYeLuYongValue;
@property (nonatomic,strong) NSString *jianZhiContent;
@property (nonatomic,strong) NSString *jianZhiAddress;
@property (nonatomic,strong) NSNumber *jianZhiRecruitment;
@property (nonatomic,strong) NSDate *jianZhiTimeEnd;
@property (nonatomic,strong) NSString *jianZhiWorkTime;
@property (nonatomic,strong) NSString *jianZhiKaoPuDu;
@property (nonatomic,strong) NSString *jianZhiDistrict;

@property (nonatomic,strong) NSNumber *jianZhiBrowseTime;
@property (nonatomic,strong) NSString *jianZhiCity;

@property (nonatomic,strong) NSDate *jianZhiTimeStart;
@property (nonatomic,strong) NSString *jianZhiContactPhone;
@property (nonatomic,strong) NSString *jianZhiRequirement;
@property (nonatomic,strong) NSString *jianZhiProvince;
@property (nonatomic,strong) NSNumber *jianZhiQiYeManYiDu;
@property (nonatomic,strong) NSString *jianZhiWageType;
@property (nonatomic,strong) NSString *jianZhiContactName;
@property (nonatomic,strong) NSNumber *jianZhiWage;
@property (nonatomic,strong) NSString *jianzhiTeShuYaoQiu;
@property (nonatomic,strong) NSString *jianZhiQiYeName;
@property (nonatomic,assign) BOOL isNeedExercise;
@property (nonatomic,strong) NSNumber *jianZhiQiYeResumeValue;
@property (nonatomic,strong) NSString *jianZhiType;
@property (nonatomic,strong) AVGeoPoint *jianZhiPoint;
@property (nonatomic,strong) NSNumber *jianZhiLuYongValue;
@property (nonatomic,strong) NSString *jianZhiTitle;

@property (nonatomic,strong) NSString *qiYeInfoId;




@end
