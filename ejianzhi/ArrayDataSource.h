//
//  ArrayDataSource.h
//  ejianzhi
//
//  Created by Mac on 4/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  Block 用于设置cell的内容
 *
 *  @param cell 需要设置的cell
 *  @param item 数据源
 */
typedef void (^TableViewCellConfigureBlock)(id cell,id item);
@interface ArrayDataSource : NSObject<UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems
    cellIndentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfiureBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
