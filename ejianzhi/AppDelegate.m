//
//  AppDelegate.m
//  EJianZhi
//
//  Created by RAY on 14/12/23.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import "SMS_SDK/SMS_SDK.h"

//#import "MobClick.h"
#import "MLTabbarVC.h"
#import "MLLoginManger.h"
#import "PullServerManager.h"
//子类化
#import "User.h"
#import "JianZhi.h"
#import "UserDetail.h"
#import "JianZhiShenQing.h"
#import "QiYeInfo.h"

#import "MLTabbar1.h"
#import "SRLoginVC.h"

#import "CheckNewVersionVC.h"

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface AppDelegate ()

@property (strong,nonatomic)MLTabbarVC *mainTabViewController;
@property (strong,nonatomic)MLTabbar1 *qiyeTabViewController;
@property (strong,nonatomic)MLLoginManger *loginManager;
@end

@implementation AppDelegate

-(MLTabbarVC*)mainTabViewController
{
   if(_mainTabViewController==nil)
   {
       _mainTabViewController=[[MLTabbarVC alloc]init];
   }
    return _mainTabViewController;
}

-(MLTabbar1*)qiyeTabViewController
{
    if(_qiyeTabViewController==nil)
    {
        _qiyeTabViewController=[[MLTabbar1 alloc]init];
    }
    return _qiyeTabViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1];
    
    //注册子类化
    [JianZhi registerSubclass];
    [User registerSubclass];
    [UserDetail registerSubclass];

//AVOS Regist App Key origin
    [AVOSCloud setApplicationId:@"owqomw6mc9jlqcj7xc2p3mdk7h4hqe2at944fzt0zb8jholj"
                      clientKey:@"q9bmfdqt5926m2vgm54lu8ydwxz349448oo1fyu154b0izuw"];

    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //初始化各类控制器
    self.loginManager=[MLLoginManger shareInstance];
    PullServerManager *pullServerManager=[PullServerManager sharedIntance];
    [pullServerManager rewriteUserDefaults];
    


    
//    //1、注册登录变化通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginStateChange:)
//                                                 name:KNOTIFICATION_LOGINCHANGE
//                                               object:nil];
//    //
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
//        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(78, 188, 211, 1)];
//        [[UINavigationBar appearance] setTitleTextAttributes:
//         [NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
//    }

    
//    //友盟
//    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
//    NSLog(@"bundleID=%@",bundleID);
//    if ([bundleID isEqualToString:@"com.easemob.enterprise.demo.ui"]) {
//        [MobClick startWithAppkey:@"5389bb7f56240ba94208ac97"
//                     reportPolicy:BATCH
//                        channelId:Nil];
//#if DEBUG
//        [MobClick setLogEnabled:YES];
//#else
//        [MobClick setLogEnabled:NO];
//#endif
//    }
//    [MobClick startWithAppkey:@"54d0c830fd98c594f4000961"
//                 reportPolicy:BATCH
//                    channelId:Nil];
//#if DEBUG
//    [MobClick setLogEnabled:YES];
//#else
//    [MobClick setLogEnabled:NO];
//#endif
    
  
    //for ShareSDK
//    [ShareSDK registerApp:@"50de98338b9f"];
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
    
    //短信验证模块
    [SMS_SDK registerApp:@"56454b8585da" withSecret:@"17e36cd8f741167baa78e940456c238c"];

    
   
    
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
 
    if (SYSTEM_VERSION < 8.0) {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[SRLoginVC shareLoginVC]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //消除消息提示数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self checkVersion];
    
    return YES;
}

- (void)checkVersion{
    AVQuery *query=[AVQuery queryWithClassName:@"Version"];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error&&object) {
            NSString *vn=[object objectForKey:@"versionNumber"];
            if (![vn isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]]) {
                CheckNewVersionVC *checkVC=[[CheckNewVersionVC alloc]init];
                
                [self.window setRootViewController:checkVC];
                
            }
        }
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //聊天接收推送消息必需
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self showErrorWithTitle:@"Installation保存失败" error:error];
        }
    }];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [self showErrorWithTitle:@"开启推送失败" error:error];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{

}

- (void)showErrorWithTitle:(NSString *)title error:(NSError *)error {
    NSString *content = [NSString stringWithFormat:@"%@", error];
    NSLog(@"%@\n%@", title, content);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:content
                                                  delegate:nil
                                         cancelButtonTitle:@"知道了"
                                         otherButtonTitles:nil, nil];
    [alert show];
}


@end
