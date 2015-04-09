//
//  MLMapView.h
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>



@protocol showDetailDelegate <NSObject>
@required
- (void)showDetail:(NSInteger)tag;
@end


/**
 *  自定义MLMapView,负责显示不同的信息
 */
@interface MLMapView : UIView<MAMapViewDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *pointAnnoArray;
    BOOL firstLoad;
    BOOL requestUserLocation;
    NSInteger btnIndex;
}
@property(nonatomic, retain) MAMapView *mapView;
@property(nonatomic, strong)MAPointAnnotation *userAddMAPointAnnotation;
@property(nonatomic,weak) id<showDetailDelegate> showDetailDelegate;

- (void)removeAllAnnotations;
//主动请求定位
- (void)setShowUserLocation:(BOOL)isShow;

/**
 *  添加单个Annotation到地图上
 *
 *  @param point    点做坐标
 *  @param title    显示的内容
 *  @param index    对应tableView 的tag
 *  @param isCenter 是否设置该点坐标为地图中心
 */
- (void)addAnnotation:(CLLocationCoordinate2D)point Title:(NSString*)title  Subtitle:(NSString*)subtitle Index:(NSInteger)index SetToCenter:(BOOL)isCenter;

/**
 *  设置地图中心
 *
 *  @param point <#point description#>
 */
-(void)setCenterAtPoint:(CLLocationCoordinate2D)point;

/**
 *  显示CalloutView
 *
 *  @param array 
 */
-(void)ShowCalloutView;



@end
