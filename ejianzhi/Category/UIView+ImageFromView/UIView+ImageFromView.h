//
//  UIView+ImageFromView.h
//  ejianzhi
//
//  Created by Mac on 4/24/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ImageFromView)

+(UIImage*)createImageFromView:(UIView*)view;
/**
 *  根据View生产对应的截图
 *
 *  @param orgView 目标View
 *
 *  @return UIImage  生产的截图
 */
-(UIImage *)getImageFromView:(UIView *)orgView;
@end
