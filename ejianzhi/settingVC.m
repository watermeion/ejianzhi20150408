//
//  settingVC.m
//  ejianzhi
//
//  Created by RAY on 15/4/19.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "settingVC.h"
#import "UIImageView+EMWebCache.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

@interface settingVC ()
@property (strong, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation settingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cacheLabel.text=[NSString stringWithFormat:@"%.1fM",(float)[[EMSDImageCache sharedImageCache] getSize]/(1024*1024)];
}
- (IBAction)clearCache:(id)sender {
    
    [[EMSDImageCache sharedImageCache] clearDiskOnCompletion:^{

        [MBProgressHUD showSuccess:@"清除成功" toView:self.view];
        self.cacheLabel.text=[NSString stringWithFormat:@"%.1fM",(float)[[EMSDImageCache sharedImageCache] getSize]/(1024*1024)];
        [[EMSDImageCache sharedImageCache] clearMemory];
    }];
}

- (IBAction)showIntroduction:(id)sender {
}
- (IBAction)showAboutUs:(id)sender {
}
- (IBAction)modifyPhone:(id)sender {
}
- (IBAction)modifyPassword:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
