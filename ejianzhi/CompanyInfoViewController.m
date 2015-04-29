//
//  CompanyInfoViewController.m
//  ejianzhi
//
//  Created by Mac on 4/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "JobOfComListVC.h"
#import "CompanyInfoViewModel.h"
@interface CompanyInfoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)seeMoreJobAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView1;
@property (weak, nonatomic) IBOutlet UILabel *comTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *comIconView;
@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *comAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *comContactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *comPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *comEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *comFileCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *comIndustryLabel;
@property (weak, nonatomic) IBOutlet UILabel *comPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *comScaleLabel;


@property (strong,nonatomic)CompanyInfoViewModel *viewModel;
@end

@implementation CompanyInfoViewController

-(instancetype)init
{
    return nil;
}

-(instancetype)initWithData:(id)company
{
    if (self=[super init]) {
        if (company!=nil) {
            self.company=company;
        }
        
    }
    return self;
}






-(void)viewWillLayoutSubviews
{
 NSLog(@"contentSize.width:%f",self.scrollView.contentSize.width);
     self.scrollView.contentSize=CGSizeMake(MainScreenWidth,self.scrollView.contentSize.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.scrollView.contentSize=CGSizeMake(MainScreenWidth,self.scrollView.contentSize.height);
    [self.comIconView.layer setCornerRadius:40.0f];
    [self.comIconView.layer setMasksToBounds:YES];
    if (self.company!=nil) {
          self.viewModel=[[CompanyInfoViewModel alloc]initWithData:self.company];
    }
  
    RAC(self.comTitleLabel,text)=RACObserve(self.viewModel,comTitle);
    RAC(self.comNameLabel,text)=RACObserve(self.viewModel, comName);
    RAC(self.comAreaLabel,text)=RACObserve(self.viewModel, comArea);
    RAC(self.comAddressLabel,text)=RACObserve(self.viewModel, comAddress);
    RAC(self.comPhoneLabel,text)=RACObserve(self.viewModel, comPhone);
    RAC(self.comEmailLabel,text)=RACObserve(self.viewModel, comEmail);
    RAC(self.comScaleLabel,text)=RACObserve(self.viewModel, comScaleNum);
    RAC(self.comFileCodeLabel,text)=RACObserve(self.viewModel, comFileNum);
    RAC(self.comIndustryLabel,text)=RACObserve(self.viewModel, comIndustry);
    RAC(self.comPropertyLabel,text)=RACObserve(self.viewModel, comProperty);
    RAC(self.comContactorLabel,text)=RACObserve(self.viewModel, comContactors);
    RAC(self.comIconView,image)=RACObserve(self.viewModel, comIcon);
    RAC(self.tagImageView1,image)=RACObserve(self.viewModel, tag1Icon);

    [self.viewModel fetchCompanyDataFromAVOS:self.company];
    
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

- (IBAction)seeMoreJobAction:(id)sender {
    JobOfComListVC *jobListForCom=[[JobOfComListVC alloc]init];
    [self.navigationController pushViewController:jobListForCom animated:YES];
    
    if (self.company!=nil) {
        [jobListForCom setCompanyAndQuery:self.company];
    }
    
}



@end
