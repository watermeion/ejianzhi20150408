//
//  MLCustomjobListViewController.m
//  EJianZhi
//
//  Created by Mac on 2/5/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//


//自定义可展开TableCell

#import "MLCustomjobListViewController.h"
#import "JobListTableViewCell.h"
#import "ButtonCellTableViewCell.h"
//#import "JobDetailVC.h"




@interface MLCustomjobListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger cellNum;
    NSMutableDictionary *dict;//存对应的数据
    NSMutableArray *controllStateArray;//二级列表是否展开
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)UISegmentedControl *segmentedControl;
@end

@implementation MLCustomjobListViewController


-(UISegmentedControl*)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl=[[UISegmentedControl alloc]initWithItems:@[@"申请中",@"已录用"]];
    }
    return _segmentedControl;
}



-(void)segmentControlInit
{
    self.segmentedControl.tintColor=[UIColor whiteColor];
    self.navigationItem.titleView=self.segmentedControl;
    //默认选中企业列表
    self.segmentedControl.selectedSegmentIndex=0;
    [self.segmentedControl addTarget:self
                              action:@selector(segementedChange)
                    forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationController.navigationBar.hidden=NO;
    [self segmentControlInit];
    [self tableViewInit];
}

#pragma --mark  segementedChange 事件
-(void)segementedChange
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"selected:%d",0);
            
            break;
        case 1:
            
            NSLog(@"selected:%d",1);
            break;
            
            
        default:
            break;
    }
    
}


-(void)tableViewInit
{
    cellNum=10;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self initDataSource];
}


-(void)initDataSource
{
    controllStateArray=[NSMutableArray array];
    NSDictionary *nomarlDict=@{@"Cellidentifier":@"JobListTableViewCell",@"state":@"NO"};
    
    
    for (int i=0; i<cellNum; i++) {
        //0是未选中,1是选中
        
        [controllStateArray addObject:nomarlDict];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma --mark  tableView  Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [controllStateArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 90;
    
    if ([[[controllStateArray objectAtIndex:indexPath.row] objectForKey:@"Cellidentifier"] isEqualToString:@"ButtonCellTableViewCell"])
    {
        return 44;
    }
    else return 90;
    
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[controllStateArray objectAtIndex:indexPath.row]objectForKey:@"Cellidentifier"]isEqualToString:@"JobListTableViewCell"]) {
        
        BOOL nibsRegistered = NO;
        static NSString *Cellidentifier=@"JobListTableViewCell";
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"JobListTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        }
        
        JobListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
        return cell;
    }
    else if([[[controllStateArray objectAtIndex:indexPath.row]objectForKey:@"Cellidentifier"]isEqualToString:@"ButtonCellTableViewCell"])
    {
        BOOL nibsRegistered = NO;
        static NSString *Cellidentifier=@"ButtonCellTableViewCell";
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"ButtonCellTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        }
        
        ButtonCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
        return cell;
        
        
        
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    
    if ([[[controllStateArray objectAtIndex:indexPath.row]objectForKey:@"Cellidentifier"]isEqualToString:@"JobListTableViewCell"]) {
        //当Cellidentifier 为JobListTable 时 新加cell path=indexPath+1;
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
        NSLog(@"1path.row:%ld",(long)path.row);
    }else
    {
        //当Cellidentifier 为ButtonCellTableViewCell 时 path=indexPath
        path=indexPath;
        NSLog(@"2path.row:%ld",(long)path.row);
    }
    //判断打开状态
    if ([[[controllStateArray objectAtIndex:indexPath.row]objectForKey:@"state"]isEqualToString:@"NO"]) {
        //打开附加cell
        //将原来的cell 的状态设置为 state:YES
        NSDictionary *orginDict=@{@"Cellidentifier":@"JobListTableViewCell",@"state":@"YES"};
        //增加的新的附加cell的控制数据
        NSDictionary *yesDict1=@{@"Cellidentifier":@"ButtonCellTableViewCell",@"state":@"YES"};
        controllStateArray[path.row-1]=orginDict;
        [controllStateArray insertObject:yesDict1 atIndex:path.row];
        
        //刷新tableView
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [_tableView endUpdates];
        [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
        
    }else if([[[controllStateArray objectAtIndex:indexPath.row]objectForKey:@"state"]isEqualToString:@"YES"])
    {
        //关闭附件cell
        ////将原来的cell 的状态设置为 state:NO
        NSDictionary *noDict=@{@"Cellidentifier":@"JobListTableViewCell",@"state":@"NO"};
        controllStateArray[path.row-1]=noDict;
        [controllStateArray removeObjectAtIndex:path.row];
        
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
        [_tableView endUpdates];
        [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    }
    
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
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
