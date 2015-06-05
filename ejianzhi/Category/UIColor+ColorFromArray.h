//
//  UIColor+ColorFromArray.h
//  ejianzhi
//
//  Created by Mac on 4/24/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorFromArray)



/**
 *  从RGB 值Array eg：[12,233,129] 生成对应的color
 *
 *  @param rgb [red,green,blue] (float 0~255);
 *
 *  @return UIColor 对应的颜色值
 */
+(UIColor*)colorRGBFromArray:(NSArray*)rgb;
+(UIColor*)colorForType:(NSString*)type;

@end
