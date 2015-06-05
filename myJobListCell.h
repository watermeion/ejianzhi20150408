//
//  myJobListCell.h
//  ejianzhi
//
//  Created by RAY on 15/4/25.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol resumeDelegate <NSObject>
@required
- (void)showRelativeResume:(NSInteger)index;
@end

@interface myJobListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *resumeNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobSalaryLabel;
@property (strong, nonatomic) IBOutlet UILabel *recruitInfoLabel;
@property (nonatomic) NSInteger index;
@property(nonatomic,weak) id<resumeDelegate> resumeDelegate;
@property (strong, nonatomic) IBOutlet UIButton *showResumeBtn;
@property (strong, nonatomic) IBOutlet UIView *BkgView;
@end
