//
//  SRMapViewVC.h
//  DaZhe
//
//  Created by RAY on 14/11/26.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@class MLMapManager;
@interface SRMapViewVC : UIViewController<MAMapViewDelegate,UIGestureRecognizerDelegate,AMapSearchDelegate>
{
    CLLocationManager * locationManager;
    AMapSearchAPI *search;
    AMapSearchType searchType;
    AMapRoute *route;
    NSArray *polylines;
    BOOL gotLocation;
}
@property(nonatomic, retain) MAMapView *mapView;

@property(nonatomic) CLLocationCoordinate2D sellerCoord;

@property(nonatomic) CLLocationCoordinate2D currentCoord;

@property(nonatomic, retain) NSString *sellerTitle;

@property (weak, nonatomic) IBOutlet UIView *footView;
- (void)getUserLocation:(id)sender;

@end
