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
/**
 *  本类的功能：1、为首页的推荐搜索 提供支持
 *            2、为刷新列表提供支持
 *            3、但不为搜索列表提供支持
 */
@interface MLJianZhiViewModel : ViewModel


-(AVQuery*)setFliterSubQueryParams:(NSString*)fliterContent objectKey:(NSString*)keyword;

-(void)setOtherQuery:(NSString*)keyword;
-(void)setTypeQuery:(NSString*)keyword;
-(void)setSettlementQuery:(NSString*)keyword;
/**
 *  将resultsList中的Model 映射成前端View可以显示的内容
 *  暂时不用
 */

- (instancetype)init;

/**
 *  第一次加载
 */
- (void) firstLoad;

- (void) footerRefresh;

- (void) headerRefresh;
@end
