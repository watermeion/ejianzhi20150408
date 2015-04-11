//
//  Utils.h
//  AVOSChatDemo
//
//  Created by lzw on 14-10-24.
//  Copyright (c) 2014年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CommonCrypto/CommonDigest.h>

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

typedef void (^CDBlock)();

typedef void (^Int64Block)(int64_t num);

typedef void (^CDUpgradeBlock)(BOOL upgrade,NSString* oldVersion,NSString* newVersion);

@interface CDUtils : NSObject

+(void)alert:(NSString*)msg;

+(NSString*)md5OfString:(NSString*)s;

+(BOOL)alertError:(NSError*)error;

+(UIActivityIndicatorView*)showIndicatorAtView:(UIView*)hookView;

+(void)showNetworkIndicator;

+(void)hideNetworkIndicator;

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize;

+(UIImage *)roundImage:(UIImage *) image toSize:(CGSize)size radius: (float) radius;

+(void)pickImageFromPhotoLibraryAtController:(UIViewController*)controller;

+(BOOL)filterError:(NSError*)error;

+(void)filterError:(NSError*)error callback:(CDBlock)callback;

+(void)logError:(NSError*)error callback:(CDBlock)callbak;

+(void)hideNetworkIndicatorAndAlertError:(NSError*)error;

#pragma mark - collection utils
+(NSMutableArray*)setToArray:(NSMutableSet*)set;

+(NSArray*)reverseArray:(NSArray*)originArray;

#pragma mark - view utils
+(void)setCellMarginsZero:(UITableViewCell*)cell;

+(void)setTableViewMarginsZero:(UITableView*)view;

+(void)stopRefreshControl:(UIRefreshControl*)refreshControl;

#pragma mark - AVUtils

+(NSString*)uuid;

#pragma mark - async
+(void)runInGlobalQueue:(void (^)())queue;

+(void)runInMainQueue:(void (^)())queue;

+(void)runAfterSecs:(float)secs block:(void (^)())block;

+(void)postNotification:(NSString*)name;

+ (void)downloadWithUrl:(NSString *)url toPath:(NSString *)path;

#pragma mark - time

+(int64_t)int64OfStr:(NSString*)str;

+(NSString*)strOfInt64:(int64_t)num;

+(NSString*)currentVersion;

+(void)upgradeWithBlock:(CDUpgradeBlock)callback;

@end
