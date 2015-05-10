//
//  CompanyInfoViewModel.m
//  ejianzhi
//
//  Created by Mac on 4/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "CompanyInfoViewModel.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface CompanyInfoViewModel ()

@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) AVObject *companyInfoObject;

@end


@implementation CompanyInfoViewModel



-(instancetype)initWithData:(NSString *)companyid
{
    if (self=[super init]) {
        if (companyid!=nil) {
            self.companyId=companyid;
        }
        
    }
    return self;
}

-(void)mapKeyValueFromAVObjects:(AVObject*)obj
{
    if ([obj objectForKey:@"qiYeName"]) {
        self.comName=[obj objectForKey:@"qiYeName"];
    }else
        self.comName=@"未填写";
    if ([obj objectForKey:@"qiYeName"]) {
        self.comTitle=[obj objectForKey:@"qiYeName"];
    }else
        self.comTitle=@"未填写";
    if ([obj objectForKey:@"qiYeLicenseNumber"]) {
        self.comFileNum=[obj objectForKey:@"qiYeLicenseNumber"];
    }else
        self.comFileNum=@"未填写";
    
    if ([[obj objectForKey:@"qiYeProvince"] length]>0||[[obj objectForKey:@"qiYeCity"] length]>0||[[obj objectForKey:@"qiYeDistrict"] length]>0) {
        self.comArea=[NSString stringWithFormat:@"%@ %@ %@",[obj objectForKey:@"qiYeProvince"],[obj objectForKey:@"qiYeCity"],[obj objectForKey:@"qiYeDistrict"]];
    }else
        self.comArea=@"未填写";
    if ([obj objectForKey:@"qiYeIndustry"]) {
        self.comIndustry=[obj objectForKey:@"qiYeIndustry"];
    }else
        self.comIndustry=@"未填写";
    if ([obj objectForKey:@"qiYeDetailAddress"]) {
        self.comAddress=[obj objectForKey:@"qiYeDetailAddress"];
    }else
        self.comAddress=@"未填写";
    if ([obj objectForKey:@"qiYeLinkName"]) {
        self.comContactors=[obj objectForKey:@"qiYeLinkName"];
    }else
        self.comContactors=@"未填写";
    if ([obj objectForKey:@"qiYeMobile"]) {
        self.comPhone=[obj objectForKey:@"qiYeMobile"];
    }else
        self.comPhone=@"未填写";
    if ([obj objectForKey:@"qiYeEmail"]) {
        self.comEmail=[obj objectForKey:@"qiYeEmail"];
    }else
        self.comEmail=@"未填写";
    if ([obj objectForKey:@"qiYeScale"]) {
        self.comScaleNum=[obj objectForKey:@"qiYeScale"];
    }else
        self.comScaleNum=@"未填写";
    if ([obj objectForKey:@"qiYeProperty"]) {
        self.comProperty=[obj objectForKey:@"qiYeProperty"];
    }else
        self.comProperty=@"未填写";
    
    self.tag1Icon=(BOOL)[obj objectForKey:@"qiYeIsValidate"]==YES?nil:[UIImage imageNamed:@"label_xx"];

    self.comIcon=[UIImage imageNamed:@"placeholder"];
}


/**
 *  请求网络数据
 */
-(void)fetchCompanyDataFromAVOS:(NSString *)companyId{
    
    if(companyId!=nil){
    AVQuery *query=[AVQuery queryWithClassName:@"QiYeInfo"];
    query.cachePolicy=kAVCachePolicyNetworkElseCache;
    query.maxCacheAge=3600*24;
    [query whereKey:@"objectId" equalTo:companyId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count]>0) {
                self.companyInfoObject=[objects firstObject];
                [self mapKeyValueFromAVObjects:self.companyInfoObject];
            }else{
                NSString *errorString=[NSString stringWithFormat:@"您还没有填写信息哦"];
                [MBProgressHUD showError:errorString toView:nil];
                
                self.comName=@"未填写";
                self.comTitle=@"e兼职商家联盟";
                self.comArea=@"未填写";
                self.comIndustry=@"未填写";
                self.comAddress=@"未填写";
                self.comContactors=@"未填写";
                self.comPhone=@"未填写";
                self.comEmail=@"未填写";
                self.comScaleNum=@"未填写";
                self.comProperty=@"未填写";
                self.comFileNum=@"未填写";
                self.comIcon=[UIImage imageNamed:@"placeholder"];
                
                AVQuery *query=[AVUser query];
                [query whereKey:@"objectId" equalTo:[AVUser currentUser].objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if ([objects count]>0) {
                            AVUser *user=[objects objectAtIndex:0];
                            self.companyInfoObject=[AVObject objectWithClassName:@"QiYeInfo"];
                            [self.companyInfoObject setObject:user forKey:@"qiYeUser"];
                            [self.companyInfoObject setObject:user.objectId forKey:@"userObjectId"];
                            [self.companyInfoObject saveEventually];
                        }
                    }
                }];
                }
        }else{
            NSString *errorString=[NSString stringWithFormat:@"sorry，加载出错。错误原因：%@"  ,error.description];
            [MBProgressHUD showError:errorString toView:nil];
        }
        
    }];
    
    }
}

- (void)saveCompanyDataToAVOS:(id)info Key:(NSString*)key{
    if (self.companyInfoObject) {
        [self.companyInfoObject setObject:info forKey:key];
        [self.companyInfoObject saveEventually];
    }else{
        AVQuery *query=[AVUser query];
        [query whereKey:@"objectId" equalTo:[AVUser currentUser].objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count]>0) {
                    AVUser *user=[objects objectAtIndex:0];
                    self.companyInfoObject=[AVObject objectWithClassName:@"QiYeInfo"];
                    [self.companyInfoObject setObject:user forKey:@"qiYeUser"];
                    [self.companyInfoObject setObject:user.objectId forKey:@"userObjectId"];
                    [self.companyInfoObject saveEventually];
                }
            }
        }];
    }
}

- (void)saveCompanyDataToAVOS:(NSMutableArray*)infos Keys:(NSMutableArray*)keys{
    if (self.companyInfoObject) {
        for (int i=0; i<[infos count];i++) {
            [self.companyInfoObject setObject:[infos objectAtIndex:i] forKey:[keys objectAtIndex:i]];
        }
        
    }else{
        AVQuery *query=[AVUser query];
        [query whereKey:@"objectId" equalTo:[AVUser currentUser].objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count]>0) {
                    AVUser *user=[objects objectAtIndex:0];
                    self.companyInfoObject=[AVObject objectWithClassName:@"QiYeInfo"];
                    [self.companyInfoObject setObject:user forKey:@"qiYeUser"];
                    [self.companyInfoObject setObject:user.objectId forKey:@"userObjectId"];
                    
                    for (int i=0; i<[infos count];i++) {
                        [self.companyInfoObject setObject:[infos objectAtIndex:i] forKey:[keys objectAtIndex:i]];
                    }
                    
                    
                }
            }
        }];
    }
    [self.companyInfoObject saveEventually];
}
@end
