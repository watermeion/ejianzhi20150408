//
//  UIColor+ColorFromArray.m
//  ejianzhi
//
//  Created by Mac on 4/24/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "UIColor+ColorFromArray.h"
#import  "PullServerManager.h"
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


+(UIColor*)colorForType:(NSString*)type
{
    NSUserDefaults *mysetting=[NSUserDefaults standardUserDefaults];
    NSDictionary *typeAndColorDict=[mysetting objectForKey:TypeListAndColor];
    NSArray *typeArray=[typeAndColorDict allKeys];
    if ([typeArray containsObject:type]) {
        UIColor *color=[UIColor colorRGBFromArray:[typeAndColorDict objectForKey:type]];
        return  color;
    }
    else
    {
        return nil;
    }
}
@end
