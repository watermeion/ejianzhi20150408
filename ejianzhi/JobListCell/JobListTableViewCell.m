//
//  JobListTableViewCell.m
//  EJianZhi
//
//  Created by Mac on 1/24/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "JobListTableViewCell.h"

@implementation JobListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.IconView.type=WithOutBadge;
    self.IconView.backgroundColor=GreenFillColor;
    //设置圆角
    [self.IconView.layer setMasksToBounds:YES];
    [self.IconView.layer setCornerRadius:10.0f];
    
    //
  
    self.distanceLabelWithinUnitLabel.layer.masksToBounds=YES;
    self.distanceLabelWithinUnitLabel.backgroundColor = [UIColor lightGrayColor];
    self.distanceLabelWithinUnitLabel.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setInsuranceImageShow:(BOOL)ishidden
{
    self.Icon1ImageView.hidden=ishidden;
}


- (void)setWeekendImageShow:(BOOL)ishidden
{
    self.Icon2ImageView.hidden=ishidden;
    
}
- (void)setotherImageShow:(BOOL)ishidden
{
    
    self.Icon3ImageView.hidden=ishidden;
    
}

- (void)setIconBackgroundColor:(UIColor*)color
{
    if(color==nil) self.IconView.backgroundColor=GreenFillColor;
    else self.IconView.backgroundColor=color;
}

@end
