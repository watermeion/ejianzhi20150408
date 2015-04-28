//
//  JobListTableViewCell+configureForJobCell.h
//  ejianzhi
//
//  Created by Mac on 4/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "JobListTableViewCell.h"
#import "JianZhi.h"
@interface JobListTableViewCell (configureForJobCell)

- (void)configureForJob:(JianZhi*)job;
-(UIColor*)colorForType:(NSString*)type;
@end
