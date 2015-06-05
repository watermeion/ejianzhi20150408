//
//  SelectPOIViewController.h
//  EJianZhi
//
//  Created by Mac on 3/29/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
/**
 *  用于显示的数据类型接口
 */
@protocol SelectPOIData <NSObject>

/**
 *  当前地址字段
 */
@property (nonatomic,strong)NSString *address;

/**
 *  当前地址索引
 */
@property (nonatomic) NSInteger index;
/**
 *  当前位置坐标
 */
@property CLLocationCoordinate2D position;

@end

/**
 *  用于传递操作的delegate;
 */
@protocol SelectPOIActionDelegate <NSObject>
/**
 *  选中的数据内容
 *
 *  @param index NSArray索引
 */
-(void)sendSelectedIndex:(NSUInteger)index;

/**
 *  向后选择
 *
 *  @param index NSArray索引
 */
-(void)nextToIndex:(NSUInteger)index;

/**
 *  向前选择
 *
 *  @param index NSArray索引
 */
-(void)backToIndex:(NSUInteger)index;

/**
 *  发送手动输入Btn点击信号，可以加载输入视图
 */
-(void)sendAddTextSignal;
/**
 *  键盘输入结果回调
 *
 *  @param text textView回调函数
 */
-(void)getTextWhenEndEdit:(NSString*)text;
@end

#import <UIKit/UIKit.h>
/**
 *  用于选择POI对应地址的控制器
 */
@interface SelectPOIViewController : UIViewController

//绑定button 实现RAC
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *addTextBtn;


//传入参数
@property (nonatomic,strong)id<SelectPOIData> rightNowData;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak,nonatomic)id<SelectPOIActionDelegate> delegate;
@end
