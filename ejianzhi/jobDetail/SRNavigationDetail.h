//
//  SRNavigationDetail.h
//  DaZhe
//
//  Created by RAY on 14/11/27.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MBProgressHUD.h"

@interface SRNavigationDetail : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *HUD;
    NSInteger cellNum;
    NSInteger tableHight;
    BOOL finishloading;
    
}
@property(nonatomic) AMapSearchType searchType;
@property(nonatomic) CLLocationCoordinate2D startCoord;
@property(nonatomic) CLLocationCoordinate2D destinationCoord;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *destinationName;
@property (weak, nonatomic) NSString *destination;
@end
