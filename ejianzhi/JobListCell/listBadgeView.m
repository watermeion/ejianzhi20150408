//
//  listBadgeView.m
//  EJianZhi
//
//  Created by Mac on 1/25/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "listBadgeView.h"


@implementation listBadgeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    
    if (self.type==WithBadge) {
        if(self.badgeText!=nil)
        {
            [self drawWithBadge];
        }
        else
        {
            [self DrawWithDefault];
        }
    }
    else if (self.type==WithOutBadge)
    {
            [self drawWithoutBadge];
    }
  
}

-(void)DrawWithDefault
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Badge Drawing
    UIBezierPath* badgePath = UIBezierPath.bezierPath;
    [badgePath moveToPoint: CGPointMake(27.5, 0.5)];
    [badgePath addLineToPoint: CGPointMake(0.5, 27.5)];
    [badgePath addLineToPoint: CGPointMake(0.5, 45.5)];
    [badgePath addLineToPoint: CGPointMake(45.5, 0.5)];
    [badgePath addLineToPoint: CGPointMake(27.5, 0.5)];
    [UIColor.whiteColor setFill];
    [badgePath fill];
    [UIColor.whiteColor setStroke];
    badgePath.lineWidth = 1;
    [badgePath stroke];
    
    
    //// ContentText Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 2, 25.51);
    CGContextRotateCTM(context, -45 * M_PI / 180);
    
    CGRect contentTextRect = CGRectMake(0, 0, 36, 12);
    NSMutableParagraphStyle* contentTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    contentTextStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* contentTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 12], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: contentTextStyle};
    
    [@"推荐" drawInRect: contentTextRect withAttributes: contentTextFontAttributes];
    
    CGContextRestoreGState(context);
}
-(void)drawWithoutBadge
{
    //// Color Declarations
    UIColor* color3 = GreenFillColor;
    
    //// backgroud Drawing
    UIBezierPath* backgroudPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 80, 80)];
    [color3 setFill];
    [backgroudPath fill];
    
    
    //// CategoryText Drawing
//    CGRect categoryTextRect = CGRectMake(18, 25, 44, 29);
//    {
//        NSString* textContent = @"派单";
//        NSMutableParagraphStyle* categoryTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
//        categoryTextStyle.alignment = NSTextAlignmentCenter;
//        
//        NSDictionary* categoryTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 19], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: categoryTextStyle};
//        
//        [textContent drawInRect: CGRectOffset(categoryTextRect, 0, (CGRectGetHeight(categoryTextRect) - [textContent boundingRectWithSize: categoryTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: categoryTextFontAttributes context: nil].size.height) / 2) withAttributes: categoryTextFontAttributes];
//    }


}





-(void)drawWithBadge
{
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color3 = GreenFillColor;
    
    //// backgroud Drawing
    UIBezierPath* backgroudPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 80, 80)];
    [color3 setFill];
    [backgroudPath fill];
    
    
    //// Badge Drawing
    UIBezierPath* badgePath = UIBezierPath.bezierPath;
    [badgePath moveToPoint: CGPointMake(27.5, 0.5)];
    [badgePath addLineToPoint: CGPointMake(0.5, 27.5)];
    [badgePath addLineToPoint: CGPointMake(0.5, 45.5)];
    [badgePath addLineToPoint: CGPointMake(45.5, 0.5)];
    [badgePath addLineToPoint: CGPointMake(27.5, 0.5)];
    [UIColor.whiteColor setFill];
    [badgePath fill];
    [UIColor.whiteColor setStroke];
    badgePath.lineWidth = 1;
    [badgePath stroke];
    
    
    //// ContentText Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 2, 25.51);
    CGContextRotateCTM(context, -45 * M_PI / 180);
    
    CGRect contentTextRect = CGRectMake(0, 0, 40, 12);
    NSMutableParagraphStyle* contentTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    contentTextStyle.alignment = NSTextAlignmentJustified;
    NSDictionary* contentTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 9], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: contentTextStyle};
    
    [self.badgeText drawInRect: contentTextRect withAttributes: contentTextFontAttributes];
    
    CGContextRestoreGState(context);

//    //// CategoryText Drawing
//    CGRect categoryTextRect = CGRectMake(18, 25, 44, 29);
//    {
//        NSString* textContent = @"";
//        NSMutableParagraphStyle* categoryTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
//        categoryTextStyle.alignment = NSTextAlignmentCenter;
//        
//        NSDictionary* categoryTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 19], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: categoryTextStyle};
//        
//        [textContent drawInRect: CGRectOffset(categoryTextRect, 0, (CGRectGetHeight(categoryTextRect) - [textContent boundingRectWithSize: categoryTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: categoryTextFontAttributes context: nil].size.height) / 2) withAttributes: categoryTextFontAttributes];
//    }


}


@end
