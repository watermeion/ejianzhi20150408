//
//  AVQuery+common.h
//  ejianzhi
//
//  Created by Mac on 5/6/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface AVQuery (common)

-(void)setQueryIsOutDate:(BOOL)isoutdate;
-(void)setQueryIsTest:(BOOL)istests;
-(void)setQueryIsShowInHome:(BOOL)isshowinhome;

@end
