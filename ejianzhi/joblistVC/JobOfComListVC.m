//
//  JobOfComListVC.m
//  ejianzhi
//
//  Created by Mac on 4/28/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "JobOfComListVC.h"
#import "MLJianZhiViewModel.h"
@implementation JobOfComListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"更多兼职";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setCompanyAndQuery:(id)company
{
    if (self.viewModel==nil) {
        return;
    }
    if (company!=nil) {
        [self.viewModel setMainQueryJianZhiParametersWithKey:@"qiYeInfoId" Value:company];
        [self firstLoad];
    }
}


-(void)firstLoad
{
    if([self.viewModel isKindOfClass:[MLJianZhiViewModel class]])
    {
        MLJianZhiViewModel *viewModel=(MLJianZhiViewModel*)self.viewModel;
        [viewModel headerRefresh];
    }
    
}

@end
