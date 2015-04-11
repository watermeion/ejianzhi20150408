//
//  AddRequest.m
//  AVOSChatDemo
//
//  Created by lzw on 14-10-23.
//  Copyright (c) 2014年 AVOS. All rights reserved.
//

#import "CDAddRequest.h"

@implementation CDAddRequest

@dynamic fromUser;
@dynamic toUser;
@dynamic status;

+(NSString *)parseClassName{
    return @"AddRequest";
}


@end
