//
//  MyFavorVC.m
//  ejianzhi
//
//  Created by RAY on 15/4/18.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "MyFavorVC.h"
#import "applistCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "DateUtil.h"
#import "JianZhi.h"
#import "QiYeInfo.h"

@interface MyFavorVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    int skipTimes;
    NSMutableArray *recordArray;
    BOOL firstLoad;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyFavorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的收藏";

    [self tableViewInit];
}

- (void)tableViewInit{
    recordArray=[[NSMutableArray alloc]init];
    skipTimes=0;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self refreshData];
}

- (void)footRefreshData{
    
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhiShouCang"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=skipTimes*10;
    skipTimes++;
    [query includeKey:@"qiYeInfo"];
    [query includeKey:@"jianZhi"];
    [query whereKey:@"userObjectId" equalTo:[AVUser currentUser].objectId];
    
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

-(void)refreshData{
    
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhiShouCang"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=0;
    skipTimes=1;
    [query includeKey:@"qiYeInfo"];
    [query includeKey:@"jianZhi"];
    [query whereKey:@"userObjectId" equalTo:[AVUser currentUser].objectId];
    
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
    static NSString *Cellidentifier=@"applistCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"applistCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    NSInteger row=[indexPath row];
    AVObject *object=[recordArray objectAtIndex:row];
    applistCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
    JianZhi *jianzhiObject=[object objectForKey:@"jianZhi"];
    if (jianzhiObject) {
        cell.jobTitle.text=jianzhiObject.jianZhiTitle;
        
        cell.jobDistrict.text=jianzhiObject.jianZhiDistrict;
        
        cell.jobSalary.text=[jianzhiObject.jianZhiWage stringValue];
        
        cell.acceptNum.text=[jianzhiObject.jianZhiLuYongValue stringValue];
        
        cell.recuitNum.text=[NSString stringWithFormat:@"/%@人",[jianzhiObject.jianZhiRecruitment stringValue]];
    }
    
    
    QiYeInfo *qiYeInfoObject=[object objectForKey:@"qiYeInfo"];
    if (qiYeInfoObject) {
        cell.enterpriseName.text=[qiYeInfoObject objectForKey:@"qiYeName"];
    }
    
    if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"拒绝"])
        cell.statusImage.image= [UIImage imageNamed:@"rejected"];
    else if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"同意"])
        cell.statusImage.image= [UIImage imageNamed:@"passed"];
    else
        cell.statusImage.image= [UIImage imageNamed:@"notHandle"];
    
    cell.jobTimeLabel.text=[DateUtil stringFromDate2:object.createdAt];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
