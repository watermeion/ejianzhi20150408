//
//  JobListTableViewController.h
//  EJianZhi
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLJianZhiViewModel;
@interface JobListTableViewController : UITableViewController

@property (strong,nonatomic) MLJianZhiViewModel *viewModel;
@property BOOL isAutoLoad;
- (NSArray*)getViewModelResultsList;

-(void)firstLoad;
- (void)addFooterRefresher;

- (void)addHeaderRefresher;
- (instancetype)initWithAutoLoad:(BOOL)autoload;
@end
