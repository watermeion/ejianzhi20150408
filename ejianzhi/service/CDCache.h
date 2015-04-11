//
//  CDCacheService.h
//  LeanChat
//
//  Created by lzw on 14/12/3.
//  Copyright (c) 2014年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCECommon.h"

@interface CDCache : NSObject

+ (void)registerUsers:(NSArray*)users;

+ (void)registerUser:(AVUser*)user;

+ (AVUser *)lookupUser:(NSString*)userId;

+(AVIMConversation*)lookupConvById:(NSString*)convid;

+(void)registerConv:(AVIMConversation*)conv;

+(void)cacheUsersWithIds:(NSSet*)userIds callback:(AVArrayResultBlock)callback;

+(void)cacheConvsWithIds:(NSMutableSet*)convids callback:(AVArrayResultBlock)callback;

+(void)registerConvs:(NSArray*)convs;

#pragma mark - current conv

+(void)setCurConv:(AVIMConversation*)conv;

+(AVIMConversation*)getCurConv;

+(void)refreshCurConv:(AVBooleanResultBlock)callback;

+(void)setFriends:(NSArray*)_friends;

+(NSArray*)getFriends;

+(void)cacheAndFillRooms:(NSMutableArray*)rooms callback:(AVBooleanResultBlock)callback;

@end
