//
//  SearchResultsViewController.m
//  ejianzhi
//
//  Created by Mac on 4/26/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "MJRefresh.h"
@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  重载table数据源监听
 */
-(void)addDataSourceObbserver
{
         @weakify(self)
        [RACObserve(self, resultsArray) subscribeNext:^(NSArray *x){
            @strongify(self)
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
