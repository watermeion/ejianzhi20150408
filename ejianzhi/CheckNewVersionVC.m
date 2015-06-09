//
//  CheckNewVersionVC.m
//  ejianzhi
//
//  Created by RAY on 15/6/8.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "CheckNewVersionVC.h"

@interface CheckNewVersionVC ()
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;

@end

@implementation CheckNewVersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.downloadBtn.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1.0 });
    [self.downloadBtn.layer setBorderColor:colorref];
    [self.downloadBtn.layer setCornerRadius:5.0];
}
- (IBAction)downLoad:(id)sender {
    NSURL* url = [[ NSURL alloc ] initWithString :@"https://appsto.re/cn/x41n7.i"];
    [[UIApplication sharedApplication ] openURL:url];
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
