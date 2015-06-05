//
//  JobDetailRouter.m
//  EJianZhi
//
//  Created by Mac on 4/1/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "JobDetailRouter.h"
#import "MapViewController.h"
@class JianZhi;
@implementation JobDetailRouter


- (void)presentShowJobInMapInterfaceFromViewController:(UIViewController*) viewController WithJob:(JianZhi*)job{
    
    MapViewController *mapViewController=[[MapViewController alloc]init];
    mapViewController.hidesBottomBarWhenPushed=YES;
    [mapViewController setDataArray:@[job]];
    [viewController.navigationController pushViewController:mapViewController animated:YES];
    self.presentedViewController=mapViewController;
}

@end
