//
//  MLMapManager.h
//  EJianZhi
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapCommonObj.h>
/**
 *  管理app中对AMap 使用，控制mapKey验证，所有高德地图有关的操作都封装在这个类中等
 */
@class MLMapView;
@interface MLMapManager : NSObject

//储存地理编码的结果
@property (nonatomic,strong)NSArray *reGeocodeResultsArray;
@property (nonatomic,strong)NSArray *geoCodeResultsArray;
//储存路径规划结果
@property (nonatomic,strong)NSString *routePlannedString;

+(instancetype)shareInstance;

-(void)checkMapKey;

/**
 *  逆向地理编码
 */

-(void)reGeocodeSearch:(CLLocationCoordinate2D)position;



/**
 *  geo正向地理编码,目前仅支持北京
 *
 */
-(void)geoCodeSearch:(NSString *)searchContext;

/**
 *  初始化新的MapView,
 *
 *  @param frame frame description
 *
 *  @return <#return value description#>
 */
- (MLMapView *)getMapViewInstanceInitWithFrame:(CGRect)frame;

/**
 *  驾驶路径规划
 *
 *  @param originPoint      <#originPoint description#>
 *  @param destinationPoint <#destinationPoint description#>
 */
- (void)findRouteByCarFrom:(CLLocationCoordinate2D) originPoint
                        To:(CLLocationCoordinate2D) destinationPoint;

/**
 *  步行路径规划
 *
 *  @param originPoint      <#originPoint description#>
 *  @param destinationPoint <#destinationPoint description#>
 */
- (void)findRouteOnFootFrom:(CLLocationCoordinate2D) originPoint
                         To:(CLLocationCoordinate2D) destinationPoint;

/**
 *  公交路径规划
 *
 *  @param originPoint      <#originPoint description#>
 *  @param destinationPoint <#destinationPoint description#>
 */
- (void)findRouteByBusFrom:(CLLocationCoordinate2D) originPoint
                        To:(CLLocationCoordinate2D) destinationPoint;

/**
 *  搜索输入辅助;
 *
 *  @param searchContext <#searchContext description#>
 */
-(void)searchTips:(NSString*)searchContext;


/**
 *  关键字搜索
 */

-(void)searchPOIByKeyWord:(NSString *)keyWord;


/**
 *  计算距离导航、单位米
 *
 *  @param pointA pointA description
 *  @param pointB pointB description
 *
 *  @return NSNumber 单位米
 */
- (NSNumber *)calDistanceMeterWithPointA:(CLLocationCoordinate2D)pointA
                                  PointB:(CLLocationCoordinate2D)pointB;
@end
