//
//  CDStorage.h
//  LeanChat
//
//  Created by lzw on 15/1/29.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CDRoom.h"

@interface CDStorage : NSObject

+(instancetype)sharedInstance;

-(void)close;

-(void)setupWithUserId:(NSString*)userId;

-(NSArray*)getMsgsWithConvid:(NSString*)convid maxTime:(int64_t)time limit:(int)limit;

-(int64_t)insertMsg:(AVIMTypedMessage*)msg;

-(BOOL)updateStatus:(AVIMMessageStatus)status byMsgId:(NSString*)msgId;

-(BOOL)updateFailedMsg:(AVIMTypedMessage*)msg byTmpId:(NSString*)tmpId;

-(void)deleteMsgsByConvid:(NSString*)convid;

-(NSArray*)getRooms;

-(void)insertRoomWithConvid:(NSString*)convid;

-(void)deleteRoomByConvid:(NSString*)convid;

-(void)incrementUnreadWithConvid:(NSString*)convid;

-(void)clearUnreadWithConvid:(NSString*)convid;


@end
