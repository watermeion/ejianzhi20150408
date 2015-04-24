//
//  MyApplicationList.m
//  ejianzhi
//
//  Created by RAY on 15/4/18.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "MyApplicationList.h"
#import "DVSwitch.h"
#import "applistCell.h"
#import "MJRefresh.h"
#import "JianZhiShenQing.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "DateUtil.h"
#import "JobDetailVC.h"
@interface MyApplicationList ()<UITableViewDataSource,UITableViewDelegate>{
    DVSwitch *switcher;
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    int skipTimes;
    NSMutableArray *recordArray;
    BOOL firstLoad;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *appStatus;
@end

@implementation MyApplicationList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的申请";
    
    self.appStatus=@"未处理";
    
    [self switcherInit];
    
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
    
    AVQuery *query=[JianZhiShenQing query];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=skipTimes*10;
    skipTimes++;
    [query includeKey:@"qiYeInfo"];
    [query includeKey:@"jianZhi"];
    
    if ([self.appStatus length]>0) {
        [query whereKey:@"enterpriseHandleResult" equalTo:self.appStatus];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            for (JianZhiShenQing *obj in objects) {
                
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
    
    AVQuery *query=[JianZhiShenQing query];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=0;
    skipTimes=1;
    [query includeKey:@"qiYeInfo"];
    [query includeKey:@"jianZhi"];
    
    if ([self.appStatus length]>0) {
        [query whereKey:@"enterpriseHandleResult" equalTo:self.appStatus];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            if (headerRefreshing) {
                [recordArray removeAllObjects];
            }
            
            for (JianZhiShenQing *obj in objects) {
                
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


- (void)switcherInit{
    switcher = [DVSwitch switchWithStringsArray:@[@"申请中", @"已录用", @"全部"]];
    switcher.frame = CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 44);
    switcher.backgroundColor = [UIColor whiteColor];
    switcher.sliderColor = [UIColor colorWithRed:0.16 green:0.73 blue:0.65 alpha:1.0];
    switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    switcher.labelTextColorOutsideSlider = [UIColor blackColor];
    switcher.cornerRadius = 0;
    switcher.sliderType=lineSlider;
    
    __weak typeof(self) weakSelf = self;
    
    [switcher setWillBePressedHandler:^(NSUInteger index) {
        if (index==0){
            weakSelf.appStatus=@"未处理";
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf headerRereshing];

        }
        else if (index==1){
            weakSelf.appStatus=@"同意";
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf headerRereshing];
        }
        else if (index==2){
            weakSelf.appStatus=nil;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf headerRereshing];
        }
    }];
    
    [self.view addSubview:switcher];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    JianZhiShenQing *object=[recordArray objectAtIndex:row];
    applistCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
    JianZhi *jianzhiObject=[object objectForKey:@"jianZhi"];
    cell.jobTitle.text=jianzhiObject.jianZhiTitle;
    
    QiYeInfo *qiYeInfoObject=[object objectForKey:@"qiYeInfo"];
    cell.enterpriseName.text=[qiYeInfoObject objectForKey:@"qiYeName"];
    
    if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"拒绝"])
        cell.statusImage.image= [UIImage imageNamed:@"rejected"];
    else if ([[object objectForKey:@"enterpriseHandleResult"] isEqual:@"同意"])
        cell.statusImage.image= [UIImage imageNamed:@"passed"];
    else
        cell.statusImage.image= [UIImage imageNamed:@"notHandle"];
    
    cell.jobTimeLabel.text=[DateUtil stringFromDate2:object.createdAt];
    
    cell.jobDistrict.text=jianzhiObject.jianZhiDistrict;
    
    cell.jobSalary.text=[jianzhiObject.jianZhiWage stringValue];
    
    cell.acceptNum.text=[jianzhiObject.jianZhiLuYongValue stringValue];
    
    cell.recuitNum.text=[NSString stringWithFormat:@"/%@人",[jianzhiObject.jianZhiRecruitment stringValue]];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AVObject *object=[recordArray objectAtIndex:indexPath.row];
    JianZhi *jianzhi=[object objectForKey:@"jianZhi"];
    JobDetailVC *detailVC=[[JobDetailVC alloc]initWithData:jianzhi];
    detailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    
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
