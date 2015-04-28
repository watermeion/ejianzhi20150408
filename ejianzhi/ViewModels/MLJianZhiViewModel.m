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
//        RACSignal *loginActiveSignal=[RACObserve(self.loginManager,LoginState) map:^id(NSNumber *value) {
//            return @([value intValue]==active?YES:NO);
//        }];
        
        //监听queryArray
        //        RACSignal *operationActiveSignal=
        //        [RACSignal combineLatest:@[RACObserve(self.loginManager,LoginState)] reduce:^id(NSNumber *){
        //            return @()
        //        }];
        
        return self;
    }
    return nil;
}


- (AVQuery *) setQueryJianZhiParametersWithKey:(NSString*)key
                                         Value:(NSString*) value
{
    AVQuery *query= [AVQuery queryWithClassName:[NSString stringWithFormat:@"%@",[JianZhi class]]];
    [query whereKey:key equalTo:value];
    [query orderByDescending:@"updatedAt"];
    return query;
}

- (void)setMainQueryJianZhiParametersWithKey:(NSString*)key
                                       Value:(NSString*) value
{
    self.mainQuery= [AVQuery queryWithClassName:[NSString stringWithFormat:@"%@",[JianZhi class]]];
    [self.mainQuery whereKey:key equalTo:value];
    [self.mainQuery orderByDescending:@"updatedAt"];
}

///**
// *  分页增量更新
// *  保持原有数据不变
// *  @param skip  skip description
// *  @param limit limit description
// */
- (AVQuery *)setQueryJianZhiParametersWithDefault
{
    AVQuery *query= [AVQuery queryWithClassName:[NSString stringWithFormat:@"%@",[JianZhi class]]];
    query.cachePolicy=kAVCachePolicyNetworkElseCache;
    [query orderByDescending:@"updatedAt"];
    return query;
}


-(void)doMainQuery
{
    if (self.mainQuery!=nil) {
        [self doRequest:self.mainQuery];
    }
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
-(AVQuery*)setMainQueryParamsFromSubquerise
{
    if (self.queryArray.count>0) {
        self.mainQuery=[AVQuery andQueryWithSubqueries:self.queryArray];
        [self setMainQueryPageSplitAndCache];
    }
    else{
        self.mainQuery=[self setQueryJianZhiParametersWithDefault];
        [self setMainQueryPageSplitAndCache];
    }
    
    if(self.isOrderByHot)[self.mainQuery orderByDescending:@"jianZhiBrowseTime"];
    else [self.mainQuery orderByDescending:@"updatedAt"];
    return self.mainQuery;
}


-(void)setMainQueryPageSplitAndCache
{
    self.mainQuery.skip=[self.pageManager getNextStartAt];
    self.mainQuery.limit=self.pageManager.pageSize;
    self.mainQuery.cachePolicy=kAVCachePolicyNetworkElseCache;
}

/**
 *  完成任何情况的刷新动作
 */
- (void) footerRefresh
{
    //刷新下拉刷新时需要修改
    [self setMainQueryPageSplitAndCache];
    [self doMainQuery];
    
}

- (void)headerRefresh
{
    //重置分页控制器
    [self.pageManager resetPageSplitingManager];
    //提交请求
    isHeaderFreshFlag=YES;
    [self setMainQueryPageSplitAndCache];
    [self doMainQuery];
}



-(void)setTypeQuery:(NSString*)keyword
{
    if (keyword!=nil) {
        
        if([keyword isEqualToString:@"不限"])
        {
            //取消原搜索
            [self removeQueryFromQueryArray:typeQuery];
            
        } else
        {
            if(typeQuery!=nil)
            {
                //从新设置前先移除就得typeQuery;
                [self removeQueryFromQueryArray:typeQuery];
            }
            //字段 如何从子类中获得
            typeQuery=[self setFliterSubQueryParams:@"jianZhiType" objectKey:keyword];
            [self addSubQueryToQueryArray:typeQuery];
        }
        [self setMainQueryParamsFromSubquerise];
        [self headerRefresh];
    }
}

-(void)setSettlementQuery:(NSString*)keyword
{
    if (keyword!=nil) {
        
        if([keyword isEqualToString:@"不限"])
        {
            [self removeQueryFromQueryArray:settleQuery];
            
        }else
        {
            //字段如何从子类中获得
            if (settleQuery!=nil) {
                [self removeQueryFromQueryArray:settleQuery];
            }
            settleQuery=[self setFliterSubQueryParams:@"jianZhiWageType" objectKey:keyword];
            [self addSubQueryToQueryArray:settleQuery];
        }
        [self setMainQueryParamsFromSubquerise];
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
            [self removeQueryFromQueryArray:otherQuery];
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
        [self setMainQueryParamsFromSubquerise];
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


-(void)addSubQueryToQueryArray:(AVQuery*)subquery
{
    if(self.queryArray==nil) self.queryArray=[NSMutableArray array];
    [self.queryArray addObject:subquery];
}


-(void)removeQueryFromQueryArray:(AVQuery*) query
{
    [self.queryArray removeObject:query];
}

- (void)clearQueryArray
{
    [self.queryArray removeAllObjects];
}

-(void)firstLoad
{
    self.mainQuery=[self setQueryJianZhiParametersWithDefault];
    [self headerRefresh];
}

@end
