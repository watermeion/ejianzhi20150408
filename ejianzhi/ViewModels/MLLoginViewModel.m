//
//  MLLoginViewModel.m
//  EJianZhi
//
//  Created by Mac on 3/19/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "MLLoginViewModel.h"

@implementation MLLoginViewModel

/**
 *  对象初始化方法
 *
 *  @return instancetype
 */
-(instancetype)init
{
    self=[super init];
    if (self==nil) return nil ;
    self.loginManager=[MLLoginManger shareInstance];
    return self;
}




@end
