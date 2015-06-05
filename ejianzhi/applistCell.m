//
//  applistCell.m
//  ejianzhi
//
//  Created by RAY on 15/4/18.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "applistCell.h"

@implementation applistCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self.badgeView.layer setMasksToBounds:YES];
    [self.badgeView.layer setCornerRadius:10.0f];
}

@end
