//
//  CDNotification.h
//  LeanChat
//
//  Created by lzw on 15/2/5.
//  Copyright (c) 2015年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

#define NOTIFICATION_MESSAGE_UPDATED @"NOTIFICATION_MESSAGE_UPDATED"
#define NOTIFICATION_CONV_UPDATED @"NOTIFICATION _CONV_UPDATED"
#define NOTIFICATION_SESSION_UPDATED @"NOTIFICATION_SESSION_UPDATED"

@interface CDNotify : NSObject

+(instancetype)sharedInstance;

-(void)addConvObserver:(id)target selector:(SEL)selector;

-(void)removeConvObserver:(id)target;

-(void)postConvNotify;

-(void)addMsgObserver:(id)target selector:(SEL)selector;

-(void)removeMsgObserver:(id)target;

-(void)postMsgNotify:(AVIMTypedMessage*)msg;

-(void)addSessionObserver:(id)target selector:(SEL)selector;

-(void)removeSessionObserver:(id)target;

-(void)postSessionNotify;

@end
