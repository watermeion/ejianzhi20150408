//
//  imageWithUrlObject.h
//  EJianZhi
//
//  Created by RAY on 15/4/6.
//  Copyright (c) 2015年 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageWithUrlObject : NSObject
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *url;
- (void)loadImageWithUrl;
- (imageWithUrlObject*)initWithUrl:(NSString*)url;
- (imageWithUrlObject*)initWithUrl:(NSString*)url AndImage:(UIImage*)image;
- (imageWithUrlObject*)initWithImage:(UIImage*)image;
@end
