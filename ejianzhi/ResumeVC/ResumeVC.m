//
//  ResumeVC.m
//  EJianZhi
//
//  Created by RAY on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "ResumeVC.h"
#import "DVSwitch.h"
#import "freeselectViewCell.h"
#import "MLTemplateVC.h"
#import "MLStudentCard.h"
#import "MLSelectInffShow.h"
#import "imageButton.h"
#import "MLTextUtils.h"
#import "UIImage+RTTint.h"
#import "MLSelectJobTypeVC.h"
#import "MLDatePickerView.h"
#import "DateUtil.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "MLResumePreviewVC.h"
#import "SRLoginVC.h"
#import "QRadioButton.h"
#import "HZAreaPickerView.h"
#import "AJLocationManager.h"
#import "UIImageView+EMWebCache.h"
#import "imageWithUrlObject.h"

#define  PIC_WIDTH 64
#define  PIC_HEIGHT 64
#define  INSETS 10

static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface ResumeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,finishSelectDelegate,MLDatePickerDelegate,selectInfoShowDelegate,identifySchoolDelegate,QRadioButtonDelegate,finishSaveDelegate,UITextViewDelegate,HZAreaPickerDelegate>
{
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
    DVSwitch *switcher;
    NSMutableArray *intentionTypeArray;
    NSMutableArray *userImages;
    
    //召唤生日与地区时候的覆盖view
    UIView *coverView;
    MLDatePickerView *datePickerView;
    
    //选择点击图片按钮
    imageButton *didSelectedBTN;
    
    QRadioButton *_radio1;
    QRadioButton *_radio2;
}
@property (weak, nonatomic) IBOutlet UIScrollView *picscrollview;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *indentifyImage;
@property (strong, nonatomic) IBOutlet UILabel *selectIntentionLabel;
@property (strong, nonatomic) IBOutlet UITextView *introductionTextView;
@property (strong, nonatomic) IBOutlet UITextView *experienceTextView;
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *districtLabel;
@property (strong, nonatomic) IBOutlet UITextField *schoolLabel;
@property (strong, nonatomic) IBOutlet UITextField *majorLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *qqNumberLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberLabel;
@property (assign, nonatomic) int currentPage;
@property (strong, nonatomic) IBOutlet UIView *containerView3;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;


@end

@implementation ResumeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self picScrollViewInit];
    
    [self switcherInit];
    
    if (!self.userDetailModel) {
        self.userDetailModel=[UserDetail object];
    }
    self.navigationItem.title=@"编辑简历";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(previewResume)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    //page1
    [self timeCollectionViewInit];
    [self.view1 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-268)];
    [self.mainScrollView addSubview:self.view1];
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIntentionType)];
    tapgesture.delegate=self;
    self.selectIntentionLabel.userInteractionEnabled=YES;
    [self.selectIntentionLabel addGestureRecognizer:tapgesture];
    
    
    //page2
    [self.view2 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-268)];
    [self.mainScrollView addSubview:self.view2];
    
    self.introductionTextView.tag=111;
    self.introductionTextView.delegate=self;
    
    self.experienceTextView.tag=222;
    self.experienceTextView.delegate=self;
    
    //page3
    [self.view3 setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width*2,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-268)];
    
    [self.mainScrollView addSubview:self.view3];
    
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(indentify)];
    gesture.delegate=self;
    [self.indentifyImage addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *tapgesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCityAction)];
    tapgesture2.delegate=self;
    self.districtLabel.userInteractionEnabled=YES;
    [self.districtLabel addGestureRecognizer:tapgesture2];
    
    //地点选择
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    //选择生日
    UITapGestureRecognizer *tapgesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseBirthday)];
    tapgesture1.delegate=self;
    self.birthDateLabel.userInteractionEnabled=YES;
    [self.birthDateLabel addGestureRecognizer:tapgesture1];
    
    if (!datePickerView) {
        datePickerView=[[MLDatePickerView alloc]initWithStyle:UIDatePickerModeDate delegate:self];
    }
    //covervView
    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.4;
    
    UITapGestureRecognizer *tapCovervView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(covervViewDidCancel)];
    [coverView addGestureRecognizer:tapCovervView];

    self.currentPage=0;
    
    if (userImages == Nil) {
        userImages=[[NSMutableArray alloc] init];
    }
    //选择性别
    _radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
    _radio1.frame = CGRectMake(85, 55, 40, 20);
    [_radio1 setTitle:@"男" forState:UIControlStateNormal];
    [_radio1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_radio1 setStatus:maleStatus];
    [self.containerView3 addSubview:_radio1];
    [_radio1 setChecked:YES];
    
    _radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"group1"];
    _radio2.frame = CGRectMake(125, 55, 40, 20);;
    [_radio2 setTitle:@"女" forState:UIControlStateNormal];
    [_radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_radio2 setStatus:femaleStatus];
    [self.containerView3 addSubview:_radio2];
    
    [self initData];
    
    [self bindingSignal];
}

- (void)bindingSignal{
    //姓名
    [self.nameLabel.rac_textSignal subscribeNext:^(NSString *text) {
        self.userDetailModel.userRealName=text;
    }];
    //身高
    [self.heightLabel.rac_textSignal subscribeNext:^(NSString *text) {
        self.userDetailModel.userHeight=text;
    }];
    //学校
    [self.schoolLabel.rac_textSignal subscribeNext:^(NSString *text) {
        self.userDetailModel.userSchool=text;
    }];
    //专业
    [self.majorLabel.rac_textSignal subscribeNext:^(NSString *text) {
        self.userDetailModel.userProfesssion=text;
    }];
    //邮箱
    [self.emailLabel.rac_textSignal subscribeNext:^(NSString *text) {
        self.userDetailModel.userEmail=text;
    }];
    //QQ号
    [self.qqNumberLabel.rac_textSignal subscribeNext:^(NSString *text) {
        self.userDetailModel.userQQ=text;
    }];
    //手机号
    [self.phoneNumberLabel.rac_textSignal subscribeNext:^(NSString *text) {
        self.userDetailModel.userMobile=text;
    }];

}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    self.userDetailModel.userGender=[radio getStatus];
}

-(void)finishSave{
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)touchPreviewBtn:(id)sender {
    [self previewResume];
}

- (void)previewResume{
    
    NSMutableArray *tempFreeTime = [[NSMutableArray alloc]init];
    for (int index = 0; index<21 ; index++) {
        if (selectFreeData[index] == TRUE) {
            [tempFreeTime addObject:[NSString stringWithFormat:@"%d",index]];
        }
    }
    self.userDetailModel.userIdleTime=[tempFreeTime componentsJoinedByString:@","];
    
    //保存头像
    if (addedPicArray != Nil) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (int index=1 ; index<addedPicArray.count ; index++ ) {
            imageButton *btn = [addedPicArray objectAtIndex:index];
            if ([btn getStatus] == uploadOK || [btn getStatus] == fromNet) {
                NSString *tempURL = [btn geturl];
                if (tempURL != Nil) {
                    [tempArray addObject:tempURL];
                }
            }
        }
        NSArray *reverceTemp = [[tempArray reverseObjectEnumerator] allObjects];
        self.userDetailModel.userImageArray=reverceTemp;
    }
    
    //objectId
    self.userDetailModel.userObjectId=[AVUser currentUser].objectId;
    
    MLResumePreviewVC *previewVC=[[MLResumePreviewVC alloc]init];
    previewVC.type=0;
    previewVC.userImageArray=(NSArray*)userImages;
    previewVC.userDetailModel=self.userDetailModel;
    previewVC.saveDelegate=self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:previewVC] animated:YES completion:nil];
}

#pragma mark Switcher

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

- (void)switcherInit{
    switcher = [DVSwitch switchWithStringsArray:@[@"求职设置", @"自我介绍", @"联系信息"]];
    switcher.frame = CGRectMake(0, 160,[[UIScreen mainScreen] bounds].size.width, 44);
    switcher.backgroundColor = [UIColor whiteColor];
    switcher.sliderColor = [UIColor colorWithRed:41.0/255.0 green:169.0/255.0 blue:220.0/255.0 alpha:1.0];
    switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    switcher.labelTextColorOutsideSlider = [UIColor blackColor];
    switcher.cornerRadius = 0;
    
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


#pragma mark Page1

//选择求职意向
- (void)chooseIntentionType{
    MLSelectJobTypeVC *selectVC=[MLSelectJobTypeVC sharedInstance];
    selectVC.selectDelegate=self;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:selectVC animated:YES];
}

- (void)finishSelect:(NSMutableArray*)typeArray{
    
    if([typeArray count]>0){
        
        intentionTypeArray=typeArray;
        
        NSString *typeString=[[NSString alloc]init];
        for (NSString *str in typeArray ) {
            typeString=[typeString stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
        }
        self.selectIntentionLabel.text=[NSString stringWithFormat:@"%@",typeString];
        self.userDetailModel.userJobIntention=[NSString stringWithFormat:@"%@",typeString];
    }
    else {
        self.selectIntentionLabel.text=@"点击选择";
        self.userDetailModel.userJobIntention=@"";
        [intentionTypeArray removeAllObjects];
    }
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


#pragma mark Page2

//选择自我简介模板
- (IBAction)selectIntroductionTemplate:(id)sender {
    MLTemplateVC* templateVC=[[MLTemplateVC alloc]init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:templateVC animated:YES];
    
}
//选择工作经验模板
- (IBAction)selectExperienceTemplate:(id)sender {
    NSLog(@"1");
}

//textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag==111) {
        if ([textView.text isEqualToString:@"点击填写自我简介，或点击右侧选择自我简介模板哦"]) {
            textView.text=@"";
        }
    }
    if (textView.tag==222) {
        if ([textView.text isEqualToString:@"点击填写工作经验，或点击右侧选择工作经验模板哦"]) {
            textView.text=@"";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag==111) {
        self.userDetailModel.userIntroduction=textView.text;
    }else if (textView.tag==222){
         self.userDetailModel.userWorkExperience=textView.text;
    }
}

#pragma mark Page3

- (IBAction)identify:(id)sender {
    MLStudentCard* stuVC=[[MLStudentCard alloc]init];
    stuVC.identifyDelegate=self;
    
    if (self.userDetailModel.userIdentifyFile) {
        stuVC.imageFile=self.userDetailModel.userIdentifyFile;
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:stuVC animated:YES];
}

- (void)finishIdentify:(NSString*)schoolNum imageUrl:(AVFile*)identifyFile{
    self.userDetailModel.userSchoolNumber=schoolNum;
    self.userDetailModel.userIdentifyFile=identifyFile;
    self.userDetailModel.userIdentifyFileURL=identifyFile.url;
}

- (IBAction)setInfoisShow:(id)sender {
    MLSelectInffShow *VC=[[MLSelectInffShow alloc]init];
    VC.type=[NSString stringWithFormat:@"%@",self.userDetailModel.userSecretType];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)chooseBirthday{
    if (self.userDetailModel.userBirthYear) {
        [datePickerView setBirthday:self.userDetailModel.userBirthYear];
    }else
        [datePickerView setBirthday:[NSDate date]];
    
    [self.view addSubview:coverView];
    [datePickerView showInView:self.view];
}

- (void)timePickerDidChangeStatus:(UIDatePicker *)picker{
    [coverView removeFromSuperview];
    self.userDetailModel.userBirthYear=picker.date;
    NSString *birthdayTemp = [DateUtil birthdayStringFromDate:picker.date];
    [self.birthDateLabel setText:birthdayTemp];
}

- (void)timePickerDidCancel{
    [coverView removeFromSuperview];
}

-(void)covervViewDidCancel{
    [coverView removeFromSuperview];
    [datePickerView cancelPicker];
}

- (void)finishSelectInfo:(int)type{
    self.userDetailModel.userSecretType=[NSNumber numberWithInt:type];
}

- (void)selectCityAction{
    
    [self.view addSubview:coverView];
    [self.locatePicker showInView:self.view];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
    self.userDetailModel.userProvince=picker.locate.state;
    self.userDetailModel.userCity=picker.locate.city;
    self.userDetailModel.userDistrict=picker.locate.district;
    NSString *addr=[NSString stringWithFormat:@"%@%@%@",picker.locate.state,picker.locate.city,picker.locate.district];
    self.districtLabel.text=addr;
    [coverView removeFromSuperview];
}

- (void)pickerCancel:(HZAreaPickerView *)picker{
    [picker cancelPicker];
    [coverView removeFromSuperview];
}

#pragma mark Photo

//图片滑动view
- (void)picScrollViewInit{
    addedPicArray=[[NSMutableArray alloc]init];
    imageButton *btnPic=[[imageButton alloc]initWithFrame:CGRectMake(INSETS, 0, PIC_WIDTH, PIC_HEIGHT)];
    [btnPic setBackgroundImage:[UIImage imageNamed:@"addCard"] forState:UIControlStateNormal];
    [addedPicArray addObject:btnPic];
    [self.picscrollview addSubview:btnPic];
    [btnPic addTarget:self action:@selector(addPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshScrollView];
}

- (IBAction)addPicAction:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"从图库选择",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:ALERTVIEW_CAMERAWRONG delegate:nil cancelButtonTitle:ALERTVIEW_KNOWN otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }
    }
    
    if (actionSheet.tag==1) {
        if (buttonIndex == 0) {

            do{
                if (didSelectedBTN == Nil) {
                    break;
                }
                
                NSInteger btnindex = [didSelectedBTN restorationIdentifier].integerValue;
                
                if (btnindex >= addedPicArray.count) {
                    break;
                }
                imageButton *btn = [addedPicArray objectAtIndex:btnindex];
                for (imageButton *tempbtn in addedPicArray) {
                    if ([tempbtn restorationIdentifier].intValue > btnindex) {
                        [tempbtn setRestorationIdentifier:[NSString stringWithFormat:@"%d",[tempbtn restorationIdentifier].intValue-1]];
                        
                        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
                        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x, tempbtn.center.y)]];
                        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x+INSETS+PIC_WIDTH, tempbtn.center.y)]];
                        [positionAnim setDelegate:self];
                        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                        [positionAnim setDuration:0.25f];
                        [tempbtn.layer addAnimation:positionAnim forKey:nil];
                        [tempbtn setCenter:CGPointMake(tempbtn.center.x+INSETS+PIC_WIDTH, tempbtn.center.y)];
                        continue;
                    }
                    if ([tempbtn restorationIdentifier].intValue == btnindex) {
                        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
                        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x, tempbtn.center.y)]];
                        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(INSETS+PIC_WIDTH/2, tempbtn.center.y)]];
                        [positionAnim setDelegate:self];
                        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                        [positionAnim setDuration:0.25f];
                        [tempbtn.layer addAnimation:positionAnim forKey:nil];
                        [tempbtn setCenter:CGPointMake(INSETS+PIC_WIDTH/2,tempbtn.center.y)];
                        continue;
                    }
                    
                    if ([tempbtn restorationIdentifier].intValue < btnindex) {
                        continue;
                    }
                }
                
                [addedPicArray removeObjectAtIndex:btnindex];
                [btn setRestorationIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)addedPicArray.count]];
                [addedPicArray addObject:btn];
                [self refreshScrollView];
                
                imageWithUrlObject *tempImage=[userImages objectAtIndex:btnindex-1];
                [userImages removeObjectAtIndex:btnindex-1];
                [userImages addObject:tempImage];
            }while (false);
        }
        
        if (buttonIndex == 1) {
            
            do{
                if (didSelectedBTN == Nil) {
                    break;
                }
                
                NSInteger btnindex = [didSelectedBTN restorationIdentifier].integerValue;
                
                if (btnindex >= addedPicArray.count) {
                    break;
                }
                imageButton *btn = [addedPicArray objectAtIndex:btnindex];
                [btn removeFromSuperview];
                for (imageButton *tempbtn in addedPicArray) {
                    if ([tempbtn restorationIdentifier].intValue > btnindex) {
                        [tempbtn setRestorationIdentifier:[NSString stringWithFormat:@"%d",[tempbtn restorationIdentifier].intValue-1]];
                        continue;
                    }
                    if ([tempbtn restorationIdentifier].intValue == btnindex) {
                        continue;
                    }
                    if ([tempbtn restorationIdentifier].intValue < btnindex) {
                        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
                        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x, tempbtn.center.y)]];
                        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)]];
                        [positionAnim setDelegate:self];
                        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                        [positionAnim setDuration:0.25f];
                        [tempbtn.layer addAnimation:positionAnim forKey:nil];
                        [tempbtn setCenter:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)];
                    }
                }
                [addedPicArray removeObjectAtIndex:btnindex];
                [userImages removeObjectAtIndex:btnindex-1];
                [self refreshScrollView];
                
            }while (false);
        }
        didSelectedBTN = Nil;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    if (actionSheet.tag==1) {
        didSelectedBTN = Nil;
    }
}

//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    UIImage *temp = image;
    if (image.size.height > PIC_HEIGHT*3 || image.size.width>PIC_WIDTH*3) {
        CGSize size = CGSizeMake(PIC_HEIGHT*3, PIC_WIDTH*3);
        temp = [self scaleToSize:image size:size];
    }
    picker = Nil;
    [self dismissModalViewControllerAnimated:YES];

    //添加图片
    imageWithUrlObject *imgUrlObj=[[imageWithUrlObject alloc]initWithImage:temp];
    [userImages addObject:imgUrlObj];
    
    imageButton *btnPic=[[imageButton alloc]initWithFrame:CGRectMake(-PIC_WIDTH, 0, PIC_WIDTH, PIC_HEIGHT)];
    btnPic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnPic.titleLabel.font = [UIFont systemFontOfSize:13];
    UIImage *darkTemp = [temp rt_darkenWithLevel:0.5f];
    [btnPic setBackgroundImage:darkTemp forState:UIControlStateNormal];
    [btnPic setFrame:CGRectMake(-PIC_WIDTH, 0, PIC_WIDTH, PIC_HEIGHT)];
    [addedPicArray addObject:btnPic];
    [btnPic setRestorationIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)addedPicArray.count-1]];
    [btnPic addTarget:self action:@selector(deletePicAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnPic setStatus:uplaoding];
    [self.picscrollview addSubview:btnPic];
    
    for (imageButton *btn in addedPicArray) {
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x, btn.center.y)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)]];
        [positionAnim setDelegate:self];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.25f];
        [btn.layer addAnimation:positionAnim forKey:nil];
            
        [btn setCenter:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)];
    }
    [self refreshScrollView];
        
        
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);

    AVFile *imageFile = [AVFile fileWithName:@"resumeImage" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            if (imageFile.url != Nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [btnPic setStatus:uploadOK];
                    [btnPic seturl:imageFile.url];
                    [btnPic setTitle:nil forState:UIControlStateNormal];
                    [btnPic setBackgroundImage:temp forState:UIControlStateNormal];
                    [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                    
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [btnPic setTitle:@"上传失败" forState:UIControlStateNormal];
                    [btnPic setBackgroundImage:temp forState:UIControlStateNormal];
                    [btnPic setStatus:uploaderror];
                    [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                });
            }

        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [btnPic setTitle:@"上传失败" forState:UIControlStateNormal];
                [btnPic setBackgroundImage:temp forState:UIControlStateNormal];
                [btnPic setStatus:uploaderror];
                [MBProgressHUD showError:UPLOADFAIL toView:self.view];
            });
        }
        
    } progressBlock:^(NSInteger percentDone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [btnPic setTitle:[NSString stringWithFormat:@"%ld％",(long)(percentDone)] forState:UIControlStateNormal];
        });
    }];

}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)deletePicAction:(imageButton *)sender{

    
    switch ([sender getStatus]) {
        case uploadOK:
            [self deletePicAction_uploadOKandfromNet:sender];
            break;
        case uplaoding:
            //[self deletePicAction_uplaoding];
            break;
        case uploaderror:
            //[self deletePicAction_uploaderror];
            break;
        case fromNet:
            [self deletePicAction_uploadOKandfromNet:sender];
            break;
        default:
            break;
    }
}

-(void)deletePicAction_uploadOKandfromNet:(imageButton *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"选为头像",@"删除",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 1;
    didSelectedBTN = sender;
    [actionSheet showInView:self.view];
    
}

- (void)refreshScrollView
{
    CGFloat width=(PIC_WIDTH+INSETS*2)+(addedPicArray.count-1)*(PIC_WIDTH+INSETS);
    CGSize contentSize=CGSizeMake(width, 0);
    [self.picscrollview setContentSize:contentSize];
    [self.picscrollview setContentOffset:CGPointMake(width<self.picscrollview.frame.size.width?0:width-self.picscrollview.frame.size.width, 0) animated:YES];
}

- (void)locate{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    //获得用户位置信息
    [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [mySettingData setObject:NSStringFromCGPoint(CGPointMake(locationCorrrdinate.longitude, locationCorrrdinate.latitude)) forKey:@"currentCoordinate"];
        [mySettingData synchronize];
        
    } error:^(NSError *error) {
        
        
    }];
}

- (void)initData{
    if (self.userDetailModel!=Nil) {
        if ([self.userDetailModel.userImageArray count]>0) {

            NSArray *reverceTemp = [[self.userDetailModel.userImageArray reverseObjectEnumerator] allObjects];
            NSMutableArray *reverceTempMutable = [[NSMutableArray alloc]initWithArray:reverceTemp];
            for (NSString *url in reverceTempMutable) {
                //添加图片
                imageButton *btnPic=[[imageButton alloc]initWithFrame:CGRectMake(-PIC_WIDTH, 0, PIC_WIDTH, PIC_HEIGHT)];
                btnPic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                btnPic.titleLabel.font = [UIFont systemFontOfSize:13];
                CGSize size = CGSizeMake(PIC_HEIGHT, PIC_HEIGHT);
                UIImage *temp = [self scaleToSize:[UIImage imageNamed:@"placeholder"] size:size];
                [btnPic setBackgroundImage:temp forState:UIControlStateNormal];
                [btnPic setFrame:CGRectMake(-PIC_WIDTH, 0, PIC_WIDTH, PIC_HEIGHT)];
                [addedPicArray addObject:btnPic];
                [btnPic setRestorationIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)addedPicArray.count-1]];
                [btnPic addTarget:self action:@selector(deletePicAction:) forControlEvents:UIControlEventTouchUpInside];
                [btnPic setStatus:fromNet];
                [btnPic seturl:url];
                [btnPic loadImageWithURL:url];
                
                imageWithUrlObject *imgUrlObj=[[imageWithUrlObject alloc]initWithUrl:url];
                [userImages addObject:imgUrlObj];

                [self.picscrollview addSubview:btnPic];
                
                for (imageButton *btn in addedPicArray) {
                    CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
                    [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x, btn.center.y)]];
                    [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)]];
                    [positionAnim setDelegate:self];
                    [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                    [positionAnim setDuration:0.25f];
                    [btn.layer addAnimation:positionAnim forKey:nil];
                    
                    [btn setCenter:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)];
                }
                [self refreshScrollView];
            }
        }
        
        if ([self.userDetailModel.userJobIntention length]>0) {
            self.selectIntentionLabel.text=self.userDetailModel.userJobIntention;
        }
        if ([self.userDetailModel.userIdleTime length]>0) {
            NSArray *freeTime;
            if ([self.userDetailModel.userIdleTime length]>0) {
                freeTime =[self.userDetailModel.userIdleTime componentsSeparatedByString:@","];
            }
            
            for (NSString *free in freeTime) {
                if (free.intValue >=0 && free.intValue <=21) {
                    selectFreeData[free.intValue] = true;
                }
            }
            
            [self.selectfreeCollectionOutlet reloadData];
        }
        if ([self.userDetailModel.userIntroduction length]>0) {
            self.introductionTextView.text=self.userDetailModel.userIntroduction;
        }
        if ([self.userDetailModel.userWorkExperience length]>0) {
            self.experienceTextView.text=self.userDetailModel.userWorkExperience;
        }
        if ([self.userDetailModel.userRealName length]>0) {
            self.nameLabel.text=self.userDetailModel.userRealName;
        }
        if ([self.userDetailModel.userGender isEqualToString:@"女"]) {
            [_radio2 setChecked:YES];
        }
        if ([self.userDetailModel.userHeight length]>0) {
            self.heightLabel.text=self.userDetailModel.userHeight;
        }
        if (self.userDetailModel.userBirthYear) {
            self.birthDateLabel.text=[DateUtil stringFromDate:self.userDetailModel.userBirthYear];
        }
        if (self.userDetailModel.userProvince||self.userDetailModel.userCity||self.userDetailModel.userDistrict) {
            self.districtLabel.text=[NSString stringWithFormat:@"%@%@%@",self.userDetailModel.userProvince,self.userDetailModel.userCity,self.userDetailModel.userDistrict];
        }
        if ([self.userDetailModel.userSchool length]>0) {
            self.schoolLabel.text=self.userDetailModel.userSchool;
        }
        if ([self.userDetailModel.userProfesssion length]>0) {
            self.majorLabel.text=self.userDetailModel.userProfesssion;
        }
        if ([self.userDetailModel.userEmail length]>0) {
            self.emailLabel.text=self.userDetailModel.userEmail;
        }
        if ([self.userDetailModel.userQQ length]>0) {
            self.qqNumberLabel.text=self.userDetailModel.userQQ;
        }
        if ([self.userDetailModel.userMobile length]>0) {
            self.phoneNumberLabel.text=self.userDetailModel.userMobile;
        }

    }
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
