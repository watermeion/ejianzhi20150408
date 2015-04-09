//
//  AOImageView.h
//  AOImageViewDemo
//
//  Created by akria.king on 13-4-2.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
//按钮点击协议
@protocol UrLImageButtonDelegate <NSObject>

-(void)click:(int)vid;

@end


@interface AOImageView : UIView
//按钮点击委托对象
@property(nonatomic,strong)id<UrLImageButtonDelegate> uBdelegate;
//自定义初始化方法
//parameter：
//imageName：图片url字符串
//titleStr：标题
//xPoint：视图横坐标
//yPoint：视图纵坐标
//height：视图高度
-(id)initWithImageName:(NSString *)imageName title:(NSString *)titleStr x:(float)xPoint y:(float)yPoint width:(float)width height:(float)height;
@end
