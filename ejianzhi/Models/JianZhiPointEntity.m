//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "JianZhiPointEntity.h"

@implementation JianZhiPointEntity


-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
    if(json != nil)
    {
       self.__type  = [json objectForKey:@"__type"];
 self.longitude  = [json objectForKey:@"longitude"];
 self.latitude  = [json objectForKey:@"latitude"];
 
    }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.__type forKey:@"zx___type"];
[aCoder encodeObject:self.longitude forKey:@"zx_longitude"];
[aCoder encodeObject:self.latitude forKey:@"zx_latitude"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.__type = [aDecoder decodeObjectForKey:@"zx___type"];
 self.longitude = [aDecoder decodeObjectForKey:@"zx_longitude"];
 self.latitude = [aDecoder decodeObjectForKey:@"zx_latitude"];
 
    }
    return self;
}



@end
