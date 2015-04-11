//
//  CDEmotionUtils.h
//  LeanChat
//
//  Created by lzw on 14/11/25.
//  Copyright (c) 2014年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDEmotionUtils : NSObject

+(NSArray*)getEmotionManagers;
+(NSString*)convertWithText:(NSString*)text toEmoji:(BOOL)toEmoji;

@end
