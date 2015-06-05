//
//  MLResumePreviewVC.h
//  EJianZhi
//
//  Created by RAY on 15/4/3.
//  Copyright (c) 2015年 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetail.h"

#define type_preview_edit 0
#define type_preview 1

@protocol finishSaveDelegate <NSObject>
@required
- (void)finishSave;
@end

@interface MLResumePreviewVC : UIViewController
@property (nonatomic, strong) UserDetail *userDetailModel;
@property (assign, nonatomic) int type;
@property (nonatomic, strong) NSMutableArray *userImageArray;
@property(nonatomic,weak) id<finishSaveDelegate> saveDelegate;
@end
