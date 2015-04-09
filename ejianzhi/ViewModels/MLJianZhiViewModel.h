//
//  MLJianZhiViewModel.h
//  EJianZhi
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JianZhi.h"
#import "ViewModel.h"
@interface MLJianZhiViewModel : ViewModel<UITableViewDataSource>

/**
 *  queryJianZhiFromAVOSWithKey
 *
 *  @param key   key description
 *  @param value value description
 */
- (void) queryJianZhiFromAVOSWithKey:(NSString*) key
                               Value:(NSString*) value;



- (void) queryJianZhiFromAVOSWithSkip:(NSUInteger)skip
                                Limit:(NSUInteger)limit;




/**
 *  将resultsList中的Model 映射成前端View可以显示的内容
 *  暂时不用
 */
- (void) mapResultsList;

- (instancetype)init;

- (void) footerRefresh;

- (void) headerRefresh;
@end
