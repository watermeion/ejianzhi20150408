//
//  SRShowRouteVC.m
//  DaZhe
//
//  Created by RAY on 14/11/27.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import "SRShowRouteVC.h"
#import "CommonUtility.h"

@interface SRShowRouteVC ()

@end

@implementation SRShowRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
     MAMapView *_mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mapView];
    _mapView.userInteractionEnabled=YES;
    _mapView.delegate = self;
    
    if (self.polylines) {
        [_mapView addOverlays:self.polylines];
        _mapView.visibleMapRect = [CommonUtility mapRectForOverlays:self.polylines];
        
        MAPointAnnotation *anno1=[[MAPointAnnotation alloc]init];
        anno1.coordinate=self.startCoord;
        anno1.title=@"start";
        [_mapView addAnnotation:anno1];
        
        MAPointAnnotation *anno2=[[MAPointAnnotation alloc]init];
        anno2.coordinate=self.destinationCoord;
        anno2.title=@"destination";
        [_mapView addAnnotation:anno2];
    }
}


-(MAOverlayView*)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineView* polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 8.0;
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];;
        
        return polylineView;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString* reuseIdentifier = @"annotation";
        
        MAAnnotationView* newAnnotation = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        
        newAnnotation.canShowCallout = NO;
        
        if ([annotation.title isEqualToString:@"start"]) {
            newAnnotation.image=[UIImage imageNamed:@"map_map_start"];
        }else if ([annotation.title isEqualToString:@"destination"]){
            newAnnotation.image=[UIImage imageNamed:@"map_map_end"];
        }
        
        return newAnnotation;
    }
    return nil;
}


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

@end
