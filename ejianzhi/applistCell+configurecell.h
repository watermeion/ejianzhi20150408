//
//  applistCell+configurecell.h
//  ejianzhi
//
//  Created by Mac on 5/7/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "applistCell.h"
#import "JianZhiShenQing.h"
@interface applistCell (configurecell)
- (void)CellConfigure:(JianZhiShenQing*)object;
- (void)CellConfigureForFavorList:(AVObject *)object;



@end
