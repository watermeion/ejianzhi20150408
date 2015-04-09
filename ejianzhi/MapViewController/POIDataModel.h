//
//  POIDataModel.h
//  EJianZhi
//
//  Created by Mac on 3/30/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectPOIViewController.h"
@interface POIDataModel : NSObject<SelectPOIData>
@property (nonatomic,strong)NSString *address;
//目前的地址的index
@property (nonatomic) NSInteger index;

@property CLLocationCoordinate2D position;
@end
