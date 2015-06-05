//
//  UserModel.h
//  EJianZhi
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

//自定义的UserModel 暂时还没有用到

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserState) {
    active=0,
    unactive=1,
    unexist=2,
};

@interface UserModel : NSObject

@property (strong,nonatomic)AVUser *avUser;
@property UserState status;


@end
