//
//  ViewModel.h
//  EJianZhi
//
//  Created by Mac on 3/21/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageSplitingManager.h"
#import "MLLoginManger.h"
@interface ViewModel : NSObject

@property (strong,nonatomic) NSArray *resultsList;
@property (strong,nonatomic) NSError *error;
@property (nonatomic,assign) BOOL nowOperationState;

@property (nonatomic,strong) PageSplitingManager *pageManager;
//保持loginManager 用于控制用户登录状态
@property (nonatomic,weak) MLLoginManger *loginManager;
-(id) init;
/**
 *  单一查询
 *
 *  @param classname classname description
 *  @param key       key description
 *  @param value     value description
 */
- (void) queryObjectsFromAVOSWithClassName:(NSString *) classname
                                      Key:(NSString *) key
                                    Value:(NSString *) value;


- (void) queryObjectsFromAVOSWithClassName:(NSString *)classname
                                      Skip:(NSUInteger)skip
                                     Limit:(NSUInteger)limit;

@end
