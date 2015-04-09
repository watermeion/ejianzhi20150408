//
//  SRCityChooseVC.h
//  DaZhe
//
//  Created by RAY on 14/11/29.
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol finishChoose <NSObject>
@required
- (void)finishChoose:(NSString*)city;
@end

@interface SRCityChooseVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;

@property(nonatomic,strong)UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property(nonatomic,weak) id<finishChoose> chooseDelegate;

@property (weak, nonatomic) IBOutlet UILabel *gpsCityLabel;
@end
