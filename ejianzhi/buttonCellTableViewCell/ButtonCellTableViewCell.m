//
//  ButtonCellTableViewCell.m
//  EJianZhi
//
//  Created by Mac on 2/5/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "ButtonCellTableViewCell.h"

@implementation ButtonCellTableViewCell

- (IBAction)messageRepeatedApplyAction:(id)sender {
    NSLog(@"touch MessageRepeated Btn");
}


- (IBAction)cancelApplicationAction:(id)sender {
     NSLog(@"touch cancel Btn");
}

- (IBAction)friendAsTeamAction:(id)sender {
     NSLog(@"touch friendsAsTeam Btn");
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
