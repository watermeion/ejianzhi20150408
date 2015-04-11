//
//  CDChatRoomController.h
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface CDChatRoomVC : XHMessageTableViewController

-(instancetype)initWithConv:(AVIMConversation*)conv;

@end
