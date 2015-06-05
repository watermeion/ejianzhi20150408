//
//  CompanyInfoViewModel.h
//  ejianzhi
//
//  Created by Mac on 4/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CompanyInfoViewModel :  NSObject

@property (nonatomic,strong)NSString *comTitle;
@property (nonatomic,strong)NSString *comName;
@property (nonatomic,strong)NSString *comArea;
@property (nonatomic,strong)NSString *comProvince;
@property (nonatomic,strong)NSString *comCity;
@property (nonatomic,strong)NSString *comDistrict;
@property (nonatomic,strong)NSString *comAddress;
@property (nonatomic,strong)NSString *comContactors;
@property (nonatomic,strong)NSString *comPhone;
@property (nonatomic,strong)NSString *comEmail;
@property (nonatomic,strong)NSString *comFileNum;
@property (nonatomic,strong)NSString *comIndustry;
@property (nonatomic,strong)NSString *comProperty;
@property (nonatomic,strong)NSString *comScaleNum;



@property (nonatomic,strong)UIImage *comIcon;
@property (nonatomic,strong)UIImage *tag1Icon;


-(instancetype)initWithData:(NSString*)companyid;
-(void)fetchCompanyDataFromAVOS:(NSString *)companyId;
- (void)saveCompanyDataToAVOS:(id)info Key:(NSString*)key;
- (void)saveCompanyDataToAVOS:(NSMutableArray*)infos Keys:(NSMutableArray*)keys;
@end
