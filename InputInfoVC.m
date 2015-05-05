//
//  InputInfoVC.m
//  ejianzhi
//
//  Created by RAY on 15/5/2.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "InputInfoVC.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "HZAreaPickerView.h"
#import "QRadioButton.h"

@interface InputInfoVC ()<HZAreaPickerDelegate,QRadioButtonDelegate>
{
    NSString *EnterpriseProperty;
}
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation InputInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputInfoLabel.text=self.labelText;
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(notSaveInfo)];
    
    if (self.inputType==10) {
        self.inputTextField.hidden=YES;
        
        QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio1.frame = CGRectMake(20, 70, 200, 20);
        [_radio1 setTitle:@"国有企业" forState:UIControlStateNormal];
        [_radio1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio1 setStatus:@"国有企业"];
        [self.view addSubview:_radio1];
        [_radio1 setChecked:YES];
        
        QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio2.frame = CGRectMake(20, 100, 200, 20);;
        [_radio2 setTitle:@"私营企业" forState:UIControlStateNormal];
        [_radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio2 setStatus:@"私营企业"];
        [self.view addSubview:_radio2];
        
        QRadioButton *_radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio3.frame = CGRectMake(20, 130, 200, 20);;
        [_radio3 setTitle:@"中外合资企业" forState:UIControlStateNormal];
        [_radio3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio3 setStatus:@"中外合资企业"];
        [self.view addSubview:_radio3];
        
        QRadioButton *_radio4 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio4.frame = CGRectMake(20, 160, 200, 20);;
        [_radio4 setTitle:@"个体户" forState:UIControlStateNormal];
        [_radio4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio4.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio4 setStatus:@"个体户"];
        [self.view addSubview:_radio4];
        
        QRadioButton *_radio5 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio5.frame = CGRectMake(20, 190, 200, 20);;
        [_radio5 setTitle:@"外资企业" forState:UIControlStateNormal];
        [_radio5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio5.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio5 setStatus:@"外资企业"];
        [self.view addSubview:_radio5];
        
        QRadioButton *_radio6 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio6.frame = CGRectMake(20, 220, 200, 20);;
        [_radio6 setTitle:@"事业单位" forState:UIControlStateNormal];
        [_radio6 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio6.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio6 setStatus:@"事业单位"];
        [self.view addSubview:_radio6];
        
        QRadioButton *_radio7 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio7.frame = CGRectMake(20, 250, 200, 20);;
        [_radio7 setTitle:@"集体企业" forState:UIControlStateNormal];
        [_radio7 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio7.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio7 setStatus:@"集体企业"];
        [self.view addSubview:_radio7];
        
        QRadioButton *_radio8 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio8.frame = CGRectMake(20, 280, 200, 20);;
        [_radio8 setTitle:@"股份制公司" forState:UIControlStateNormal];
        [_radio8 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio8.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio8 setStatus:@"股份制公司"];
        [self.view addSubview:_radio8];
        
        QRadioButton *_radio9 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio9.frame = CGRectMake(20, 310, 200, 20);;
        [_radio9 setTitle:@"其他" forState:UIControlStateNormal];
        [_radio9 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio9.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio9 setStatus:@"其他"];
        [self.view addSubview:_radio9];
    }
    
    if (self.inputType==11) {
        self.inputTextField.hidden=YES;
        
        QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio1.frame = CGRectMake(20, 70, 200, 20);
        [_radio1 setTitle:@"10人以下" forState:UIControlStateNormal];
        [_radio1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio1 setStatus:@"10人以下"];
        [self.view addSubview:_radio1];
        [_radio1 setChecked:YES];
        
        QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio2.frame = CGRectMake(20, 100, 200, 20);;
        [_radio2 setTitle:@"50人以下" forState:UIControlStateNormal];
        [_radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio2 setStatus:@"50人以下"];
        [self.view addSubview:_radio2];
        
        QRadioButton *_radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio3.frame = CGRectMake(20, 130, 200, 20);;
        [_radio3 setTitle:@"200人以下" forState:UIControlStateNormal];
        [_radio3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio3 setStatus:@"200人以下"];
        [self.view addSubview:_radio3];
        
        QRadioButton *_radio4 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
        _radio4.frame = CGRectMake(20, 160, 200, 20);;
        [_radio4 setTitle:@"200人以上" forState:UIControlStateNormal];
        [_radio4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radio4.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_radio4 setStatus:@"200人以上"];
        [self.view addSubview:_radio4];

    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputTextField resignFirstResponder];
}

- (void)saveInfo{
    if (self.inputType==10||self.inputType==11) {
        if ([EnterpriseProperty length]!=0) {
            [self.inputDelegate finishInputWithType:self.inputType And:EnterpriseProperty];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"请填写信息后保存" toView:self.view];
        }
    }
    else{
        if ([[self.inputTextField text] length]==0)
            [MBProgressHUD showError:@"请填写信息后保存" toView:self.view];
        else{
            [self.inputDelegate finishInputWithType:self.inputType And:self.inputTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)notSaveInfo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    EnterpriseProperty=[radio getStatus];
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
