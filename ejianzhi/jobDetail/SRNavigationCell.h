//
//  SRNavigationCell.h
//  DaZhe
//
//  Created by RAY on 14/11/27.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRNavigationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *naviLine;
@property (weak, nonatomic) IBOutlet UILabel *naviTime;
@property (weak, nonatomic) IBOutlet UILabel *walkMeters;

@end
