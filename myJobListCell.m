//
//  myJobListCell.m
//  ejianzhi
//
//  Created by RAY on 15/4/25.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "myJobListCell.h"

@implementation myJobListCell

- (void)awakeFromNib {
    [self.showResumeBtn.layer setCornerRadius:3];
    [self.showResumeBtn.layer setMasksToBounds:YES];
    
    [self.BkgView.layer setMasksToBounds:YES];
    [self.BkgView.layer setCornerRadius:10.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)showResumeList:(id)sender {
    [self.resumeDelegate showRelativeResume:self.index];
}


@end
