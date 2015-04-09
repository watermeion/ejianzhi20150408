//
//  AJLocationManager.h
//  locationDemo
//
//  Created by AlienJun on 14-9-21.
//  Copyright (c) 2014年 AlienJun. All rights reserved.
//


#define CityNotFound @"City Not founded"
#define AddressNotFound @"Address Not founded"

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *cityString);
typedef void(^NSStringBlock)(NSString *addressString);

/**
 *  第三方位置管理器，by AlienJun
 *
 *  管理App中所有位置请求的逻辑 by gyb
 */

@interface AJLocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,strong)NSString *lastCity;
@property (nonatomic,strong) NSString *lastAddress;

@property (strong, nonatomic) CLLocationManager *locationManager;

+(AJLocationManager *)shareLocation;
-(void)stopLocation;


/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock;
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock Address:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取坐标和地址
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock;

/**
 *  获取地址
 *
 *  @param addressBlock addressBlock description
 */
- (void) getAddress:(NSStringBlock)addressBlock error:(LocationErrorBlock) errorBlock;

/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

/**
 *  获取城市和定位失败
 *
 *  @param cityBlock  cityBlock description
 *  @param errorBlock errorBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock;

/**
 *  逆向地理编码，通过最新位置获得地址
 */
- (void) getReverseGeocode;


@end
