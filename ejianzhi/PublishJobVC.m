//
//  PublishJobVC.m
//  ejianzhi
//
//  Created by RAY on 15/6/2.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "PublishJobVC.h"
#import "DVSwitch.h"
#import "JianZhi.h"
#import "freeselectViewCell.h"
#import "HZAreaPickerView.h"
#import "QCheckBox.h"
#import "FliterTableViewController.h"
#import "MLDatePickerView.h"
#import "DateUtil.h"
#import "JobDetailVC.h"
#import "MLNavi.h"

#define  PIC_WIDTH 64
#define  PIC_HEIGHT 64
#define  INSETS 10

static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface PublishJobVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,HZAreaPickerDelegate,HZAreaPickerDelegate,QCheckBoxDelegate,FliterTableViewControllerDelegate,MLDatePickerDelegate,finishPublishDelegate>
{
    DVSwitch *switcher;
    
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
    
    UIView *coverView;
    MLDatePickerView *datePickerView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;

//view1
@property (strong, nonatomic) IBOutlet UILabel *selectAreaLabel;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextView;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

//view2
@property (strong, nonatomic) IBOutlet UITextField *jobTitleTextView;
@property (strong, nonatomic) IBOutlet UITextField *salaryTextView;
@property (strong, nonatomic) IBOutlet UILabel *selectSalaryTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *jobNumbersTextView;
@property (strong, nonatomic) IBOutlet UITextField *requirementsTextView;
@property (strong, nonatomic) IBOutlet UILabel *selectJobTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectStartDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectEndDateLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
@property (strong, nonatomic) FliterTableViewController *filterVC;


//view3
@property (strong, nonatomic) IBOutlet UITextView *jobContentTextView;
@property (strong, nonatomic) IBOutlet UITextView *jobDutyTextView;


//model
@property (strong, nonatomic)JianZhi *jianzhiModel;


@end

@implementation PublishJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.jianzhiModel) {
        self.jianzhiModel=[[JianZhi alloc]init];
    }
    
    if (self.filterVC==nil) {
        self.filterVC=[[FliterTableViewController alloc]init];
        self.filterVC.delegate=self;
    }
    
    [self switcherInit];
    
    [self bindingSignal];
    
    [self.view1 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-108)];
    [self.mainScrollView addSubview:self.view1];
    
    [self.view2 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-108)];
    [self.mainScrollView addSubview:self.view2];

    [self.view3 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width*2,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-108)];
    [self.mainScrollView addSubview:self.view3];
    //地点选择
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    
    //view1
    UITapGestureRecognizer *tapgesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseArea)];
    tapgesture1.delegate=self;
    self.selectAreaLabel.userInteractionEnabled=YES;
    [self.selectAreaLabel addGestureRecognizer:tapgesture1];
    //covervView
    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.4;
    
    UITapGestureRecognizer *tapCovervView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(covervViewDidCancel)];
    [coverView addGestureRecognizer:tapCovervView];
    
    QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.frame = CGRectMake(20, 270, 40, 40);
    [_check1 setTitle:nil forState:UIControlStateNormal];
    [_check1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view1 addSubview:_check1];
    [_check1 setChecked:YES];
    _check1.index=1;
    
    QCheckBox *_check2 = [[QCheckBox alloc] initWithDelegate:self];
    _check2.frame = CGRectMake(172, 270, 40, 40);
    [_check2 setTitle:nil forState:UIControlStateNormal];
    [_check2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_check2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view1 addSubview:_check2];
    [_check2 setChecked:YES];
    _check2.index=2;

    //view2
    [self timeCollectionViewInit];

    UITapGestureRecognizer *tapgesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseSalaryType)];
    tapgesture2.delegate=self;
    self.selectSalaryTypeLabel.userInteractionEnabled=YES;
    [self.selectSalaryTypeLabel addGestureRecognizer:tapgesture2];
    
    UITapGestureRecognizer *tapgesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseJobType)];
    tapgesture3.delegate=self;
    self.selectJobTypeLabel.userInteractionEnabled=YES;
    [self.selectJobTypeLabel addGestureRecognizer:tapgesture3];
    
    UITapGestureRecognizer *tapgesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDate1)];
    tapgesture4.delegate=self;
    self.selectStartDateLabel.userInteractionEnabled=YES;
    [self.selectStartDateLabel addGestureRecognizer:tapgesture4];
    
    UITapGestureRecognizer *tapgesture5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDate2)];
    tapgesture5.delegate=self;
    self.selectEndDateLabel.userInteractionEnabled=YES;
    [self.selectEndDateLabel addGestureRecognizer:tapgesture5];
    
    if (!datePickerView) {
        datePickerView=[[MLDatePickerView alloc]initWithStyle:UIDatePickerModeDate delegate:self];
    }

    //view3
    
    self.jobContentTextView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    self.jobContentTextView.layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3]CGColor];
    
    self.jobContentTextView.layer.borderWidth = 1.0;
    
    self.jobContentTextView.layer.cornerRadius = 8.0f;
    
    [self.jobContentTextView.layer setMasksToBounds:YES];
    
    self.jobDutyTextView.layer.borderWidth = 1.0;
    
    self.jobDutyTextView.layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3]CGColor];
    
    self.jobDutyTextView.layer.cornerRadius = 8.0f;
    
    [self.jobDutyTextView.layer setMasksToBounds:YES];
}

- (void)switcherInit{
    self.currentPage=0;
    
    switcher = [DVSwitch switchWithStringsArray:@[@"1.联系信息", @"2.兼职信息", @"3.工作内容"]];
    switcher.frame = CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 44);
    switcher.backgroundColor = [UIColor whiteColor];
    switcher.sliderColor = [UIColor colorWithRed:41.0/255.0 green:169.0/255.0 blue:220.0/255.0 alpha:1.0];
    switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    switcher.labelTextColorOutsideSlider = [UIColor blackColor];
    switcher.cornerRadius = 0;
    switcher.sliderType=blockSlider;
    
    __weak typeof(self) weakSelf = self;
    
    [switcher setWillBePressedHandler:^(NSUInteger index) {
        if (index==0){
            [weakSelf.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            weakSelf.currentPage=0;
        }
        else if (index==1){
            [weakSelf.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
            weakSelf.currentPage=1;
        }
        else if (index==2){
            [weakSelf.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width*2, 0) animated:YES];
            weakSelf.currentPage=2;
        }
    }];
    
    [self.view addSubview:switcher];
}

- (IBAction)clickBtn1:(id)sender {
    [switcher forceSelectedIndex:1 animated:YES];
}
- (IBAction)clickBtn2:(id)sender {
    [switcher forceSelectedIndex:0 animated:YES];
}
- (IBAction)clickBtn3:(id)sender {
    [switcher forceSelectedIndex:2 animated:YES];
}
- (IBAction)clickBtn4:(id)sender {
    [switcher forceSelectedIndex:1 animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=NO;
    
    if (self.currentPage==0)
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    else if (self.currentPage==1)
        [self.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
    else if (self.currentPage==2)
        [self.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width*2, 0) animated:YES];
    
    [switcher forceSelectedIndex:self.currentPage animated:NO];
    
}

- (void)timeCollectionViewInit{
    
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = ([UIScreen mainScreen].bounds.size.width - 100)/7;
    
    selectfreetimetitleArray = @[
                                 [UIImage imageNamed:@"d1"],
                                 [UIImage imageNamed:@"d2"],
                                 [UIImage imageNamed:@"d3"],
                                 [UIImage imageNamed:@"d4"],
                                 [UIImage imageNamed:@"d5"],
                                 [UIImage imageNamed:@"d6"],
                                 [UIImage imageNamed:@"d7"],
                                 ];
    
    selectfreetimepicArray = @[[UIImage imageNamed:@"no"],
                               [UIImage imageNamed:@"yes"],
                               [UIImage imageNamed:@"no"],
                               [UIImage imageNamed:@"yes"],
                               [UIImage imageNamed:@"no"],
                               [UIImage imageNamed:@"yes"]
                               ];
    
    
    for (int index = 0; index<21; index++) {
        selectFreeData[index] = FALSE;
    }
    
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 28;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(freecellwidth, freecellwidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=0 && indexPath.row<7) {
        return NO;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectFreeData[indexPath.row-7] = selectFreeData[indexPath.row-7]?false:true;
    [collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    freeselectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectFreecellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[freeselectViewCell alloc]init];
    }
    
    if (indexPath.row>=0 && indexPath.row<7) {
        cell.imageView.image = [selectfreetimetitleArray objectAtIndex:indexPath.row];
    }
    
    
    if (indexPath.row>=7 && indexPath.row<14) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:1];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:0];
        }
        
    }
    if (indexPath.row>=14 && indexPath.row<21) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:3];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:2];
        }
    }
    if (indexPath.row>=21 && indexPath.row<28) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:5];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:4];
        }
    }
    return cell;
};

- (void)chooseArea{
    [self.view addSubview:coverView];
    [self.locatePicker showInView:self.view];
}

- (void)bindingSignal{
    
    [self.addressTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiAddress=text;
    }];
    [self.emailTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiContactEmail=text;
    }];
    [self.nameTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiContactName=text;
    }];
    [self.phoneTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiContactPhone=text;
    }];

    [self.jobTitleTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiTitle=text;
    }];

    [self.salaryTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiWage=[NSNumber numberWithFloat:[text floatValue]];
    }];

    [self.jobNumbersTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiRecruitment=[NSNumber numberWithFloat:[text intValue]];
    }];
    
    [self.requirementsTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianzhiTeShuYaoQiu=text;
    }];
    
    [self.jobContentTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiContent=text;
    }];
    
    [self.jobDutyTextView.rac_textSignal subscribeNext:^(NSString *text) {
        self.jianzhiModel.jianZhiRequirement=text;
    }];
}


-(void)covervViewDidCancel{
    [coverView removeFromSuperview];
    [self.locatePicker cancelPicker];
    [datePickerView cancelPicker];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
//    self.userDetailModel.userProvince=picker.locate.state;
//    self.userDetailModel.userCity=picker.locate.city;
//    self.userDetailModel.userDistrict=picker.locate.district;
    NSString *addr=[NSString stringWithFormat:@"%@%@%@",picker.locate.state,picker.locate.city,picker.locate.district];
    self.selectAreaLabel.text=addr;
    [coverView removeFromSuperview];
}

- (void)pickerCancel:(HZAreaPickerView *)picker{
    [picker cancelPicker];
    [coverView removeFromSuperview];
}

#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    NSLog(@"did tap on CheckBox:%d checked:%d", checkbox.index, checked);
}

- (void)chooseSalaryType{
    
    NSArray *array=[[NSUserDefaults standardUserDefaults]objectForKey:FliterSettlementWay];
    
    self.filterVC.datasource=array;
    self.filterVC.viewType=FliterViewTypeSettlement;
        
    self.filterVC.row=0;
    
    self.filterVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:self.filterVC animated:YES];
}

-(void)selectedResults:(NSString *)result ViewType:(FliterViewType) viewtype{
    
    switch (viewtype) {
        case FliterViewTypeSettlement:
            
            self.selectSalaryTypeLabel.text=result;
            self.jianzhiModel.jianZhiWageType=result;

            break;
        case FliterViewTypeType:
            
            self.selectJobTypeLabel.text=result;
            self.jianzhiModel.jianZhiType=result;

            break;
        case FliterViewTypeArea:
            
            break;
    }
}

- (void)chooseJobType{
    
    NSArray *array=[[NSUserDefaults standardUserDefaults]objectForKey:FliterType];
    
    self.filterVC.datasource=array;
    self.filterVC.viewType=FliterViewTypeType;
    self.filterVC.row=0;
    
    self.filterVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:self.filterVC animated:YES];
}

- (void)chooseDate1{
    [datePickerView setBirthday:[NSDate date]];
    datePickerView.index=1;
    [self.view addSubview:coverView];
    [datePickerView showInView:self.view];

}

- (void)chooseDate2{
    [datePickerView setBirthday:[NSDate date]];
    datePickerView.index=2;
    [self.view addSubview:coverView];
    [datePickerView showInView:self.view];
}

- (void)timePickerDidChangeStatus:(UIDatePicker *)picker{
    [coverView removeFromSuperview];
    
    if (picker.tag==1) {
        self.jianzhiModel.jianZhiTimeStart=picker.date;
        NSString *date = [DateUtil birthdayStringFromDate:picker.date];
        [self.selectStartDateLabel setText:date];
    }else if (picker.tag==2){
        self.jianzhiModel.jianZhiTimeEnd=picker.date;
        NSString *date = [DateUtil birthdayStringFromDate:picker.date];
        [self.selectEndDateLabel setText:date];
    }
}

- (void)timePickerDidCancel{
    [coverView removeFromSuperview];
}

- (IBAction)previewJob:(id)sender {
    
    NSMutableArray *tempFreeTime = [[NSMutableArray alloc]init];
    for (int index = 0; index<21 ; index++) {
        if (selectFreeData[index] == TRUE) {
            [tempFreeTime addObject:[NSString stringWithFormat:@"%d",index]];
        }
    }
    self.jianzhiModel.jianZhiWorkTime=[tempFreeTime componentsJoinedByString:@","];
    
    self.jianzhiModel.jianZhiQiYe=self.curUsr;
    
    JobDetailVC *jobDetailVC=[[JobDetailVC alloc]initWithData:self.jianzhiModel];
    jobDetailVC.fromEnterprise=YES;
    jobDetailVC.isPreview=YES;
    jobDetailVC.saveDelegate=self;

    
    
     [self presentViewController:[[MLNavi alloc] initWithRootViewController:jobDetailVC] animated:YES completion:nil];
}

- (void)finishSave{
    [self.navigationController popViewControllerAnimated:YES];
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
