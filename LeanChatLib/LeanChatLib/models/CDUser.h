//
//  CDUser.h
//  LeanChatLib
//
//  Created by lzw on 15/4/3.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LeanChatLib/LeanChatLib.h>

@interface CDUser : NSObject<CDUserModel>

@property (nonatomic,strong) NSString* userId;

@property (nonatomic,strong) NSString* username;

@property (nonatomic,strong) NSString* avatarUrl;

@end
