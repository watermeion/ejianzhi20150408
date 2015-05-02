//
//  resumeListCell.h
//  ejianzhi
//
//  Created by RAY on 15/5/1.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resumeListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *resumeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *resumeSubTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *resumeThirdLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@end
