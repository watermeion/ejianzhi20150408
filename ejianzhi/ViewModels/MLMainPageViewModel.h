//
//  MLMainPageViewModel.h
//  EJianZhi
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLMainPageViewModel : NSObject

@property (nonatomic,strong)NSString *cityName;
/**
 *  开始定位
 */
- (void)startLocatingToGetCity;

/**
 *  初始化
 *
 *  @return return value description
 */
- (instancetype)init;
@end
