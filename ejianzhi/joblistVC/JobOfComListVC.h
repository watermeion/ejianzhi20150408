//
//  JobOfComListVC.h
//  ejianzhi
//
//  Created by Mac on 4/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "JobListTableViewController.h"
//继承自JobListTableViewControl 重载firstLoad方法
@interface JobOfComListVC : JobListTableViewController
@property id company;
-(void)setCompanyAndQuery:(id)company;
@end
