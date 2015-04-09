//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface JianZhiPointEntity : NSObject<NSCoding>

@property (nonatomic,strong) NSString *__type;
@property (nonatomic,strong) NSNumber *longitude;
@property (nonatomic,strong) NSNumber *latitude;
 


-(id)initWithJson:(NSDictionary *)json;

@end
