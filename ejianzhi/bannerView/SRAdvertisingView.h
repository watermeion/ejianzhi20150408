//
//  SRAdvertisingView.h
//  test
//
//  Created by GeoBeans on 14-9-4.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//
/*
 功能介绍：滚动轮播广告位，并支持图片点击事件
 使用方法：
 1 引入头文件#import "SRAdvertisingView.h"
 2 继承协议<ValueClickDelegate>
 demo：
 
 NSMutableArray *arr=[[NSMutableArray alloc]initWithObjects:
 @"http://ww1.sinaimg.cn/large/53e0c4edjw1dy3qf6n17xj.jpg",
 @"http://ww1.sinaimg.cn/large/53e0c4edjw1dy3qf6n17xj.jpg",
 nil];
 
 SRAdvertisingView *adView=[[SRAdvertisingView alloc]initWithFrame:CGRectMake(0, 100, 320, 100) imageArray:arr interval:3.0];
 adView.vDelegate=self;
 [self.view addSubview:adView];
 
 */


#import <UIKit/UIKit.h>
#import "AOImageView.h"

@protocol ValueClickDelegate <NSObject>

-(void)buttonClick:(int)vid;

@end

@interface SRAdvertisingView : UIView<UIScrollViewDelegate,UrLImageButtonDelegate>

@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong,nonatomic)UITextField *text;
@property(nonatomic,strong)id<ValueClickDelegate> vDelegate;

- (id)initWithFrame:(CGRect)frame imageArray:(NSMutableArray*)imageArray interval:(float)interval;

@end
