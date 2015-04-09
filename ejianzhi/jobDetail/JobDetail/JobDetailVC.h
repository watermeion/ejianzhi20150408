//
//  JobDetailVC.h
//  EJianZhi
//
//  Created by RAY on 15/1/30.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "commonMacro.h"
@class MLJobDetailViewModel;
/**
 *  使用时应该初始化viewModel方法
 */
@interface JobDetailVC : UIViewController

/**
 *  使用数据init JobDetailVC 实例
 *
 *  @param data 给viewModel 传递的model信息
 *
 *  @return instancetype
 */


- (instancetype)initWithData:(id)data;


/**
 *  设置兼职数据
 *
 *  @param data <#data description#>
 */
- (void)setViewModelJianZhi:(id)data;

@end
