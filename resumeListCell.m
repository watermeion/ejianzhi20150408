//
//  resumeListCell.m
//  ejianzhi
//
//  Created by RAY on 15/5/1.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "resumeListCell.h"

@implementation resumeListCell

- (void)awakeFromNib {
    [self.userImageView.layer setCornerRadius:5];
    [self.userImageView.layer setMasksToBounds:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
