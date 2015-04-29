//
//  UIColor+ColorFromArray.m
//  ejianzhi
//
//  Created by Mac on 4/24/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "UIColor+ColorFromArray.h"

@implementation UIColor (ColorFromArray)


+(UIColor*)colorRGBFromArray:(NSArray*)rgb
{
    if (rgb!=nil && rgb.count==3 ) {
        CGFloat redvalue=[[rgb objectAtIndex:0] floatValue]/255;
        CGFloat greedvalue=[[rgb objectAtIndex:1] floatValue]/255;
        CGFloat bluevalue=[[rgb objectAtIndex:2] floatValue]/255;
        UIColor *rgbColor=[UIColor colorWithRed:redvalue green:greedvalue blue:bluevalue alpha:1.0f];
        return rgbColor;
    }
    return nil;
}
@end
