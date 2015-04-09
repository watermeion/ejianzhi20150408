//
//  MLLoginManger.h
//  EJianZhi
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

typedef NS_ENUM(NSInteger, State) {
    active=0,
    unactive=1,
};

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  登录注册控制器，拥有登录注册的页面。控制登录注册页面的弹出,控制登录状态等
 */
@interface MLLoginManger : NSObject

@property (assign,readonly) State LoginState;

+(MLLoginManger*)shareInstance;
-(UIViewController*)showLoginVC;
-(UIViewController*)showRegistVC;

-(void)setLoginState:(State)state;
@end
