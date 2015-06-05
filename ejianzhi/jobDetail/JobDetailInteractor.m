//
//  JobDetailInteractor.m
//  EJianZhi
//
//  Created by Mac on 4/1/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "JobDetailInteractor.h"
#import "MLMapManager.h"
@interface JobDetailInteractor ()
@property (weak,nonatomic) MLMapManager *mapManager;
@end

@implementation JobDetailInteractor
- (MLMapManager*)mapManager
{
    if (_mapManager==nil) {
        _mapManager=[MLMapManager shareInstance];
    }
    return _mapManager;
}



@end
