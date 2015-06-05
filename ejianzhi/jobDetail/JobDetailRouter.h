//
//  JobDetailRouter.h
//  EJianZhi
//
//  Created by Mac on 4/1/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//



/**
 *  此类设计是控制jobdetail界面跳转逻辑
 *  功能:1、保存当前展示页面
 *       2、保存跳转动画等
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JobDetailRouter : NSObject


@property (strong,nonatomic) UIViewController *presentedViewController;




@end
