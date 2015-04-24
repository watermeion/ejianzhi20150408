//
//  UIView+ImageFromView.m
//  ejianzhi
//
//  Created by Mac on 4/24/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "UIView+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ImageFromView)

+(UIImage*)createImageFromView:(UIView*)view

{

    //obtain scale
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
//    开始绘图，下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width,
                                                      view.frame.size.height),
                                           NO,
                                           scale);
//    将view上的子view加进来
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    //开始生成图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image; 
}

-(UIImage *)getImageFromView:(UIView *)orgView{
    
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//    
//    [self.view.layerrenderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  return image;
}
@end
