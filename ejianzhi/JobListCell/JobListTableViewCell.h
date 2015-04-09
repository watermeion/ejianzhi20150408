//
//  JobListTableViewCell.h
//  EJianZhi
//
//  Created by Mac on 1/24/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "listBadgeView.h"
@interface JobListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countNumbersWithinUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabelWithinUnitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Icon3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *Icon2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *Icon1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *keyConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPeriodLabel;

@property (weak, nonatomic) IBOutlet listBadgeView *IconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end
