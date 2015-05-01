//
//  myJobListVC.m
//  ejianzhi
//
//  Created by RAY on 15/4/28.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "myJobListVC.h"
#import "myJobListCell.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "JianZhi.h"
#import "QiYeInfo.h"
#import "resumeListVC.h"
#import "JianZhi.h"

@interface myJobListVC ()<UITableViewDataSource,UITableViewDelegate,resumeDelegate>
{
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    int skipTimes;
    NSMutableArray *recordArray;
    BOOL firstLoad;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation myJobListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我发布的兼职";
    
    [self tableViewInit];
}

- (void)tableViewInit{
    if (!recordArray) {
        recordArray=[[NSMutableArray alloc]init];
    }
    
    skipTimes=0;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self refreshData];
}

-(void)refreshData{
    
    AVQuery *userQuery=[AVUser query];
    [userQuery whereKey:@"mobilePhoneNumber" equalTo:@"18511007524"];
    
    AVQuery *innerQuery=[AVQuery queryWithClassName:@"QiYeInfo"];

    [innerQuery whereKey:@"qiYeUser" matchesQuery:userQuery];

    
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhi"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=0;
    skipTimes=1;
    [query whereKey:@"jianZhiQiYe" matchesQuery:innerQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            if (headerRefreshing) {
                [recordArray removeAllObjects];
            }
            
            for (AVObject *obj in objects) {
                
                [recordArray addObject:obj];
                
            }
            
            [self.tableView reloadData];
            
            if (headerRefreshing) {
                [self.tableView headerEndRefreshing];
                headerRefreshing=NO;
            }
            
        } else {
            
            if (footerRefreshing) {
                [self.tableView footerEndRefreshing];
                footerRefreshing=NO;
            }
            
            [MBProgressHUD showError:@"服务器开小差了，请刷新试试" toView:self.view];
            
        }
    }];
    query=nil;
    userQuery=nil;
    innerQuery=nil;
}

- (void)footRefreshData{
    
    AVQuery *userQuery=[AVUser query];
    [userQuery whereKey:@"mobilePhoneNumber" equalTo:@"18511007524"];
    
    AVQuery *innerQuery=[AVQuery queryWithClassName:@"QiYeInfo"];
    
    [innerQuery whereKey:@"qiYeUser" matchesQuery:userQuery];
    
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhi"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=skipTimes*10;
    skipTimes++;

    [query whereKey:@"jianZhiQiYe" matchesQuery:innerQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            for (AVObject *obj in objects) {
                
                [recordArray addObject:obj];
                
            }
            
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
            
            NSInteger n=[recordArray count];
            NSInteger m=[objects count];
            
            for (NSInteger k=n-m; k<[recordArray count];k++) {
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:k inSection:0];
                [insertIndexPaths addObject:newPath];
            }
            
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView footerEndRefreshing];
            
            footerRefreshing=NO;
            
        } else {
            
            if (footerRefreshing) {
                [self.tableView footerEndRefreshing];
                footerRefreshing=NO;
            }
            
            [MBProgressHUD showError:@"服务器开小差了，请刷新试试" toView:self.view];
            
        }
    }];
    query=nil;
}


- (void)footerRereshing{
    footerRefreshing=YES;
    [self footRefreshData];
}

- (void)headerRereshing{
    headerRefreshing=YES;
    skipTimes=0;
    [self refreshData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recordArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"myJobListCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"myJobListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    NSInteger row=[indexPath row];
    
    myJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    cell.resumeDelegate=self;
    cell.index=row;
    
    JianZhi *object=[recordArray objectAtIndex:row];
    
    cell.jobTitleLabel.text= [object objectForKey:@"jianZhiTitle"];
    cell.resumeNumLabel.text= [NSString stringWithFormat:@"共收到%@份简历",[object objectForKey:@"jianZhiQiYeResumeValue"]];
    cell.jobSalaryLabel.text=[NSString stringWithFormat:@"%@元/月",[object objectForKey:@"jianZhiWage"]];
    
    NSInteger n=[[object objectForKey:@"jianZhiRecruitment"] integerValue]-[[object objectForKey:@"jianZhiQiYeLuYongValue"] integerValue];
    if (n<0)
        n=0;

    cell.recruitInfoLabel.text= [NSString stringWithFormat:@"已录用%@人，还缺%ld人，浏览%@次",[object objectForKey:@"jianZhiQiYeLuYongValue"],(long)n,[object objectForKey:@"jianZhiBrowseTime"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deselect];
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)showRelativeResume:(NSInteger)index{
    JianZhi *object=[recordArray objectAtIndex:index];
    resumeListVC *resumeVC=[[resumeListVC alloc]init];
    resumeVC.jobObject=object;
    [self.navigationController pushViewController:resumeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
