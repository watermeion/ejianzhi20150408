//
//  JobListTableViewController.h
//  EJianZhi
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"


@protocol JobListTableViewControllerHeaderAndFooterRefreshDelegate <NSObject>

-(void)executeHeaderFresh;
-(void)executeFooterFresh;

@end


@class MLJianZhiViewModel;
@interface JobListTableViewController : UITableViewController
@property BOOL  isFisrtView;
@property (weak,nonatomic)id<JobListTableViewControllerHeaderAndFooterRefreshDelegate> delegate;
@property (strong,nonatomic)MLJianZhiViewModel *viewModel;
@property BOOL isAutoLoad;
@property (strong,nonatomic)NSArray *resultsArray;

- (NSArray*)getViewModelResultsList;

-(void)firstLoad;

//可被子类重载的成员方法
- (void)addFooterRefresher;
- (void)addHeaderRefresher;
- (instancetype)initWithAutoLoad:(BOOL)autoload;
- (void)addDataSourceObbserver;



@end
