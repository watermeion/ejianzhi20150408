//
//  listBadgeView.h
//  EJianZhi
//
//  Created by Mac on 1/25/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
   JobType1=0,
   JobType2,
   JobType3,
} JobType;

#define DefaultFillColor [UIColor colorWithRed: 0.337 green: 0.479 blue: 0.861 alpha: 1]



#define GreenFillColor [UIColor colorWithRed: 0.22 green: 0.69 blue: 0.58 alpha: 1]



//#define WithBadge 1
//#define WithOutBadge 2

typedef enum
{
    WithBadge=1,
    WithOutBadge
} BadgeType;

@interface listBadgeView : UIView

@property (strong,nonatomic)NSString *badgeText;
//颜色类型
//Badge类型
@property BadgeType type;


@end
