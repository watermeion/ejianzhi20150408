//
//  MLTemplateVC.m
//  EJianZhi
//
//  Created by RAY on 15/2/6.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLTemplateVC.h"
#import "QRadioButton.h"

@interface MLTemplateVC ()<QRadioButtonDelegate>
@property (weak, nonatomic) IBOutlet UIView *subView1;

@end

@implementation MLTemplateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"网页填写" style:UIBarButtonItemStylePlain target:self action:@selector(fillOnWeb)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    [self addRadioBtn];
}


-(void)addRadioBtn{
    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio1.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-155, 48, 90, 40);
    [_radio1 setTitle:@"麻辣至极" forState:UIControlStateNormal];
    [_radio1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.subView1 addSubview:_radio1];
    [_radio1 setChecked:YES];
    
    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio2.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-45, 48, 90, 40);
    [_radio2 setTitle:@"优雅文化" forState:UIControlStateNormal];
    [_radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.subView1 addSubview:_radio2];
    
    QRadioButton *_radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio3.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2+65, 48, 80, 40);
    [_radio3 setTitle:@"商务风" forState:UIControlStateNormal];
    [_radio3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.subView1 addSubview:_radio3];
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    
}


- (void)fillOnWeb {
    
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
