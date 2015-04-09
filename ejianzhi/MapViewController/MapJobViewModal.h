//
//  MapJobViewModal.h
//  EJianZhi
//
//  Created by Mac on 3/28/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "ViewModel.h"
#import "MLMapView.h"
#import "JianZhi.h"
#import "MLMapManager.h"
/**
 *  负责MapViewController 的逻辑任务
 */

@interface MapJobViewModal : ViewModel<showDetailDelegate>

@property (weak,nonatomic)MLMapView *handleView;

@property (weak,nonatomic)MLMapManager *mapManager;
@property (strong,nonatomic)NSArray *addressArray;
/**
 *  完成列表中兼职的地图展示
 *
 *  @param datasource JianZhi Model Array
 */
-(void) showTableListInMap:(NSArray *)datasource;

/**
 *  查询指定点周围的兼职。默认范围10km 没有默认限制
 *
 *  @param point 指定点坐标
 */
-(void)queryJianzhiByLocation:(CLLocationCoordinate2D) point;


@end
