//
//  MLSelectInffShow.h
//  EJianZhi
//
//  Created by RAY on 15/2/6.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectInfoShowDelegate <NSObject>
@required
- (void)finishSelectInfo:(int)type;
@end

@interface MLSelectInffShow : UIViewController
@property(nonatomic,weak) id<selectInfoShowDelegate> selectDelegate;
@property(nonatomic,strong)NSString *type;
@end
