//
//  MapJobViewModal.m
//  EJianZhi
//
//  Created by Mac on 3/28/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "MapJobViewModal.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@implementation MapJobViewModal

-(NSArray *)addressArray
{
    if(_addressArray==nil)
    {
        _addressArray=[NSArray array];
     
    }
    return _addressArray;
}


-(instancetype)init
{
    if (self=[super init]) {
        self.mapManager=[MLMapManager shareInstance];
        return self;
    }
    return nil;
}


-(void)setHandleView:(MLMapView *)handleView
{
    if (handleView!=nil) {
        _handleView=handleView;
        //添加数据监听
        @weakify(self)
        [RACObserve(self, resultsList) subscribeNext:^(NSArray *x) {
            @strongify(self)
            if (x.count>0) {
                [self showTableListInMap:x];
            };
        }];
    }
}
/**
 *  完成列表中兼职的地图展示
 *
 *  @param datasource JianZhi Model Array
 */
-(void) showTableListInMap:(NSArray *)datasource
{
    if (self.handleView==nil) {
        return;
    }
    if (datasource.count==0) {
        return;
    }
    for (int i=0; i<datasource.count; i++)
    {
        JianZhi *job=[datasource objectAtIndex:i];
        if (job.jianZhiPoint==nil) {
            continue;
        }
        CLLocationCoordinate2D point= CLLocationCoordinate2DMake(job.jianZhiPoint.latitude, job.jianZhiPoint.longitude);
        NSString *titleString=job.jianZhiTitle;
        NSString *subtitle=[NSString stringWithFormat:@"%@元/%@",[job.jianZhiWage stringValue],job.jianZhiWageType];
        [self.handleView addAnnotation:point Title:titleString Subtitle:subtitle Index:i SetToCenter:NO];
    }
}


-(void)queryJianzhiByLocation:(CLLocationCoordinate2D) point
{
    AVGeoPoint *userLocation =[AVGeoPoint geoPointWithLatitude:point.latitude  longitude:point.longitude];
    AVQuery *query = [AVQuery queryWithClassName:@"JianZhi"];
    [query whereKey:@"jianZhiPoint" nearGeoPoint:userLocation withinKilometers:10];
    //获取最接近用户地点的10条数据
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            if (objects.count>0) {
                NSLog(@"%lu",(unsigned long)objects.count);
                self.resultsList=objects;
            }else
            {
                //做一些其他处理
                //提示没有更多
                [MBProgressHUD showError:@"附近没有你要找的兼职~" toView:nil];
                
            }
           
        } else {
            // 输出错误信息
            NSLog(@"ViewModelError: %@ %@", error, [error userInfo]);
            [MBProgressHUD showError:@"出错啦，请重试~" toView:nil];
            self.error=[[NSError alloc]init];
            self.error=error;
        }
    }];
}

@end
