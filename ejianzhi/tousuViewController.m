//
//  tousuViewController.m
//  ejianzhi
//
//  Created by Mac on 4/20/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "tousuViewController.h"

@interface tousuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)submitAction:(id)sender;

@end

@implementation tousuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    //设置Btn信息
    [self.submitBtn.layer setBorderWidth:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 247/255.0, 79/255.0, 92/255.0, 1.0 });
    [self.submitBtn.layer setBorderColor:colorref];//边框颜色
    [self.submitBtn.layer setCornerRadius:5.0];
    
    RACSignal *textNotNilSignal=[self.tousuliyouTextView.rac_textSignal map:^id(NSString *text) {
        return @(text.length>0);
    }];
    
    [textNotNilSignal subscribeNext:^(NSNumber *x) {
        self.submitBtn.enabled=[x boolValue];
        self.submitBtn.backgroundColor=[x boolValue]?[UIColor lightTextColor]:[UIColor lightGrayColor];
    }];
    
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

- (IBAction)submitAction:(id)sender {
    //FIXME:提交投诉
    if (self.tousuliyouTextView.text.length>0) {
        [self.delegate commitTousu:self.tousuliyouTextView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
