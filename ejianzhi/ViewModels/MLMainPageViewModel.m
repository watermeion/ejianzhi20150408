//
//  MLMainPageViewModel.m
//  EJianZhi
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "MLMainPageViewModel.h"
#import "AJLocationManager.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface MLMainPageViewModel()

@property (weak,nonatomic)AJLocationManager *locationManager;
@end

@implementation MLMainPageViewModel

- (instancetype)init
{
   if (self=[super init])
   {
       self.locationManager=[AJLocationManager shareLocation];
       //添加RAC监听
       @weakify(self)
       [RACObserve(self.locationManager,lastCity) subscribeNext:^(NSString *city) {
           @strongify(self)
           if ([city isEqualToString:CityNotFound]) {
               self.cityName=@"选择城市";
           }else{
               self.cityName=[self formatCityName:city];
           }
       }];
       self.cityName=@"选择城市";
       return self;
   }
    return nil;
}


- (NSString*)formatCityName:(NSString*)originName;
{
    if (originName.length>4) {
        return [originName substringToIndex:4];
    }
    return originName;
}

- (void)startLocatingToGetCity
{
    
    [self.locationManager getCity:^(NSString *addressString) {
        //可以不写
//        self.cityName=addressString;
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"定位失败" toView:nil];
    }];
}

@end
