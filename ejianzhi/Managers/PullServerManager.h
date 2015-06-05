//
//  PullServerManager.h
//  EJianZhi
//
//  Created by Mac on 3/27/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//


#define FliterType @"filterType"
#define FliterReDu @"filterReDu"
#define FliterSettlementWay @"filterSettlementWay"
#define TypeListAndColor @"typelistandcolor"
#import <Foundation/Foundation.h>
/**
 *  管理从服务器端拉取，设置数据，类型数据，app更新数据等信息
 */
@interface PullServerManager : NSObject

+(PullServerManager*)sharedIntance;
-(void)rewriteUserDefaults;

-(void)pullBannerInfo;



@end
