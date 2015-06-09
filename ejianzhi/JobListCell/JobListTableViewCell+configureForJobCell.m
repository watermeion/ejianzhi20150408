//
//  JobListTableViewCell+configureForJobCell.m
//  ejianzhi
//
//  Created by Mac on 4/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "JobListTableViewCell+configureForJobCell.h"
#import "UIColor+ColorFromArray.h"
#import "MLJianZhiViewModel.h"
#import  "PullServerManager.h"
#import "MLMapManager.h"
#import "AJLocationManager.h"
#import "NSDate+Category.h"

#import "DateUtil.h"
@implementation JobListTableViewCell (configureForJobCell)
- (void)configureForJob:(JianZhi*)jianzhi
{

    self.titleLabel.text=jianzhi.jianZhiTitle;
    self.categoryLabel.text=jianzhi.jianZhiType;
    //根据兼职信息设置兼职色块颜色
    
    [self setIconBackgroundColor:[self colorForType:jianzhi.jianZhiType]];
    self.priceLabel.text=[jianzhi.jianZhiWage stringValue];
    self.payPeriodLabel.text=[NSString stringWithFormat:@"/%@",jianzhi.jianZhiWageType];
    self.keyConditionLabel.text=@"该兼职长期有效";
  
    if (jianzhi.jianZhiTimeStart!=nil && jianzhi.jianZhiTimeEnd!=nil) {
        NSString *dateString=[DateUtil stringFromDate:jianzhi.jianZhiTimeStart];
        
       dateString=[dateString stringByAppendingString:@"~"];
        
        dateString=[dateString stringByAppendingString:[DateUtil stringFromDate:jianzhi.jianZhiTimeEnd]];
        
        self.keyConditionLabel.text=dateString;
    }
    
//    if(jianzhi.jianzhiTeShuYaoQiu.length>=1)  self.keyConditionLabel.text=jianzhi.jianzhiTeShuYaoQiu;
    
    self.countNumbersWithinUnitsLabel.text=[NSString stringWithFormat:@"%d/%d人",[jianzhi.jianZhiQiYeLuYongValue intValue],[jianzhi.jianZhiRecruitment intValue]];
    //待完善
    self.distanceLabelWithinUnitLabel.text=[self distanceFromJobPoint:jianzhi.jianZhiPoint.latitude Lon:jianzhi.jianZhiPoint.longitude];
    self.updateTimeLabel.text=[jianzhi.createdAt timeIntervalDescription];
    
//    self.IconView.badgeText=jianzhi.jianZhiKaoPuDu;
}

-(UIColor*)colorForType:(NSString*)type
{
    NSUserDefaults *mysetting=[NSUserDefaults standardUserDefaults];
    NSDictionary *typeAndColorDict=[mysetting objectForKey:TypeListAndColor];
    NSArray *typeArray=[typeAndColorDict allKeys];
    if ([typeArray containsObject:type]) {
        UIColor *color=[UIColor colorRGBFromArray:[typeAndColorDict objectForKey:type]];
        return  color;
    }
    else
    {
        return nil;
    }
}

-(NSString *)distanceFromJobPoint:(double)lat Lon:(double)lon
{
    if (lat>0 && lon>0) {
    
        CLLocationCoordinate2D jobP=CLLocationCoordinate2DMake(lat, lon);
        
        CLLocationCoordinate2D location=[AJLocationManager shareLocation].lastCoordinate;
        
        NSNumber *disNumber=[MLMapManager calDistanceMeterWithPointA:jobP PointB:location];
        int threshold=[disNumber intValue];
        if (threshold >100000) {
          return [NSString stringWithFormat:@">100km"];
        }else if(threshold>1000)
        {
            return [NSString stringWithFormat:@"%.2fkm",[disNumber doubleValue]/1000];
        }else if(threshold<100)
        {
            return [NSString stringWithFormat:@"%dm",threshold];
        }
        
    }
    return @"";
}






@end
