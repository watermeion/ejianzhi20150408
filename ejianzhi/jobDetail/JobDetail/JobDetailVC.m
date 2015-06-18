//
//  JobDetailVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/30.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//
#define CollectionViewMiniLineSpace 3.0f
#define CollectionViewMiniInterItemsSpace 3.0f
#define CollectionViewItemsWidth ((MainScreenWidth-(7*CollectionViewMiniInterItemsSpace))/7)
#import "JobDetailVC.h"
#import "freeselectViewCell.h"

#import "FVCustomAlertView.h"
#import "MapViewController.h"
//#import "ASDepthModalViewController.h"
#import "MLJobDetailViewModel.h"
#import "SRMapViewVC.h"
#import "tousuViewController.h"
#import "CompanyInfoViewController.h"
#import "resumeListVC.h"
#import "CDService.h"
#import "CDUserFactory.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
static NSString *selectFreecellIdentifier = @"freeselectViewCell";


@interface JobDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
}
@property (strong,nonatomic) MLJobDetailViewModel *viewModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobTeShuYaoQiuHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;

- (IBAction)showInMapAction:(id)sender;

//popUpView
@property (strong, nonatomic) IBOutlet UIView *popUpView;
- (IBAction)callAction:(id)sender;
- (IBAction)messageAction:(id)sender;



@property (weak, nonatomic) IBOutlet UILabel *popUpViewPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *popUpViewNameLabel;

//绑定内容展示表现层

@property (weak, nonatomic) IBOutlet UILabel *jobDetailTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jobDetailJobWageTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailJobWagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailJobWageTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jobDetailJobSubFlagImage;

@property (weak, nonatomic) IBOutlet UILabel *jobDetailJobRequiredNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *jobDetailJobFlagImage;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailTeShuYaoQiuLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobDetailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailAddressNaviLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailJobQiYeLabel;
@property (weak, nonatomic) IBOutlet UIButton *jobDetailMoreJobBtn;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailJobXiangQingLabel;

@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UILabel *chatLabel;



//另外获取的数据

@property (weak, nonatomic) IBOutlet UILabel *jobDetailJobEvaluationLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailJobComments;
@property (weak, nonatomic) IBOutlet UILabel *jobDetailWarnningLabel;
@property (weak, nonatomic) IBOutlet UIButton *jobDetailModifyWorkTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *jobDetailComplainBtn;

@property (weak, nonatomic) IBOutlet UIButton *jobDetailAddFavioritesBtn;

@property (weak, nonatomic) IBOutlet UIButton *jobDetailApplyBtn;

@property (weak,nonatomic)id thisCompanyId;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint1;

@property (strong,nonatomic)UIBarButtonItem *addFaviatorBtnItem;

@property (strong, nonatomic) IBOutlet UILabel *label11;
@property (strong, nonatomic) IBOutlet UILabel *label12;

@property (strong, nonatomic) IBOutlet UIView *view13;
@property (strong, nonatomic) IBOutlet UILabel *label14;
@property (strong, nonatomic) IBOutlet UIImageView *view15;
@property (strong, nonatomic) IBOutlet UIImageView *view16;

@end

@implementation JobDetailVC

/**
 *  init方法
 *
 *  @param data 给viewModel 传递的model信息
 *
 *  @return instancetype
 */
- (instancetype)initWithData:(id)data
{
    self=[super init];
    if (self==nil) return nil;
    [self setViewModelJianZhi:data];
    return self;
}


/**
 *  设置兼职数据
 *
 *  @param data <#data description#>
 */
- (void)setViewModelJianZhi:(id)data
{
    if ([data isKindOfClass:[JianZhi class]]) {
        JianZhi *jianzhi=data;
        //加入浏览量统计
        self.viewModel=[[MLJobDetailViewModel alloc]initWithData:data];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self timeCollectionViewInit];
    self.title=@"详情";
    self.tabBarController.tabBar.hidden=YES;
    //init rightBarButton
    if (self.viewModel==nil) {
        self.viewModel=[[MLJobDetailViewModel alloc]init];
    }
    
    if (!self.fromEnterprise) {
        UIBarButtonItem *rightBarItem1=[[UIBarButtonItem alloc]initWithTitle:@"投诉" style:UIBarButtonItemStylePlain target:self action:@selector(makeComplainAction)];
        self.addFaviatorBtnItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"hollowheart25-25"] style:UIBarButtonItemStylePlain target:self.viewModel action:@selector(addFavirateAction)];
        self.addFaviatorBtnItem.tintColor=[UIColor redColor];
        
        NSArray *barItems=@[rightBarItem1,self.addFaviatorBtnItem];
        
        self.navigationItem.rightBarButtonItems=barItems;

    }
    
    if (self.fromEnterprise) {
        
        self.btn1.hidden=YES;
        self.btn2.hidden=YES;
        self.btn3.hidden=YES;
        self.navigationItem.rightBarButtonItem=nil;
        self.scrollConstraint.constant=-44;
        
        if (self.isPreview) {
            UIBarButtonItem *rightBarItem=[[UIBarButtonItem alloc]initWithTitle:@"确认发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
            self.navigationItem.rightBarButtonItem=rightBarItem;
            
            UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pushBack)];
            self.navigationItem.rightBarButtonItem=rightBarItem;
            self.navigationItem.leftBarButtonItem=leftBarItem;

        }else{
            UIBarButtonItem *rightBarItem=[[UIBarButtonItem alloc]initWithTitle:@"再次发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAgain)];
            self.navigationItem.rightBarButtonItem=rightBarItem;
        }
        
    }else{
        CDIM* im=[CDIM sharedInstance];
        im.userDelegate=[CDIMService shareInstance];
        [im openWithClientId:[AVUser currentUser].objectId callback:^(BOOL succeeded, NSError *error) {
            if(error){
                self.chatBtn.hidden=YES;
                self.chatLabel.hidden=YES;
            }
        }];
        
    }
    
    //创建监听
    @weakify(self)
    [RACObserve(self.viewModel,worktime) subscribeNext:^(id x) {
        @strongify(self)
        NSArray *workTimeArray=self.viewModel.worktime;
        //默认空数据true,所以先刷新数据为false
        for (int j = 0; j<21; j++) {
            selectFreeData[j]=false;
        }
        for (int i = 0; i < [workTimeArray count]; i++) {
            NSLog(@"string:%@", [workTimeArray objectAtIndex:i]);
            int num=[[workTimeArray objectAtIndex:i] intValue];
            if (num>0 && num <21) selectFreeData[num]=true;
            
        }
        [self.selectfreeCollectionOutlet reloadData];
    }];
    [RACObserve(self.viewModel, isFavorite) subscribeNext:^(NSNumber *x) {
        if ([x boolValue]) {
            self.addFaviatorBtnItem.image=[UIImage imageNamed:@"solidheart25-25"];
        }else
        {
            self.addFaviatorBtnItem.image=[UIImage imageNamed:@"hollowheart25-25"];
        }
    }];
    
    RAC(self.jobDetailTitleLabel,text)=RACObserve(self.viewModel, jobTitle);
    RAC(self.jobDetailJobWagesLabel,text)=RACObserve(self.viewModel, jobWages);
    RAC(self.jobDetailJobWageTypeLabel,text)=RACObserve(self.viewModel, jobWagesType);
    RAC(self.jobDetailJobQiYeLabel,text)=RACObserve(self.viewModel, jobQiYeName);
    RAC(self.jobDetailAddressLabel,text)=RACObserve(self.viewModel, jobAddress);
    RAC(self.jobDetailAddressNaviLabel,text)=RACObserve(self.viewModel, jobAddressNavi);
    RAC(self.jobDetailJobEvaluationLabel,text)=RACObserve(self.viewModel, jobEvaluation);
    RAC(self.popUpViewNameLabel,text)=RACObserve(self.viewModel, jobContactName);
    RAC(self.popUpViewPhoneLabel,text)=RACObserve(self.viewModel, jobPhone);
    RAC(self.jobDetailJobComments,text)=RACObserve(self.viewModel, jobCommentsText);
    RAC(self.jobDetailTeShuYaoQiuLabel,text)=RACObserve(self.viewModel, jobTeShuYaoQiu);
    RAC(self.jobDetailJobRequiredNumLabel,text)=RACObserve(self.viewModel, jobRequiredNum);
    RAC(self.jobDetailJobXiangQingLabel,text)=RACObserve(self.viewModel,jobXiangQing);
#warning 色块变化监听
    RAC(self.jobDetailJobFlagImage,image)=RACObserve(self.viewModel, typeImage);
    RAC(self,thisCompanyId)=RACObserve(self.viewModel, companyId);
#warning 绑定按钮事件
    self.jobDetailApplyBtn.rac_command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [self.viewModel applyThisJob];
        return [RACSignal empty];
    }];
    
    self.jobDetailComplainBtn.rac_command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        [self makeContactAction];
        return [RACSignal empty];
    }];
    
    self.jobDetailAddFavioritesBtn.rac_command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        [self.viewModel addFavirateAction];
        return [RACSignal empty];
    }];
    self.jobDetailMoreJobBtn.rac_command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        if (self.fromEnterprise) {
            resumeListVC *resumeVC=[[resumeListVC alloc]init];
            resumeVC.jobObject=self.viewModel.jianZhi;
            
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"";
            self.navigationItem.backBarButtonItem = backItem;
            
            resumeVC.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:resumeVC animated:YES];
            
        }else{
            if (self.thisCompanyId!=nil) {
                CompanyInfoViewController *companyInfoVC=[[CompanyInfoViewController alloc]initWithData:self.thisCompanyId];
                companyInfoVC.hidesBottomBarWhenPushed=YES;
                companyInfoVC.edgesForExtendedLayout=UIRectEdgeNone;
                [self.navigationController pushViewController:companyInfoVC animated:YES];
            }
            else
            {
                TTAlert(@"sorry,该公司的HR什么都没留下~！详情请电话咨询");
                
            }
            
        }
        return [RACSignal empty];
    }];
    
    if (self.isPreview) {
        self.constraint1.constant=-121;
        self.label11.hidden=YES;
        self.label12.hidden=YES;
        
        self.view13.hidden=YES;
        self.label14.hidden=YES;
        self.view15.hidden=YES;
        self.view16.hidden=YES;
    }
    
    if (!self.fromEnterprise) {
        [self.viewModel.jianZhi incrementKey:@"jianZhiBrowseTime"];
        [self.viewModel.jianZhi saveInBackground];
    }
}


- (void)makeComplainAction
{
    tousuViewController *tousuVC=[[tousuViewController alloc]init];
    tousuVC.delegate=self.viewModel;
    
    [self.navigationController pushViewController:tousuVC animated:YES];
    
}

/**
 *  修改视图大小
 */
- (void)viewWillLayoutSubviews
{
    [self updateConstraintsforJobContentLabelWithString:self.jobDetailJobXiangQingLabel.text];
    [self updateConstraintsforJobTeShuYaoQiuLabelWithString:self.jobDetailTeShuYaoQiuLabel.text];
    
}


-(void)updateConstraintsforJobTeShuYaoQiuLabelWithString:(NSString*)str
{
    if (str==nil) return;
    self.jobDetailTeShuYaoQiuLabel.text=str;
    float stringHeight=[self heightForString:str fontSize:14 andWidth:([[UIScreen mainScreen] bounds].size.width-16)];
    self.jobTeShuYaoQiuHeightConstraint.constant=stringHeight;
    
    self.containerViewConstraint.constant=self.containerViewConstraint.constant+stringHeight;
}

- (void)updateConstraintsforJobContentLabelWithString:(NSString*) str{
    
    if (str==nil) return;
    self.jobDetailJobXiangQingLabel.text=str;
    float stringHeight=[self heightForString:str fontSize:14 andWidth:([[UIScreen mainScreen] bounds].size.width-16)];
    self.jobContentViewHeightConstraint.constant=stringHeight;
    
    self.containerViewConstraint.constant=608+stringHeight;
}


- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}


- (void)timeCollectionViewInit{
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = CollectionViewItemsWidth;
    
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
        selectFreeData[index] = TRUE;
    }
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
}

#pragma mark - Collection View Data Source
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
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
    //[[cell imageView]setFrame:CGRectMake(0, 0, freecellwidth, freecellwidth)];
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


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return CollectionViewMiniLineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return CollectionViewMiniInterItemsSpace;
    
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

-(void)makeContactAction
{
    //添加联系
    //FIXME:换控件
    self.popUpView.layer.cornerRadius=2;
    self.popUpView.autoresizingMask=UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    //    self.popUpView.frame=CGRectMake(0, 0, (300/320)*MainScreenWidth, (280/468)*MainScreenHeight);
    self.popUpView.frame=CGRectMake(0, 0, 300,280);
    [FVCustomAlertView showAlertOnView:self.view withTitle:nil titleColor:[UIColor whiteColor] width:self.popUpView.frame.size.width height:self.popUpView.frame.size.height backgroundImage:nil backgroundColor:[UIColor whiteColor] cornerRadius:4 shadowAlpha:0.5 alpha:1.0 contentView:self.popUpView type:FVAlertTypeCustom];
}

- (IBAction)callAction:(id)sender {
    //打电话
    
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@",self.viewModel.jobPhone];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]]; //拨号
}

- (IBAction)messageAction:(id)sender {
    //发短信
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"sms://%@",self.viewModel.jobPhone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
}


- (IBAction)showInMapAction:(id)sender {
    
    if (self.viewModel.jianZhi.jianZhiPoint) {
        SRMapViewVC *mapVC=[[SRMapViewVC alloc]init];
        mapVC.sellerCoord=CLLocationCoordinate2DMake(self.viewModel.jianZhi.jianZhiPoint.latitude, self.viewModel.jianZhi.jianZhiPoint.longitude);
        mapVC.sellerTitle=self.jobDetailTitleLabel.text;
        
        [self.navigationController pushViewController:mapVC animated:YES];
    }else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"对不起，该用户暂未提供位置信息" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil,nil];
        [alert show];
    }
    //    [self.viewModel presentShowJobInMapInterfaceFromViewController:self];
}


- (IBAction)showResume:(id)sender {
    
}

- (IBAction)chatWithEnterprise:(id)sender {
    
    if (self.viewModel.companyInfo!=nil) {
        
        if([self.viewModel.companyInfo objectForKey:@"qiYeUser"]){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            AVObject *userQuery=[self.viewModel.companyInfo objectForKey:@"qiYeUser"];
            [userQuery fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (!error) {
                    AVUser *_user=object;
                    [CDCache registerUser:_user];
                    
                    CDIM* im=[CDIM sharedInstance];
                    WEAKSELF
                    [im fetchConvWithUserId:_user.objectId callback:^(AVIMConversation *conversation, NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if(error){
                            DLog(@"%@",error);
                        }else{
                            CDChatRoomVC* chatRoomVC=[[CDChatRoomVC alloc] initWithConv:conversation];
                            chatRoomVC.hidesBottomBarWhenPushed=YES;
                            [weakSelf.navigationController pushViewController:chatRoomVC animated:YES];
                        }
                    }];
                }
                
            }];
        }
    }
}

- (void)publish{
    
    AVObject *jianzhiObject=[AVObject objectWithClassName:@"JianZhi"];;
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeLuYongValue forKey:@"jianZhiQiYeLuYongValue"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContent forKey:@"jianZhiContent"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiAddress forKey:@"jianZhiAddress"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiRecruitment forKey:@"jianZhiRecruitment"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiTimeEnd forKey:@"jianZhiTimeEnd"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiWorkTime forKey:@"jianZhiWorkTime"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiKaoPuDu forKey:@"jianZhiKaoPuDu"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiDistrict forKey:@"jianZhiDistrict"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiBrowseTime forKey:@"jianZhiBrowseTime"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiCity forKey:@"jianZhiCity"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiTimeStart forKey:@"jianZhiTimeStart"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContactPhone forKey:@"jianZhiContactPhone"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiRequirement forKey:@"jianZhiRequirement"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiProvince forKey:@"jianZhiProvince"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeManYiDu forKey:@"jianZhiQiYeManYiDu"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiWageType forKey:@"jianZhiWageType"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContactName forKey:@"jianZhiContactName"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiWage forKey:@"jianZhiWage"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianzhiTeShuYaoQiu forKey:@"jianzhiTeShuYaoQiu"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeName forKey:@"jianZhiQiYeName"];

    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeResumeValue forKey:@"jianZhiQiYeResumeValue"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiType forKey:@"jianZhiType"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiPoint forKey:@"jianZhiPoint"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiLuYongValue forKey:@"jianZhiLuYongValue"];

    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiTitle forKey:@"jianZhiTitle"];

    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContactEmail forKey:@"jianZhiContactEmail"];

    [jianzhiObject setObject:self.viewModel.jianZhi.qiYeInfoId forKey:@"qiYeInfoId"];
    
    //AVUser *user=[AVUser currentUser];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYe forKey:@"jianZhiQiYe"];
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [jianzhiObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (succeeded) {
            [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
            [self performSelector:@selector(returnAndSave) withObject:nil afterDelay:1.0f];
        }else{
            [MBProgressHUD showSuccess:@"保存失败" toView:self.view];
        }
    }];
}

- (void)pushBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)returnAndSave{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.saveDelegate finishSave];
}

- (void)publishAgain{
    
}


@end
