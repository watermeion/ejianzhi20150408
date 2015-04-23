//
//  PullServerManager.m
//  EJianZhi
//
//  Created by Mac on 3/27/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//







#import "PullServerManager.h"

@implementation PullServerManager

static PullServerManager * singleIntance;


+(PullServerManager*)sharedIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleIntance=[[super alloc]init];
               //初始化检索对象
//        [singleIntance rewriteUserDefaults];
    });
    return singleIntance;
}

-(void)rewriteUserDefaults
{
    //FIXME:改成动态的
    NSUserDefaults* mysettings=[NSUserDefaults standardUserDefaults];
    NSArray *type=@[@"不限",@"开发", @"销售",@"安保", @"礼仪", @"促销", @"翻译", @"客服",@"演出",@"家教",@"模特",@"派单", @"文员", @"设计",@"校内",@"临时工",@"服务员", @"其他",@"预留"];
    
    NSArray *settlementway=@[@"不限",@"时",@"日",@"周",@"月", @"季", @"年",@"项目"];
    NSArray *redu=@[@"最新",@"附近",@"最热"];
    
    [mysettings setObject:settlementway forKey:FliterSettlementWay];
    [mysettings setObject:redu forKey:FliterReDu];
    [mysettings setObject:type forKey:FliterType];
    [mysettings synchronize];
}



@end
