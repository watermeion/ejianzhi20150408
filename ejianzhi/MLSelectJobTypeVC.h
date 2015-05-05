//
//  MLSelectJobTypeVC.h
//  jobSearch
//
//  Created by RAY on 15/2/4.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol finishSelectDelegate <NSObject>
@required
- (void)finishSelect:(NSMutableArray*)typeArray;
- (void)finishSingleSelect:(NSString*)info type:(NSInteger)type;
@end

@interface MLSelectJobTypeVC : UITableViewController

@property (nonatomic,strong) NSMutableArray *selectedTypeName;
@property(nonatomic,weak) id<finishSelectDelegate> selectDelegate;
@property (nonatomic) BOOL fromEnterprise;
@property (nonatomic) NSInteger type;
+(MLSelectJobTypeVC*)sharedInstance;

@end
