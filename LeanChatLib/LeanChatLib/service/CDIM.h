//
//  CDIMClient.h
//  LeanChat
//
//  Created by lzw on 15/1/21.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDAVOSHeaders.h"
#import "CDUserModel.h"
#define CONV_TYPE @"type"
#define CONV_ATTR_TYPE_KEY @"attr.type"
#define CONV_MEMBERS_KEY @"m"

typedef enum : NSUInteger {
    CDConvTypeSingle = 0,
    CDConvTypeGroup,
} CDConvType;

@protocol CDUserDelegate <NSObject>

@required

//同步方法
-(id<CDUserModel>) getUserById:(NSString*)userId;

//对于每条消息，都会调用这个方法来缓存发送者的用户信息，以便 getUserById 直接返回用户信息
-(void)cacheUserByIds:(NSSet*)userIds block:(AVIMArrayResultBlock)block;

@end

@interface CDIM : NSObject

@property AVIMClient* imClient;

@property (nonatomic,strong) id<CDUserDelegate> userDelegate;

@property (nonatomic,strong,readonly) NSString* selfId;

@property (nonatomic,strong) id<CDUserModel> selfUser;

+ (instancetype)sharedInstance;

-(void)openWithClientId:(NSString*)clientId callback:(AVIMBooleanResultBlock)callback;

- (void)closeWithCallback:(AVBooleanResultBlock)callback;

-(BOOL)isOpened;

-(void)fecthConvWithId:(NSString*)convid callback:(AVIMConversationResultBlock)callback;

- (void)fetchConvWithUserId:(NSString *)userId callback:(AVIMConversationResultBlock)callback ;

-(void)fetchConvsWithIds:(NSSet*)convids callback:(AVIMArrayResultBlock)callback;

-(void)createConvWithUserIds:(NSArray*)userIds callback:(AVIMConversationResultBlock)callback;

- (void)updateConv:(AVIMConversation *)conv name:(NSString *)name attrs:(NSDictionary *)attrs callback:(AVIMBooleanResultBlock)callback ;

-(void)findGroupedConvsWithBlock:(AVIMArrayResultBlock)block;

-(NSArray*)queryMsgsWithConv:(AVIMConversation*)conv msgId:(NSString*)msgId maxTime:(int64_t)time limit:(int)limit error:(NSError**)theError;

#pragma mark - msg utils

-(NSString*)getMsgTitle:(AVIMTypedMessage*)msg;

#pragma mark - path utils

-(NSString*)getPathByObjectId:(NSString*)objectId;

-(NSString*)tmpPath;

#pragma mark - conv utils

-(CDConvType)typeOfConv:(AVIMConversation*)conv;

-(NSString*)otherIdOfConv:(AVIMConversation*)conv;

-(NSString*)nameOfConv:(AVIMConversation*)conv;

-(NSString*)nameOfUserIds:(NSArray*)userIds;

-(NSString*)titleOfConv:(AVIMConversation*)conv;

-(NSString*)uuid;

@end
