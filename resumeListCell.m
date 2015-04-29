//
//  resumeListCell.m
//  ejianzhi
//
//  Created by RAY on 15/4/29.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "resumeListCell.h"

@implementation resumeListCell

- (void)awakeFromNib {
    
    [self.userAvatarView.layer setCornerRadius:CGRectGetHeight(self.userAvatarView.bounds)/2];
    [self.userAvatarView.layer setMasksToBounds:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
