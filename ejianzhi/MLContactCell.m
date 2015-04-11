//
//  MLContactCell.m
//  EJianZhi
//
//  Created by RAY on 15/3/28.
//  Copyright (c) 2015年 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "MLContactCell.h"



@implementation MLContactCell

- (void)awakeFromNib {
    
    [self.userPortraitView.layer setCornerRadius:CGRectGetHeight(self.userPortraitView.bounds)/2];
    [self.userPortraitView.layer setMasksToBounds:YES];
    
    UIView *bkgView=[[UIView alloc]initWithFrame:CGRectMake(self.userPortraitView.frame.origin.x, self.userPortraitView.frame.origin.y+8, self.userPortraitView.frame.size.width, self.userPortraitView.frame.size.height)];
    bkgView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:bkgView];
    
    
    if (!self.badgeView) {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:bkgView alignment:JSBadgeViewAlignmentTopRight];
        [bkgView addSubview:self.badgeView];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
