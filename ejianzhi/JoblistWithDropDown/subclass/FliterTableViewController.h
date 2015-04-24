//
//  FliterTableViewController.h
//  ejianzhi
//
//  Created by Mac on 4/21/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//
typedef NS_ENUM(NSUInteger, FliterViewType) {
    FliterViewTypeArea,
    FliterViewTypeType,
    FliterViewTypeSettlement,
};


#import <UIKit/UIKit.h>


@protocol FliterTableViewControllerDelegate <NSObject>

-(void)selectedResults:(NSString *)result ViewType:(FliterViewType) viewtype;
@end


@interface FliterTableViewController : UITableViewController
@property (nonatomic,weak)id<FliterTableViewControllerDelegate> delegate;
@property (nonatomic,copy)NSArray *datasource;

@property FliterViewType viewType;

@property (unsafe_unretained,nonatomic) NSInteger row;

@end
