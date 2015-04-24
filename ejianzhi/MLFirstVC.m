//
//  MLFirstVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFirstVC.h"
#import "SRAdvertisingView.h"
//#import "MLCell1.h"
#import "JobListTableViewCell.h"
#import "SRScanVC.h"
//#import "ResumeVC.h"
#import "JobDetailVC.h"
#import "MLJobListViewController.h"

#import "MJRefresh.h"
//
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

//所依赖的ViewModel
#import "MLJianZhiViewModel.h"
#import "MLJobDetailViewModel.h"
#import "JianZhi.h"
#import "JobListTableViewController.h"
#import "MLMainPageViewModel.h"
#import <UIAlertView+Blocks.h>
#import "JobListWithDropDownListVCViewController.h"
#import "AJLocationManager.h"

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7


#import "SearchViewController.h"

@interface MLFirstVC ()<ValueClickDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *collectionViewCellArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *middleScrollView;

//@property (strong,nonatomic) MLJianZhiViewModel *jianzhiViewModel;

@property (strong,nonatomic) JobListTableViewController *joblistTableVC;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView2;
@property (weak, nonatomic) IBOutlet SRAdvertisingView *blankView;
@property (strong,nonatomic)MLMainPageViewModel *viewModel;


//不同类型的兼职Btn
//@property (weak, nonatomic) IBOutlet UIButton *morejobBtn;
//@property (weak, nonatomic) IBOutlet UIButton *homeTeacherBtn;
//@property (weak, nonatomic) IBOutlet UIButton *modelBtn;
//@property (weak, nonatomic) IBOutlet UIButton *itWorkBtn;

- (IBAction)itWorkBtnAction:(id)sender;

- (IBAction)modelBtnAction:(id)sender;

- (IBAction)homeTeacherBtnAction:(id)sender;

- (IBAction)moreBtnAction:(id)sender;


//cellView
@property (strong, nonatomic) IBOutlet UIView *modelView;

@property (strong, nonatomic) IBOutlet UIView *ItView;
@property (strong, nonatomic) IBOutlet UIView *homeTeachweView;
@property (strong, nonatomic) IBOutlet UIView *moreView;

//action
- (IBAction)findJobWithLocationAction:(id)sender;


- (IBAction)findJobWithCardAction:(id)sender;

- (IBAction)jobAsTeacherAction:(id)sender;

- (IBAction)jobAsAccountingAction:(id)sender;
- (IBAction)jobAsModelAction:(id)sender;

- (IBAction)jobAsOutseaStuAction:(id)sender;

@end

@implementation MLFirstVC
@synthesize tableHeadView=_tableHeadView;


-(instancetype)init
{
    if(self=[super init])
    {
        self.joblistTableVC=[[JobListTableViewController alloc]initWithAutoLoad:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *searchbarImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBar"]];
    
    searchbarImageView.userInteractionEnabled=YES;
    //为searchBar添加操作
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarTapped)];
    [searchbarImageView addGestureRecognizer:singleTap];
    
    self.navigationItem.titleView=searchbarImageView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(Location)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近兼职" style:UIBarButtonItemStylePlain target:self action:@selector(findJobWithLocationAction:)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    self.viewModel=[[MLMainPageViewModel alloc]init];
    [self addChildViewController:self.joblistTableVC];
    //collectiveViewCell
    collectionViewCellArray=[NSArray arrayWithObjects:self.modelView,self.ItView,self.homeTeachweView,self.moreView,nil];
    [self addViewToScrollView];
    [self addHeaderAndFooterToTableView];
    [self.view addSubview: self.joblistTableVC.tableView];
    [self advertisementInit];
    //监听城市信息
    RAC(self.navigationItem.leftBarButtonItem,title)=RACObserve(self.viewModel, cityName);
    [self.viewModel startLocatingToGetCity];
    [self searchCity];
}

-(void)searchBarTapped
{
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)addViewToScrollView
{
    CGFloat edgewidth=2.0;
    CGFloat width = 60.0f;
    CGFloat marginwidth=(MainScreenWidth-(4*edgewidth)-4*width)/3;
    int count=[collectionViewCellArray count];
    for (int i=0; i<[collectionViewCellArray count]; i++) {
        UIView *view=[collectionViewCellArray objectAtIndex:i];
        if(i==0){
            view.frame=CGRectMake(edgewidth,0,width,view.frame.size.height);
        }else
        {
            view.frame=CGRectMake((edgewidth+(width+marginwidth)*(i)),0,width, view.frame.size.height);
        }
        [self.middleScrollView addSubview:view];
    }
    self.middleScrollView.contentSize=CGSizeMake((width+marginwidth)*count,80);
    //    self.middleScrollView.pagingEnabled=YES;
}


-(void)addHeaderAndFooterToTableView
{
    //添加表头
    [_tableHeadView2 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 112+130*[[UIScreen mainScreen] bounds].size.width/320)];
    //    [_tableHeadView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 284+130*[[UIScreen mainScreen] bounds].size.width/320)];
    [self.joblistTableVC.tableView setTableHeaderView:_tableHeadView2];
    //添加表尾
    [self.joblistTableVC addFooterRefresher];
}

//*********************tableView********************//
//- (void)tableViewInit{
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    [_tableView setDelegate:self];
//    [_tableView setDataSource:self];
//    _tableView.scrollEnabled=YES;
//    [_tableHeadView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 284+130*[[UIScreen mainScreen] bounds].size.width/320)];
//    [_tableView setTableHeaderView:_tableHeadView];
//
//    //为tableView 添加下拉刷新
////     [_tableView addFooterWithTarget:self.jianzhiViewModel action:@selector(footerRefresh)];
//}

//
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
////    BOOL nibsRegistered = NO;
////
////    static NSString *Cellidentifier=@"MLCell1";
////    if (!nibsRegistered) {
////        UINib *nib = [UINib nibWithNibName:@"MLCell1" bundle:nil];
////        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
////        nibsRegistered = YES;
////    }
////
////    MLCell1 *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
////    cell.accessoryType=UITableViewCellAccessoryNone;
////
////    NSUInteger row=[indexPath row];
//    BOOL nibsRegistered = NO;
//    static NSString *Cellidentifier=@"JobListTableViewCell";
//    if (!nibsRegistered) {
//        UINib *nib = [UINib nibWithNibName:@"JobListTableViewCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
//    }
//
//    JobListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
//    //设置兼职信息列表内容
//
//    JianZhi *jianzhi=[self.jianzhiViewModel.resultsList objectAtIndex:indexPath.row];
//
//    cell.titleLabel.text=jianzhi.jianZhiTitle;
//    cell.categoryLabel.text=jianzhi.jianZhiType;
//    cell.priceLabel.text=[jianzhi.jianZhiWage stringValue];
//    cell.payPeriodLabel.text=[NSString stringWithFormat:@"/%@",jianzhi.jianZhiWageType];
//    cell.keyConditionLabel.text=jianzhi.jianzhiTeShuYaoQiu;
//
//    cell.countNumbersWithinUnitsLabel.text=[NSString stringWithFormat:@"%d/%d人",[jianzhi.jianZhiQiYeLuYongValue intValue],[jianzhi.jianZhiRecruitment intValue]];
//    //待完善
//    cell.distanceLabelWithinUnitLabel.text=[NSString stringWithFormat:@"%@km",@"10"];
//    cell.IconView.badgeText=@"";
//    //兼职的IconView
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    if (self.jianzhiViewModel.resultsList==nil) {
//        return cellNum;
//    }
//    return self.jianzhiViewModel.resultsList.count;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
////改变行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 120;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    JobDetailVC *detailVC=[[JobDetailVC alloc]initWithData:[self.jianzhiViewModel.resultsList objectAtIndex:indexPath.row]];
//    detailVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
//}
//
//- (void)deselect
//{
//    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
//}



/**
 *  位置定位
 *  逻辑是进入首页先自动定位 如果失败再让用户手选，和美团一样
 */
- (void)Location{
    //显示位置信息，用户位置信息
    RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"知道了" action:^{
        NSLog(@"Press Button Cancel");
    }];
    RIButtonItem *otherButtonItem = [RIButtonItem itemWithLabel:@"确定" action:^{
        NSLog(@"Press Button OK");
        //初始化城市列表
    }];
    
    
    NSString *message=[NSString stringWithFormat:@"目前仅支持北京地区，其他地区敬请期待",self.viewModel.cityName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message: message cancelButtonItem:cancelButtonItem otherButtonItems:nil];
    [alert show];
}


#pragma --mark 分享功能
- (void)shareJob{
    RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"知道了" action:^{
        NSLog(@"Press Button OK");
        //初始化城市列表
    }];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"抱歉，社交分享正在女里开发中...精彩敬请期待" cancelButtonItem:cancelButtonItem otherButtonItems: nil];
    [alert show];
    
}

//*********************Banner********************//
#pragma --mark BannerView Method
-(void)advertisementInit{
    
    
    NSMutableArray *urlArray=[[NSMutableArray alloc]init];
    
    
    [urlArray addObject:@"http://ac-owqomw6m.clouddn.com/ErzHmJ4LNySmB0gqSp24kiyBIhrzdtgPyV7kl1vr.jpg"];
    [urlArray addObject:@"http://ac-owqomw6m.clouddn.com/89mEekkp8LryD9jri7CUtY1dXcbRHcrNXns12Ki9.jpeg"];
    
    [urlArray addObject:@"http://ac-owqomw6m.clouddn.com/hcezPG2bM2jYxaGhuntYhGxAy6ukprbFXwmuww03.jpg"];
    [urlArray addObject:@"http://ac-owqomw6m.clouddn.com/xaXWxJE7BcFS6CDG3nTLxjtGi210hwDE7WsM0N0A.gif"];
    
    
    
    SRAdvertisingView *bannerView=[[SRAdvertisingView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 130*[[UIScreen mainScreen] bounds].size.width/320) imageArray:urlArray interval:3.0];
    
    bannerView.vDelegate=self;
    [self.blankView addSubview:bannerView];
}


/**
 *  banner 点击时间
 *
 *  @param vid <#vid description#>
 */
- (void)buttonClick:(int)vid{
    
    
    
    
    
}



//-(void)setupCamera
//{
//    if(IOS7)
//    {
//        SRScanVC * scanVC = [[SRScanVC alloc]init];
//        scanVC.scanDelegate=self;
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//        backItem.title = @"";
//        backItem.tintColor=[UIColor whiteColor];
//        self.navigationItem.backBarButtonItem = backItem;
//        scanVC.hidesBottomBarWhenPushed=YES;
//
//        [self.navigationController pushViewController:scanVC animated:YES];
//
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma --mark  选择附近的兼职 按钮事件
- (IBAction)findJobWithLocationAction:(id)sender {
    JobListWithDropDownListVCViewController *nearByList=[[JobListWithDropDownListVCViewController alloc]init];
    nearByList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nearByList animated:YES];
    
}

- (IBAction)findJobWithCardAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsTeacherAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsAccountingAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsModelAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsOutseaStuAction:(id)sender {
    [self showListView];
}



#pragma --mark  ListViewInit Method

-(void)showListView
{
    JobListWithDropDownListVCViewController *nearByList=[[JobListWithDropDownListVCViewController alloc]init];
    nearByList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nearByList animated:YES];
}

- (void)searchCity
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    //获得用户位置信息
    [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [mySettingData setObject:NSStringFromCGPoint(CGPointMake(locationCorrrdinate.longitude, locationCorrrdinate.latitude)) forKey:@"currentCoordinate"];
        [mySettingData synchronize];
        
    } error:^(NSError *error) {
        
        
    }];
}

- (IBAction)itWorkBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    [joblistWithDrowList setCurrentType:@"开发"];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}

- (IBAction)modelBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    [joblistWithDrowList setCurrentType:@"模特"];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}

- (IBAction)homeTeacherBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    [joblistWithDrowList setCurrentType:@"家教"];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}

- (IBAction)moreBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}


@end
