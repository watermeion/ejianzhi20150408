//
//  MLJianZhiViewModel.m
//  EJianZhi
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "MLJianZhiViewModel.h"
#import "PageSplitingManager.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
@interface MLJianZhiViewModel()

@end

@implementation MLJianZhiViewModel

-(instancetype)init
{
    if (self=[super init]) {
        //可进行一些初始化设置
        self.pageManager.pageSize=6;
        [self firstLoad];
        //监控网络、用户登录等连接。
        RACSignal *loginActiveSignal=[RACObserve(self.loginManager,LoginState) map:^id(NSNumber *value) {
            return @([value intValue]==active?YES:NO);
        }];
        
//        RACSignal *operationActiveSignal=
//        [RACSignal combineLatest:@[RACObserve(self.loginManager,LoginState)] reduce:^id(NSNumber *){
//            return @()
//        }];
        
        return self;
    }
    return nil;
}


- (void) firstLoad
{
    //初始化分页控制器
    [self.pageManager resetPageSplitingManager];
    NSString *classname=[NSString stringWithFormat:@"%@",[JianZhi class]];
    //不同的类别不同的
    [self queryObjectsFromAVOSWithClassName:classname Skip:[self.pageManager getNextStartAt] Limit:self.pageManager.pageSize];
}

/**
 *  queryJianZhiFromAVOSWithKey
 *
 *  @param key   key description
 *  @param value value description
 */
- (void) queryJianZhiFromAVOSWithKey:(NSString*) key
                               Value:(NSString*) value
{
    AVQuery *query = [AVQuery queryWithClassName:[NSString stringWithFormat:@"%@",[JianZhi class]]];
    [query whereKey:key equalTo:value];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            self.resultsList=objects;
            [self.pageManager pageLoadCompleted];
        } else {
            // 输出错误信息
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            self.error=[[NSError alloc]init];
            self.error=error;
        }
    }];
}

/**
 *  分页增量更新
 *  保持原有数据不变
 *  @param skip  skip description
 *  @param limit limit description
 */
- (void) queryJianZhiFromAVOSWithSkip:(NSUInteger) skip
                               Limit:(NSUInteger) limit
{
    AVQuery *query = [AVQuery queryWithClassName:[NSString stringWithFormat:@"%@",[JianZhi class]]];
    query.limit=limit;
    query.skip=skip;
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.resultsList=[self.resultsList arrayByAddingObjectsFromArray:objects];
            // 检索成功
            if (objects.count>0) {
                [self.pageManager pageLoadCompleted];
            }
            else
            {
                //提示没有更多
                [MBProgressHUD showError:@"到底啦~" toView:nil];
            }
        } else {
            // 输出错误信息
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            self.error=[[NSError alloc]init];
            self.error=error;
        }
    }];
}



- (void) footerRefresh
{
    NSString *classname=[NSString stringWithFormat:@"%@",[JianZhi class]];
    [self queryObjectsFromAVOSWithClassName:classname Skip:[self.pageManager getNextStartAt] Limit:self.pageManager.pageSize];
//    [self queryJianZhiFromAVOSWithSkip:[self.pageManager getNextStartAt] Limit:self.pageManager.pageSize];
}


- (void)headerRefresh
{
    [self firstLoad];
//    NSString *classname=[NSString stringWithFormat:@"%@",[JianZhi class]];
//    [self.pageManager resetPageSplitingManager];
//    [self queryObjectsFromAVOSWithClassName:classname Skip:[self.pageManager getNextStartAt] Limit:self.pageManager.pageSize];
}

@end
