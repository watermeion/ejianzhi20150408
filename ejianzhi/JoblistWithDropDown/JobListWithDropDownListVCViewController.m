//
//  JobListWithDropDownListVCViewController.m
//  EJianZhi
//
//  Created by Mac on 3/27/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "JobListWithDropDownListVCViewController.h"
#import "JobListTableViewController.h"
#import "FliterTableViewController.h"
#import "MapViewController.h"
#import "MLJianZhiViewModel.h"
@interface JobListWithDropDownListVCViewController ()<FliterTableViewControllerDelegate>
{
    const NSArray *type;
    const NSArray *settlement;
    const NSArray *other;
}


@property (strong, nonatomic) IBOutlet UIView *tableViewHeaderView;

@property (weak, nonatomic) IBOutlet UIButton *selectedAreaBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedSettlementWayBtn;
- (IBAction)selectSettlementAction:(id)sender;
- (IBAction)selectTypeAction:(id)sender;
- (IBAction)selectAreaAction:(id)sender;

@property (strong,nonatomic) JobListTableViewController *tableList;

@property (strong,nonatomic)FliterTableViewController *fliterTableView;
@end

@implementation JobListWithDropDownListVCViewController



-(instancetype)init
{
    if(self=[super init])
    {
        self.tableList=[[JobListTableViewController alloc]init];
        self.currentType=@"不限";
        self.currentFilterWay=@"最新";
        self.currentSettlement=@"不限";
           }
    return self;
}


-(FliterTableViewController *)fliterTableView
{
    if(_fliterTableView==nil)
    {
        _fliterTableView=[[FliterTableViewController alloc]init];
        _fliterTableView.delegate=self;
    }
    return _fliterTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图显示" style:UIBarButtonItemStylePlain target:self action:@selector(showInMap)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.tableList.tableView.frame=CGRectMake(0, 44, self.view.frame.size.width,self.view.frame.size.height-44);
    [self.tableList addHeaderRefresher];
    [self.tableList addFooterRefresher];
    [self addChildViewController:self.tableList];
    [self.view addSubview:self.tableList.view];
    //RAC
    [RACObserve(self, currentType) subscribeNext:^(NSString *x) {
        [self.selectedTypeBtn setTitle:[NSString stringWithFormat:@"类型:%@",self.currentType] forState:UIControlStateNormal];
    }];
    [RACObserve(self, currentSettlement) subscribeNext:^(NSString *x) {
        [self.selectedSettlementWayBtn setTitle:[NSString stringWithFormat:@"结算方式:%@",x] forState:UIControlStateNormal];
    }];
    [RACObserve(self, currentFilterWay) subscribeNext:^(NSString *x) {
        [self.selectedAreaBtn setTitle:[NSString stringWithFormat:@"筛选:%@",x] forState:UIControlStateNormal];
    }];
    [self.tableList.viewModel performSelector:@selector(setTypeQuery:) withObject:self.currentType afterDelay:0.1f];
    [self.tableList addHeaderRefresher];
}

-(void)viewDidAppear:(BOOL)animated
{
    //因为几个view创建的时间周期不同
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

-(void)showInMap
{
    MapViewController *mapVC=[[MapViewController alloc]init];
    mapVC.hidesBottomBarWhenPushed=YES;
    //传入数据
    [mapVC setDataArray:[self.tableList getViewModelResultsList]];
    [self.navigationController pushViewController:mapVC animated:YES];
    
}


- (IBAction)selectSettlementAction:(id)sender {
    
    NSArray *array=[[NSUserDefaults standardUserDefaults]objectForKey:FliterSettlementWay];
    settlement=array;
    self.fliterTableView.datasource=array;
    self.fliterTableView.viewType=FliterViewTypeSettlement;
    //获取现在状态
    NSInteger row=[array indexOfObject:self.currentSettlement];
    if (row!=NSNotFound) self.fliterTableView.row=row;
    else self.fliterTableView.row=0;
    
    [self showFliterTableView];
}

- (IBAction)selectTypeAction:(id)sender {
    NSArray *array=[[NSUserDefaults standardUserDefaults]objectForKey:FliterType];
    type=array;
    self.fliterTableView.datasource=array;
    self.fliterTableView.viewType=FliterViewTypeType;
    NSInteger row=[array indexOfObject:self.currentType];
    if (row!=NSNotFound) self.fliterTableView.row=row;
    else self.fliterTableView.row=0;
    [self showFliterTableView];
    
}

- (IBAction)selectAreaAction:(id)sender {
    NSArray *array=[[NSUserDefaults standardUserDefaults]objectForKey:FliterReDu];
    other=array;
    self.fliterTableView.datasource=array;
    self.fliterTableView.viewType=FliterViewTypeArea;
    NSInteger row=[array indexOfObject:self.currentFilterWay];
    if (row!=NSNotFound) self.fliterTableView.row=row;
    else self.fliterTableView.row=0;
    [self showFliterTableView];
}


-(void)showFliterTableView
{
    if(self.fliterTableView!=nil)
    {
        self.fliterTableView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:self.fliterTableView animated:YES];
        
    }
}

-(void)selectedResults:(NSString *)result ViewType:(FliterViewType)viewtype
{
    //刷新列表；
    NSLog(@"筛选：%@",result);
    //可查询字段
    //判断
    switch (viewtype) {
        case FliterViewTypeSettlement:
            [self.tableList.viewModel setSettlementQuery:result];
            self.currentSettlement=result;
            break;
        case FliterViewTypeType:
            [self.tableList.viewModel setTypeQuery:result];
            self.currentType=result;
            break;
        case FliterViewTypeArea:
            [self.tableList.viewModel setOtherQuery:result];
            self.currentFilterWay=result;
            break;
    }
}

@end
