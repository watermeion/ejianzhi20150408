//
//  SRShowRouteVC.h
//  DaZhe
//
//  Created by RAY on 14/11/27.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface SRShowRouteVC : UIViewController<MAMapViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) int type;
@property (nonatomic,strong) NSArray *polylines;
@property(nonatomic) CLLocationCoordinate2D startCoord;
@property(nonatomic) CLLocationCoordinate2D destinationCoord;
@end
