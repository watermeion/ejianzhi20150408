//
//
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器  http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//
#import "User.h"

@implementation User


@dynamic mobilePhoneVerified;
@dynamic userType;
@dynamic mobilePhoneNumber;
@dynamic sessionToken;
@dynamic salt;
@dynamic emailVerified;
@dynamic password;
@dynamic username;
@dynamic email;









//-(id)initWithJson:(NSDictionary *)json;
//{
//    self = [super init];
//    if(self)
//    {
//        if(json != nil)
//        {
//            //       self.updatedAt  = [json objectForKey:@"updatedAt"];
//            self.mobilePhoneVerified = [[json objectForKey:@"mobilePhoneVerified"]boolValue];
//            self.userType  = [json objectForKey:@"userType"];
//            self.mobilePhoneNumber  = [json objectForKey:@"mobilePhoneNumber"];
//            self.sessionToken  = [json objectForKey:@"sessionToken"];
//            self.salt  = [json objectForKey:@"salt"];
//            self.emailVerified = [[json objectForKey:@"emailVerified"]boolValue];
//            self.password  = [json objectForKey:@"password"];
//            self.username  = [json objectForKey:@"username"];
//            // self.ACL  = [[ACLEntity alloc] initWithJson:[json objectForKey:@"ACL"]];
//            self.objectId  = [json objectForKey:@"objectId"];
//            // self.createdAt  = [json objectForKey:@"createdAt"];
//            self.email  = [json objectForKey:@"email"];
//            
//        }
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.updatedAt forKey:@"zx_updatedAt"];
//    [aCoder encodeBool:self.mobilePhoneVerified forKey:@"zx_mobilePhoneVerified"];
//    [aCoder encodeObject:self.userType forKey:@"zx_userType"];
//    [aCoder encodeObject:self.mobilePhoneNumber forKey:@"zx_mobilePhoneNumber"];
//    [aCoder encodeObject:self.sessionToken forKey:@"zx_sessionToken"];
//    [aCoder encodeObject:self.salt forKey:@"zx_salt"];
//    [aCoder encodeBool:self.emailVerified forKey:@"zx_emailVerified"];
//    [aCoder encodeObject:self.password forKey:@"zx_password"];
//    [aCoder encodeObject:self.username forKey:@"zx_username"];
//    [aCoder encodeObject:self.ACL forKey:@"zx_ACL"];
//    [aCoder encodeObject:self.objectId forKey:@"zx_objectId"];
//    [aCoder encodeObject:self.createdAt forKey:@"zx_createdAt"];
//    [aCoder encodeObject:self.email forKey:@"zx_email"];
//    
//}
//
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if(self)
//    {
//        //        self.updatedAt = [aDecoder decodeObjectForKey:@"zx_updatedAt"];
//        self.mobilePhoneVerified = [aDecoder decodeBoolForKey:@"zx_mobilePhoneVerified"];
//        self.userType = [aDecoder decodeObjectForKey:@"zx_userType"];
//        self.mobilePhoneNumber = [aDecoder decodeObjectForKey:@"zx_mobilePhoneNumber"];
//        self.sessionToken = [aDecoder decodeObjectForKey:@"zx_sessionToken"];
//        self.salt = [aDecoder decodeObjectForKey:@"zx_salt"];
//        self.emailVerified = [aDecoder decodeBoolForKey:@"zx_emailVerified"];
//        self.password = [aDecoder decodeObjectForKey:@"zx_password"];
//        self.username = [aDecoder decodeObjectForKey:@"zx_username"];
//        self.ACL = [aDecoder decodeObjectForKey:@"zx_ACL"];
//        self.objectId = [aDecoder decodeObjectForKey:@"zx_objectId"];
//        // self.createdAt = [aDecoder decodeObjectForKey:@"zx_createdAt"];
//        self.email = [aDecoder decodeObjectForKey:@"zx_email"];
//        
//    }
//    return self;
//}



+(NSString *)parseClassName
{
    return @"_User";
}


@end
