//
//  MLMapManager.m
//  EJianZhi
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//


/**
 *  完成地图的所有操作，包括地理编码查询，地图显示，导航查询等
 */


#import "MLMapManager.h"
#import "MLMapView.h"
#import "AJLocationManager.h"
#import <AMapSearchAPI.h>

@interface MLMapManager()<AMapSearchDelegate>

//@property (strong,nonatomic) MLMapView *mapView;
@property (nonatomic,weak) AJLocationManager *locationManager;
@property (strong,nonatomic)AMapSearchAPI *searchAPI;

@end


@implementation MLMapManager

static MLMapManager * thisInstance;
static NSString *mapKey=@"75b8982e76c3c19b749f1fb7fd9ef67a";

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thisInstance=[[super alloc]init];
        thisInstance.locationManager=[AJLocationManager shareLocation];
         //初始化检索对象
//        thisInstance.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:mapKey Delegate:thisInstance];
    });
    return thisInstance;
}


- (AMapSearchAPI *)searchAPI
{
    if (_searchAPI==nil) {
        //初始化检索对象
        _searchAPI=[[AMapSearchAPI alloc] initWithSearchKey:mapKey Delegate:self];
    }
    return _searchAPI;
}


-(void)checkMapKey
{
    [MAMapServices sharedServices].apiKey = mapKey;
}

/**
 *  初始化新的MapView,
 *
 *  @param frame frame description
 *
 *  @return <#return value description#>
 */
- (MLMapView *)getMapViewInstanceInitWithFrame:(CGRect)frame
{
    [self checkMapKey];
    return [[MLMapView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

/**
 *  公交路径规划
 *
 *  @param originPoint      <#originPoint description#>
 *  @param destinationPoint <#destinationPoint description#>
 */
- (void)findRouteByBusFrom:(CLLocationCoordinate2D) originPoint
                         To:(CLLocationCoordinate2D) destinationPoint
{
    [self setAMapNaviSearchParametersWithSearchType:AMapSearchType_NaviBus OriginPoint:originPoint DestinationPoint:destinationPoint];
}

/**
 *  步行路径规划
 *
 *  @param originPoint      <#originPoint description#>
 *  @param destinationPoint <#destinationPoint description#>
 */
- (void)findRouteOnFootFrom:(CLLocationCoordinate2D) originPoint
                        To:(CLLocationCoordinate2D) destinationPoint
{
    [self setAMapNaviSearchParametersWithSearchType:AMapSearchType_NaviWalking OriginPoint:originPoint DestinationPoint:destinationPoint];
}


/**
 *  驾驶路径规划
 *
 *  @param originPoint      <#originPoint description#>
 *  @param destinationPoint <#destinationPoint description#>
 */
- (void)findRouteByCarFrom:(CLLocationCoordinate2D) originPoint
                       To:(CLLocationCoordinate2D) destinationPoint
{
    [self setAMapNaviSearchParametersWithSearchType:AMapSearchType_NaviDrive OriginPoint:originPoint DestinationPoint:destinationPoint];
}



/**
 *  路径导航服务
 *
 *  @param type             AMapSearchType  步行 公交 驾车等
 *  @param originPoint      originPoint 起点坐标
 *  @param destinationPoint destinationPoint 终点坐标
 */
- (void)setAMapNaviSearchParametersWithSearchType:(AMapSearchType) type
                                      OriginPoint:(CLLocationCoordinate2D) originPoint
                                 DestinationPoint:(CLLocationCoordinate2D) destinationPoint
{
    //构造AMapNavigationSearchRequest对象，配置查询参数
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = type;
    naviRequest.requireExtension = YES;
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:originPoint.latitude longitude:originPoint.longitude];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:destinationPoint.latitude longitude:destinationPoint.longitude];
    //发起路径搜索
    [self.searchAPI AMapNavigationSearch: naviRequest];

}

//实现路径搜索的回调函数
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    //回调解析
    
    NSLog(@"%@", route);
}


/**
 *  路径规划结果解析
 */
- (void)mappingResponseRoute:(AMapRoute*) route
{
    if (route.transits.count>0)
    {
        //公交导航
    
    
    }else
    {
        //步行或驾车导航
        if(route.paths.count>0)
        {
        
        
        }
    
    
    }

};

/**
 *  计算距离导航、单位米
 *
 *  @param pointA pointA description
 *  @param pointB pointB description
 *
 *  @return NSNumber 单位米
 */
- (NSNumber *)calDistanceMeterWithPointA:(CLLocationCoordinate2D)pointA
                             PointB:(CLLocationCoordinate2D)pointB
{
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(pointA);
    MAMapPoint point2 = MAMapPointForCoordinate(pointB);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return [NSNumber numberWithDouble:distance];
}


/**
 *  geo正向地理编码,目前仅支持北京
 *
 */
-(void)geoCodeSearch:(NSString *)searchContext
{
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoRequest.searchType = AMapSearchType_Geocode;
    geoRequest.address = searchContext;
    geoRequest.city = @[@"beijing"];
    //发起正向地理编码
    [self.searchAPI AMapGeocodeSearch: geoRequest];
}

/**
 *  实现正向地理编码的回调函数
 *
 *  @param request  request description
 *  @param response response description
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        return;
    }
    
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld", (long)response.count];
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        strGeocodes = [NSString stringWithFormat:@"%@\ngeocode: %@", strGeocodes, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strGeocodes];
    self.geoCodeResultsArray=response.geocodes;
    
    NSLog(@"Geocode: %@", result);
}

/**
 *  逆向地理编码
 */

-(void)reGeocodeSearch:(CLLocationCoordinate2D)position
{

    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:position.latitude longitude:position.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [self.searchAPI AMapReGoecodeSearch: regeoRequest];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        
        self.reGeocodeResultsArray=[NSArray arrayWithObjects:response.regeocode.formattedAddress, response.regeocode.pois, nil];
    }
}






-(void)searchTips:(NSString*)searchContext
{
    AMapInputTipsSearchRequest *tipsRequest= [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.searchType = AMapSearchType_InputTips;
    tipsRequest.keywords = @"望";
    tipsRequest.city = @[@"北京"];
    
    //发起输入提示搜索
    [self.searchAPI AMapInputTipsSearch: tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d", response.count];
    NSString *strtips = @"";
    for (AMapTip *p in response.tips) {
        strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
    NSLog(@"InputTips: %@", result);
}


-(void)searchPOIByKeyWord:(NSString *)keyWord;
{
//构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = keyWord;
    poiRequest.city = @[@"beijing"];
    poiRequest.requireExtension = YES;
    
    //发起POI搜索
    [self.searchAPI AMapPlaceSearch: poiRequest];
}

//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}


@end
