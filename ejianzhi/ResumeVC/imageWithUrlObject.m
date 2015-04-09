//
//  imageWithUrlObject.m
//  EJianZhi
//
//  Created by RAY on 15/4/6.
//  Copyright (c) 2015年 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "imageWithUrlObject.h"
#import "UIImageView+EMWebCache.h"
@implementation imageWithUrlObject

- (void)loadImageWithUrl{
    if (self.url) {
        EMSDWebImageManager *manager = [EMSDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            self.image=image;
        }];
    }
}

- (imageWithUrlObject*)initWithUrl:(NSString*)url{
    if (self=[super init]) {
        self.url=url;
        self.image=[UIImage imageNamed:@"placeholder"];
        [self loadImageWithUrl];
    }
    return self;
}

- (imageWithUrlObject*)initWithUrl:(NSString*)url AndImage:(UIImage*)image{
    if (self=[super init]) {
        self.url=url;
        self.image=image;
    }
    return self;
}

- (imageWithUrlObject*)initWithImage:(UIImage*)image{
    if (self=[super init]) {
        self.image=image;
    }
    return self;

}
@end
