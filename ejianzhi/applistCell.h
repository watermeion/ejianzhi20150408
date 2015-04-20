//
//  applistCell.h
//  ejianzhi
//
//  Created by RAY on 15/4/18.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "listBadgeView.h"

@interface applistCell : UITableViewCell

@property (strong, nonatomic) IBOutlet listBadgeView *badgeView;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobTitle;
@property (strong, nonatomic) IBOutlet UILabel *enterpriseName;
@property (strong, nonatomic) IBOutlet UIImageView *verifiedImage;
@property (strong, nonatomic) IBOutlet UILabel *jobTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobDistrict;
@property (strong, nonatomic) IBOutlet UILabel *jobSalary;
@property (strong, nonatomic) IBOutlet UILabel *acceptNum;
@property (strong, nonatomic) IBOutlet UILabel *recuitNum;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;

@end
