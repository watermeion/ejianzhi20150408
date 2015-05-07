//
//  applistCell+configurecell.m
//  ejianzhi
//
//  Created by Mac on 5/7/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "applistCell+configurecell.h"
#import "DateUtil.h"
#import "UIColor+ColorFromArray.h"
@implementation applistCell (configurecell)

- (void)CellConfigure:(JianZhiShenQing*)object
{
//    JianZhi *jianzhiObject=[object objectForKey:@"jianZhi"];
//    [self CellConfigureJianZhi:jianzhiObject];
//    
//    QiYeInfo *qiYeInfoObject=[object objectForKey:@"qiYeInfo"];
//    self.enterpriseName.text=[qiYeInfoObject objectForKey:@"qiYeName"];
//    if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"拒绝"])
//        self.statusImage.image= [UIImage imageNamed:@"rejected"];
//    else if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"同意"])
//        self.statusImage.image= [UIImage imageNamed:@"passed"];
//    else
//        self.statusImage.image= [UIImage imageNamed:@"notHandle"];
//    
//    self.jobTimeLabel.text=[DateUtil stringFromDate2:object.createdAt];
    [self CellConfigureForFavorList:object];
}



- (void)CellConfigureForFavorList:(AVObject *)object
{

    JianZhi *jianzhiObject=[object objectForKey:@"jianZhi"];
    [self CellConfigureJianZhi:jianzhiObject];
    
    QiYeInfo *qiYeInfoObject=[object objectForKey:@"qiYeInfo"];
    if (qiYeInfoObject) {
        self.enterpriseName.text=[qiYeInfoObject objectForKey:@"qiYeName"];
    }
    
    if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"拒绝"])
        self.statusImage.image= [UIImage imageNamed:@"rejected"];
    else if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"同意"])
        self.statusImage.image= [UIImage imageNamed:@"passed"];
    else
        self.statusImage.image= [UIImage imageNamed:@"notHandle"];
    
    self.jobTimeLabel.text=[DateUtil stringFromDate2:object.createdAt];
}

-(void)CellConfigureJianZhi:(JianZhi *)jianzhiObject
{
    if (jianzhiObject) {
        self.jobTitle.text=jianzhiObject.jianZhiTitle;
        
        self.jobDistrict.text=jianzhiObject.jianZhiDistrict;
        
        self.jobSalary.text=[jianzhiObject.jianZhiWage stringValue];
        
        self.acceptNum.text=[jianzhiObject.jianZhiLuYongValue stringValue];
        
        UIColor *color=[UIColor colorForType:[NSString stringWithFormat:@"%@",jianzhiObject.jianZhiType]];
        if(color==nil) self.badgeView.backgroundColor=GreenFillColor;
        else self.badgeView.backgroundColor=color;
        self.typeLabel.text=jianzhiObject.jianZhiType;
//        self.recuitNum.text=[NSString stringWithFormat:@"/%@人",[jianzhiObject.jianZhiRecruitment stringValue]];
    }
}

@end
