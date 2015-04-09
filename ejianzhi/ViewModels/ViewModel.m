//
//  ViewModel.m
//  EJianZhi
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "ViewModel.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
@implementation ViewModel

- (instancetype)init
{
    if (self=[super init]) {
        //初始化分页选择器
        self.pageManager=[[PageSplitingManager alloc]init];
        self.loginManager=[MLLoginManger shareInstance];
        //子类可以监控用户登录状态
    
        
        return self;
    }
    return nil;
}


- (NSArray *)resultsList
{
    if (_resultsList==nil) {
        _resultsList=[NSArray array];
    }
    return _resultsList;
}


- (void) queryObjectsFromAVOSWithClassName:(NSString *) classname
                                      Key:(NSString *) key
                                    Value:(NSString *) value
{

    if (classname==nil||key==nil||value==nil) {
        return;
    }
    AVQuery *query = [AVQuery queryWithClassName:classname];
    [query whereKey:key equalTo:value];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            self.resultsList=objects;
        } else {
            // 输出错误信息
            NSLog(@"ViewModelError: %@ %@", error, [error userInfo]);
            [self showErrorMsg:error];
            self.error=[[NSError alloc]init];
            self.error=error;
        }
    }];
}

/**
 *  获取从skip到skip+limit范围内的对象，按updateAt最新排列
 *
 *  @param classname classname description
 *  @param skip      skip description
 *  @param limit     limit description
 */
- (void) queryObjectsFromAVOSWithClassName:(NSString *)classname
                                      Skip:(NSUInteger)skip
                                     Limit:(NSUInteger)limit
{
    if (classname==nil) {
        return;
    }
    AVQuery *query = [AVQuery queryWithClassName:classname];
    query.skip=skip;
    query.limit=limit;
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            if (objects.count>0) {
                [self.pageManager pageLoadCompleted];
            }else
            {
               //做一些其他处理
                //提示没有更多
                [self showRefreshBottomMsg];
            }
            self.resultsList=[self.resultsList arrayByAddingObjectsFromArray:objects];
        } else {
            // 输出错误信息
            NSLog(@"ViewModelError: %@ %@", error, [error userInfo]);
            [self showErrorMsg:error];
            self.error=[[NSError alloc]init];
            self.error=error;
        }
    }];
}

/**
 *  显示没有数据Msg
 */
- (void)showRefreshBottomMsg
{
   [MBProgressHUD showError:@"到底啦~" toView:nil];
}


/**
 *  显示刷新出错Msg
 *
 *  @param error error description
 */
- (void)showErrorMsg:(NSError *)error
{
    [MBProgressHUD showError:@"出错啦~" toView:nil];
}

@end
