//
//  CDCommonDefine.h
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#ifndef AVOSChatDemo_CDCommonDefine_h
#define AVOSChatDemo_CDCommonDefine_h

#define USE_US 0
#if !USE_US

#define AVOSAppID @"owqomw6mc9jlqcj7xc2p3mdk7h4hqe2at944fzt0zb8jholj"
#define AVOSAppKey @"q9bmfdqt5926m2vgm54lu8ydwxz349448oo1fyu154b0izuw"

//LeanChat-Public App
#define PublicAppId @"owqomw6mc9jlqcj7xc2p3mdk7h4hqe2at944fzt0zb8jholj"
#define PublicAppKey @"q9bmfdqt5926m2vgm54lu8ydwxz349448oo1fyu154b0izuw"

//Test App ，SMS Demo App
#define CloudAppId @"owqomw6mc9jlqcj7xc2p3mdk7h4hqe2at944fzt0zb8jholj"
#define CloudAppKey @"q9bmfdqt5926m2vgm54lu8ydwxz349448oo1fyu154b0izuw"

#else
//北美节点
#define AVOSAppID @"owqomw6mc9jlqcj7xc2p3mdk7h4hqe2at944fzt0zb8jholj"
#define AVOSAppKey @"q9bmfdqt5926m2vgm54lu8ydwxz349448oo1fyu154b0izuw"
#endif

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgb) [UIColor colorWithRed:((rgb) & 0xFF0000 >> 16)/255.0 green:((rgb) & 0xFF00 >> 8)/255.0 blue:((rgb) & 0xFF)/255.0 alpha:1.0]

#define NAVIGATION_COLOR_MALE RGBCOLOR(40,130,226)
#define NAVIGATION_COLOR_FEMALE RGBCOLOR(215,81,67)
#define NAVIGATION_COLOR_SQUARE RGBCOLOR(248,248,248)
#define NAVIGATION_COLOR_LEANCHAT RGBCOLOR(40,130,226)
#define NORMAL_BACKGROUD_COLOR RGBCOLOR(235,235,242)

#define NAVIGATION_COLOR NAVIGATION_COLOR_LEANCHAT

#define CD_FONT_COLOR RGBCOLOR(0,0,0)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define KEY_USERNAME @"KEY_USERNAME"
#define KEY_ISLOGINED @"KEY_ISLOGINED"

#define USERNAME_MIN_LENGTH 1
#define PASSWORD_MIN_LENGTH 1

#define FROM_USER @"fromUser"
#define TO_USER @"toUser"
#define STATUS @"status"
#define INSTALLATION @"installation"
#define SETTING @"setting"

#define CD_COMMON_ROW_HEIGHT 44

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define WEAKSELF  typeof(self) __weak weakSelf=self;

#endif
