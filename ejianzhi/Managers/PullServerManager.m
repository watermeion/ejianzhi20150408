//
//  PullServerManager.m
//  EJianZhi
//
//  Created by Mac on 3/27/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//







#import "PullServerManager.h"
@interface PullServerManager ()

@property (strong,nonatomic)NSArray *typeArray;
@property (strong,nonatomic)NSArray *settlementwayArray;
@property (strong,nonatomic)NSArray *reduArray;
@property (nonatomic,strong)NSDictionary *typeColorListDict;

@end
@implementation PullServerManager

static PullServerManager * singleIntance;
static int reloadTimes;

+(PullServerManager*)sharedIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleIntance=[[super alloc]init];
        reloadTimes=0;
        //初始化检索对象
        [singleIntance getJianZhiTypeListFromAVOS];
        [singleIntance rewriteUserDefaults];
        [singleIntance pullBannerInfo];
    });
    return singleIntance;
}

-(void)rewriteUserDefaults
{
    //FIXME:改成动态的
    NSUserDefaults* mysettings=[NSUserDefaults standardUserDefaults];
    self.settlementwayArray=@[@"不限",@"时",@"天",@"周",@"月", @"季", @"年",@"项目"];
    self.reduArray=@[@"最新",@"附近",@"最热"];
    
    [mysettings setObject: self.settlementwayArray forKey:FliterSettlementWay];
    [mysettings setObject:self.reduArray forKey:FliterReDu];
    
    [mysettings synchronize];
}



//-(NSDictionary*)getTypeColorDict
//{
//    //TODO:手动设置color 颜色
//    NSDictionary *colorDict=[NSDictionary dictionary];
//
//    NSArray *type=@[@"不限",@"开发", @"销售",@"安保", @"礼仪", @"促销", @"翻译", @"客服",@"演出",@"家教",@"模特",@"派单", @"文员", @"设计",@"校内",@"临时工",@"服务员", @"其他"];
//
//}



-(void)getJianZhiTypeListFromAVOS
{
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhiTypeList"];
    query.cachePolicy=kAVCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error==nil) {
            if (objects.count>0) {
                
                NSArray *type=[NSArray array];
                NSArray *colorArray=[NSArray array];
                //生成数据字典,解析数据
                for (AVObject *obj in objects) {
                    NSString  *typeString=[NSString stringWithFormat:@"%@",[obj objectForKey:@"typeName"]];
                    type=[type arrayByAddingObject:typeString];
                    NSArray *rgb=[obj objectForKey:@"colorRGB"];
                    if (rgb!=nil && rgb.count==3 ) {
                        
                        colorArray=[colorArray arrayByAddingObject:rgb];
                    }
                    else colorArray=[colorArray arrayByAddingObject:[NSNull null]];
                }
                self.typeColorListDict=[NSDictionary dictionaryWithObjects:colorArray forKeys:type];
                self.typeArray=[self.typeColorListDict allKeys];
                //将数据本地化
                NSUserDefaults* mysettings=[NSUserDefaults standardUserDefaults];
                [mysettings setObject:self.typeArray forKey:FliterType];
                
                [mysettings setObject:self.typeColorListDict forKey:TypeListAndColor];
                [mysettings synchronize];
            }
        }
        else
        {
            //拉去数据失败，查看本地数据
            NSUserDefaults* mysettings=[NSUserDefaults standardUserDefaults];
            if ([mysettings objectForKey:TypeListAndColor]==nil) {
                if (reloadTimes<3) {
                    //重新加载
                    [self performSelector:@selector(getJianZhiTypeListFromAVOS) withObject:nil afterDelay:0.5f];
                    reloadTimes++;
                }else
                {
                    //本地写入老版本默认数据
                    [self rewriteTypeListLocally];
                }
            }else
            {
                //HAX:(gyb 2015-04-24)
                //从数据中加载修改FliterType，也可什么不做
                NSDictionary *dict=[mysettings objectForKey:TypeListAndColor];
                self.typeArray=[dict allKeys];
                //
                self.typeColorListDict=dict;
                [mysettings setObject:self.typeArray forKey:FliterType];
                [mysettings synchronize];
            }
        }
    }];
}



-(void)rewriteTypeListLocally
{
    NSUserDefaults* mysettings=[NSUserDefaults standardUserDefaults];
    self.typeArray=@[@"不限",@"开发", @"销售",@"安保", @"礼仪", @"促销", @"翻译", @"客服",@"演出",@"家教",@"模特",@"派单", @"文员", @"设计",@"校内",@"临时工",@"服务员", @"其他"];
    [mysettings setObject:self.typeArray forKey:FliterType];
    [mysettings synchronize];
}





-(void)pullBannerInfo{

    AVQuery *query=[AVQuery queryWithClassName:@"Banner"];
    query.cachePolicy=kAVCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error==nil) {
            if(objects.count>0)
            {
              //建立数据结构 写入UserDefault
              //ActionURL ImageURL bannerType
                NSArray *bannerViewData=[NSArray array];
                for (AVObject *obj in objects) {
                    NSString *bannerImageUrl=[obj objectForKey:@"bannerImageUrl"];
                    NSString *bannerParam=[obj objectForKey:@"bannerParam"];
                    NSNumber *bannerType=[obj objectForKey:@"bannerType"];
                    NSDictionary *aBannerDict=@{@"BannerImageUrl":bannerImageUrl,@"BannerParam":bannerParam,@"BannerType":bannerType};
                    bannerViewData=[bannerViewData arrayByAddingObject:aBannerDict];
                }
                //写入数据
                NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
                [mysettings setObject:bannerViewData forKey:@"BannerData"];
                [mysettings synchronize];
                //通知数据加载完成
                
            }
        }else
        {
          //FIXME:网络拉取失败后的动作
            //设置默认的内容
            
            
            
            
            
        }
    }];
}


-(void)dealloc
{
    
    
}

@end
