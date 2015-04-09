//
//  MLStudentCard.h
//  EJianZhi
//
//  Created by RAY on 15/2/6.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@protocol identifySchoolDelegate <NSObject>
@required
- (void)finishIdentify:(NSString*)schoolNum imageUrl:(AVFile*)identifyFile;
@end

@interface MLStudentCard : UIViewController
@property(nonatomic,weak) id<identifySchoolDelegate> identifyDelegate;
@property(nonatomic, strong)AVFile *imageFile;
@end
