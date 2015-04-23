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
{
    AVQuery *typeQuery;
    AVQuery *settleQuery;
    AVQuery *otherQuery;
    BOOL isHeaderFreshFlag;
}

@property (strong,nonatomic)NSMutableArray *queryArray;

@property (strong,nonatomic)AVQuery *mainQuery;
@property BOOL isOrderByHot;

@end

@implementation MLJianZhiViewModel


-(instancetype)init
{
    if (self=[super init]) {
        //可进行一些初始化设置
        self.pageManager.pageSize=6;
        self.isOrderByHot=NO;
        //监控网络、用户登录等连接。
        RACSignal *loginActiveSignal=[RACObserve(self.loginManager,LoginState) map:^id(NSNumber *value) {
            return @([value intValue]==active?YES:NO);
        }];
        
        //监听queryArray
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
   [self headerRefresh];
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
    [self doRequest:query];
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
    [self doRequest:query];
}

/**
 *  执行query操作
 *
 *  @param query AVQuery
 */
-(void)doRequest:(AVQuery*)query
{
    //执行query操作；
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            if(isHeaderFreshFlag)
            {
                self.resultsList=nil;
                isHeaderFreshFlag=NO;
            }
            self.resultsList=[self.resultsList arrayByAddingObjectsFromArray:objects];
            if (objects.count>0) {
                [self.pageManager pageLoadCompleted];
            }
            else
            {
                //提示没有更多
                [MBProgressHUD showError:@"没有啦~" toView:nil];
            }
        } else {
            // 输出错误信息
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            self.error=[[NSError alloc]init];
            self.error=error;
        }
    }];
}



/**
 *  利用设置主query
 */
-(void)doQuery
{
    AVQuery *query;
    //执行query操作；
    if (self.queryArray.count>0) {
        query=[AVQuery andQueryWithSubqueries:self.queryArray];
        query.skip=[self.pageManager getNextStartAt];
        query.limit=self.pageManager.pageSize;
        query.cachePolicy=kAVCachePolicyNetworkElseCache;
    }
    else{
        query= [AVQuery queryWithClassName:[NSString stringWithFormat:@"%@",[JianZhi class]]];
        query.skip=[self.pageManager getNextStartAt];
        query.limit=self.pageManager.pageSize;
        query.cachePolicy=kAVCachePolicyNetworkElseCache;
    }
    if(self.isOrderByHot)[query orderByDescending:@"jianZhiBrowseTime"];
    else [query orderByDescending:@"updatedAt"];
    [self doRequest:query];
}

- (void) footerRefresh
{
    [self doQuery];
    
}

- (void)headerRefresh
{
    //重置分页控制器
    [self.pageManager resetPageSplitingManager];
    //提交请求
    isHeaderFreshFlag=YES;
    [self doQuery];
}



-(void)setTypeQuery:(NSString*)keyword
{
    if (keyword!=nil) {
        
        if([keyword isEqualToString:@"不限"])
        {
            //取消原搜索
            [self removeQuery:typeQuery];
            
        } else
        {
            if(typeQuery!=nil)
            {
                //从新设置前先移除就得typeQuery;
                [self removeQuery:typeQuery];
            }
            //字段 如何从子类中获得
            typeQuery=[self setFliterSubQueryParams:@"jianZhiType" objectKey:keyword];
            [self addSubQueryToMainQuery:typeQuery];
        }
        [self headerRefresh];
    }
}

-(void)setSettlementQuery:(NSString*)keyword
{
    if (keyword!=nil) {
        
        if([keyword isEqualToString:@"不限"])
        {
            [self removeQuery:settleQuery];
            
        }else
        {
            //字段如何从子类中获得
            if (settleQuery!=nil) {
                [self removeQuery:settleQuery];
            }
            settleQuery=[self setFliterSubQueryParams:@"jianZhiWageType" objectKey:keyword];
            [self addSubQueryToMainQuery:settleQuery];
        }
        [self headerRefresh];
    }
}

- (void)setOtherQuery:(NSString*)keyword
{
    if (keyword!=nil) {
        self.isOrderByHot=NO;
        if([keyword isEqualToString:@"最新"])
        {
            //系统默认都是最新的
            [self removeQuery:otherQuery];
            self.isOrderByHot=NO;
        }
        else if([keyword isEqualToString:@"最热"])
        {
            self.isOrderByHot=YES;
        }
        else if([keyword isEqualToString:@"附近"])
        {
#warning FIXME:地理信息搜索还未做
            
            //FIXME:地理信息搜索还未做
        }
        [self headerRefresh];
    }
}


-(AVQuery*)setFliterSubQueryParams:(NSString*)fliterContent objectKey:(NSString*)keyword
{
    //创建查询字段
    if (fliterContent!=nil && keyword!=nil) {
        AVQuery *query = [AVQuery queryWithClassName:[NSString stringWithFormat:@"%@",[JianZhi class]]];
        [query whereKey:fliterContent equalTo:keyword];
        return query;
    }
    return nil;
}


-(void)addSubQueryToMainQuery:(AVQuery*)subquery
{
    if(self.queryArray==nil) self.queryArray=[NSMutableArray array];
    [self.queryArray addObject:subquery];
}


-(void)removeQuery:(AVQuery*) query
{
    [self.queryArray removeObject:query];
}

- (void)clearQueryArray
{
    [self.queryArray removeAllObjects];
}



@end
