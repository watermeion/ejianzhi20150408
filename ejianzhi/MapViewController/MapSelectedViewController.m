//
//  MapSelectedViewController.m
//  ejianzhi
//
//  Created by Mac on 6/8/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "MapSelectedViewController.h"
#import "MapViewController.h"
#import "AJLocationManager.h"
#import "JobDetailVC.h"
#import "SelectPOIViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"







@interface MapSelectedViewController ()<UIGestureRecognizerDelegate,SelectPOIActionDelegate,SelectPOIData,UISearchBarDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>

//@property (strong,nonatomic)UISearchBar *searchBar;
//@property (strong,nonatomic)UISearchController *searchController;
@property (weak,nonatomic)AJLocationManager *locationManager;

@property (strong,nonatomic)SelectPOIViewController *selectPOIViewController;
@property (strong,nonatomic)NSMutableArray *selectPOIDataArray;

//@property (strong,nonatomic)UITableViewController *searchResultsTableVC;

@property (strong,nonatomic)NSArray *searchResultsArray;

//@property (strong, nonatomic) IBOutlet UIButton *footerRefreshButton;

@end

@implementation MapSelectedViewController

-(void)setfooterRefreshButtonStyle
{
    //设置Btn信息
//    [self.footerRefreshButton.layer setBorderWidth:1.0f];
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 247/255.0, 79/255.0, 92/255.0, 1.0 });
//    [self.footerRefreshButton.layer setBorderColor:colorref];//边框颜色
//    [self.footerRefreshButton.layer setCornerRadius:self.footerRefreshButton.frame.size.width/4];
}



-(instancetype)init
{
    self=[super init];
    if (self) {
        //初始化一些必要信息
        self.locationManager=[AJLocationManager shareLocation];
        self.mapManager=[MLMapManager shareInstance];
        self.mapView=[self.mapManager getMapViewInstanceInitWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        self.mapViewModel=[[MapJobViewModal alloc]init];
//        self.mapViewModel.handleView=self.mapView;
//        self.mapView.showDetailDelegate=self;
        return self;
    }
    return nil;
}

-(void)backAction{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    UIBarButtonItem *backBarBtnItem=[[UIBarButtonItem alloc]initWithTitle:@"确认并返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem=backBarBtnItem;
    
    
    //添加长按选点事件
    UILongPressGestureRecognizer *Lpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    Lpress.delegate=self;
    Lpress.minimumPressDuration=1.0;
    Lpress.allowableMovement=50.0;
    [self.mapView addGestureRecognizer:Lpress];
    
    
    //点选地址
    self.selectPOIViewController=[[SelectPOIViewController alloc]init];
    self.selectPOIViewController.delegate=self;
    [self addChildViewController:self.selectPOIViewController];
    //取消地图搜索
    //    self.searchResultsTableVC=[[UITableViewController alloc]init];
    //    self.searchResultsTableVC.tableView.delegate=self;
    //    self.searchResultsTableVC.tableView.dataSource=self;
    //
    //    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    ////    self.searchController.searchResultsUpdater=self;
    //    self.searchController.dimsBackgroundDuringPresentation = YES;
    //    [self.searchController.searchBar sizeToFit];
    //    self.searchController.hidesNavigationBarDuringPresentation=NO;
    ////    self.searchBar=[[UISearchBar alloc]init];
    //    self.navigationItem.titleView =self.searchController.searchBar;
    //    self.searchController.searchBar.delegate=self;
    //    self.searchController.searchBar.placeholder=@"搜地点";
    //监听searchBar text;
    //    self.searchBar.delegate=self;
    //    self.searchBar.placeholder=@"搜地点";
    //    self.searchBar.showsCancelButton=YES;
    [self setfooterRefreshButtonStyle];
//    self.footerRefreshButton.frame=CGRectMake(MainScreenWidth-50, MainScreenHeight-50, 50, 50);
    self.mapView.frame=CGRectMake(0, 21,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    [self.mapView addSubview:self.footerRefreshButton];
    [self.view addSubview:self.mapView];
    //    [self.mapView setShowUserLocation:YES];
    
    //监听self.mapManager返回的你编码结果
    [self.mapManager addObserver:self forKeyPath:@"reGeocodeResultsArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

    
    
}


/**
 *  定位用户所点击的JianZhi ，显示在详情页面中
 *  @param tag
 */
//- (void)showDetail:(NSInteger)tag
//{
//    JobDetailVC *detailVC=[[JobDetailVC alloc]initWithData:[self.mapViewModel.resultsList objectAtIndex:tag]];
//    detailVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
//}

//-(void)setDataArray:(NSArray*)dataArray
//{
//    self.mapViewModel.resultsList=dataArray;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加长按事件
 */
-(void)longPressClick:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(UIGestureRecognizerStateBegan == gestureRecognizer.state) {
        // Called on start of gesture, do work here
    }
    
    if(UIGestureRecognizerStateChanged == gestureRecognizer.state) {
        // Do repeated work here (repeats continuously) while finger is down
    }
    if(UIGestureRecognizerStateEnded == gestureRecognizer.state) {
        // Do end work here when finger is lifted
        //坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        //反向解析地址，添加视图
        [self.mapManager reGeocodeSearch:touchMapCoordinate];
        //清楚已有的annotations
        [self.mapView removeAllAnnotations];
        
        [self.mapView addAnnotation:touchMapCoordinate Title:@"我的选点" Subtitle:@"查找中..." Index:NSIntegerMax SetToCenter:NO];
        
        //        //搜索附近兼职
        //        [self.mapViewModel queryJianzhiByLocation:touchMapCoordinate];
        }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"reGeocodeResultsArray"])
    {
        //回调修改地址
        NSArray *results=self.mapManager.reGeocodeResultsArray;
        if([results count]==0) return;
        //不止是否添加新的annomation
        if(self.mapView.userAddMAPointAnnotation!=nil) self.mapView.userAddMAPointAnnotation.subtitle=[results firstObject];
        else self.mapView.userAddMAPointAnnotation.subtitle=@"未找到";
        
        //以下代码是地图点选的功能的。
        id obj=[results lastObject];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *poisArray=obj;
            self.selectPOIDataArray=[NSMutableArray array];
            int i=0;
            for (AMapPOI *poi in poisArray) {
                CLLocationCoordinate2D point=CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
                POIDataModel *poidata=[[POIDataModel alloc]init];
                if (poi.address.length==0) {
                    continue;
                }
                poidata.address=poi.address;
                poidata.index=i;
                poidata.position=point;
                [self.selectPOIDataArray setObject:poidata atIndexedSubscript:i];
                i++;
            }
            //            初始化数据
            POIDataModel *poiData=[[POIDataModel alloc]init];
            poiData.address=[results firstObject];
            poiData.index=i;
            poiData.position=self.mapView.userAddMAPointAnnotation.coordinate;
            [self.selectPOIDataArray setObject:poiData atIndexedSubscript:i];
            self.selectPOIViewController.rightNowData=poiData;
        }
        //        添加选择视图
        [self addSelectPOIView];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma --mark  SelectPOIViewController delegate Method
//
//添加选择视图
-(void)addSelectPOIView
{
    self.selectPOIViewController.view.frame=CGRectMake((MainScreenWidth-300)/2, MainScreenHeight-self.selectPOIViewController.view.frame.size.height-100, self.selectPOIViewController.view.frame.size.width, self.selectPOIViewController.view.frame.size.height);
    [self.mapView addSubview:self.selectPOIViewController.view];
}


//移除选择视图
- (void) removeSelectPOIView
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"childViewControllers:%@",self.navigationController.viewControllers[idx]);
    }];
    [self.selectPOIViewController.view removeFromSuperview];
}

- (void)addTextView
{
    [self removeSelectPOIView];
    self.selectPOIViewController.textView.frame=CGRectMake((MainScreenWidth-300)/2,30, self.selectPOIViewController.textView.frame.size.width, self.selectPOIViewController.textView.frame.size.height);
    
    [self.mapView addSubview:self.selectPOIViewController.textView];
    
    
    
}

//添加填写地址视图
-(void)sendAddTextSignal
{
    //填写地址
    [self removeSelectPOIView];
    [self addTextView];
}

//确认选择
-(void)sendSelectedIndex:(NSUInteger)index
{
    if(index<self.selectPOIDataArray.count)
    {
        POIDataModel *selectedPOI=[self.selectPOIDataArray objectAtIndex:index];
        //此处address 为用户选择的地址
        NSString *address=selectedPOI.address;
        self.poiData=selectedPOI;
        NSLog(@"Choice Address：%@",address);
        //此处location为用户选择的地址坐标
        CLLocationCoordinate2D location=selectedPOI.position;
        if (self.resultsDelegate!=nil) {
            [self.resultsDelegate sendResults:selectedPOI];
        }
        
        
        self.mapView.userAddMAPointAnnotation.subtitle=address;
        self.mapView.userAddMAPointAnnotation.coordinate=location;
    }
    [self removeSelectPOIView];
}
//获得输入地址
- (void)getTextWhenEndEdit:(NSString *)text POIData:(id<SelectPOIData>)pointData
{
    self.mapView.userAddMAPointAnnotation.subtitle=text;
    
    POIDataModel *newData=[[POIDataModel alloc]init];
    newData.index=pointData.index;
    newData.position=pointData.position;
    newData.address=text;
    [self.resultsDelegate sendResults:newData];
    [self.selectPOIViewController.textView removeFromSuperview];
    [self.selectPOIViewController resignFirstResponder];
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"view Array:%@",self.navigationController.viewControllers[idx]);
    }];
    
}
//后选
-(void)nextToIndex:(NSUInteger)index
{
    //要控制数组越界
    if (index<self.selectPOIDataArray.count) {
        self.selectPOIViewController.rightNowData=[self.selectPOIDataArray objectAtIndex:index];
    }else
    {
        [MBProgressHUD showError:@"到头了" toView:nil];
    }
}

//前选
-(void)backToIndex:(NSUInteger)index
{
    self.selectPOIViewController.rightNowData=[self.selectPOIDataArray objectAtIndex:index];
}


#pragma --mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"搜索的内容%@",searchText);
    
}



#pragma --mark  searchBar TableView Delegate
#pragma mark - Table view data source

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



-(void)dealloc
{
    [self.mapManager removeObserver:self forKeyPath:@"reGeocodeResultsArray" context:nil];
}


@end
