//
//  MLContactCell.h
//  EJianZhi
//
//  Created by RAY on 15/3/28.
//  Copyright (c) 2015年 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

@interface MLContactCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userPortraitView;
@property (strong, nonatomic) IBOutlet UILabel *userTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *conversationLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (strong, nonatomic) JSBadgeView*badgeView;
@property (strong, nonatomic) IBOutlet UILabel *bkgLabel;

@end
