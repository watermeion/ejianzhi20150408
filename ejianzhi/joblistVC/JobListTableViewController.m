//
//  JobListTableViewController.m
//  EJianZhi
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "JobListTableViewController.h"
#import "MLJianZhiViewModel.h"
#import "JobListTableViewCell.h"
#import "JianZhi.h"
#import "JobDetailVC.h"
#import "MJRefresh.h"

@interface JobListTableViewController ()


@end

@implementation JobListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.viewModel=[[MLJianZhiViewModel alloc]init];
    
    
    @weakify(self)
    [RACObserve(self.viewModel, resultsList) subscribeNext:^(NSArray *x) {
        @strongify(self)
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    }];
    
    
    [RACObserve(self.viewModel, error) subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        //提示错误 交给self.viewModel 完成
    }];
    
    [self tableViewInit];
}

- (void)tableViewInit{

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled=YES;
//    [_tableHeadView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 284+130*[[UIScreen mainScreen] bounds].size.width/320)];
//    [self.tableView setTableHeaderView:_tableHeadView];
    //为tableView 添加下拉刷新
//    [self.tableView addFooterWithTarget:self.viewModel action:@selector(footerRefresh)];
}


- (void)addFooterRefresher
{
   [self.tableView addFooterWithTarget:self.viewModel action:@selector(footerRefresh)];
}

- (void)addHeaderRefresher
{
  [self.tableView addFooterWithTarget:self.viewModel action:@selector(headerRefresh)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (self.viewModel.resultsList!=nil) {
        return self.viewModel.resultsList.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"JobListTableViewCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"JobListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    JobListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    //设置兼职信息列表内容
    
    JianZhi *jianzhi=[self.viewModel.resultsList objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=jianzhi.jianZhiTitle;
    cell.categoryLabel.text=jianzhi.jianZhiType;
    cell.priceLabel.text=[jianzhi.jianZhiWage stringValue];
    cell.payPeriodLabel.text=[NSString stringWithFormat:@"/%@",jianzhi.jianZhiWageType];
    cell.keyConditionLabel.text=jianzhi.jianzhiTeShuYaoQiu;
    
    cell.countNumbersWithinUnitsLabel.text=[NSString stringWithFormat:@"%d/%d人",[jianzhi.jianZhiQiYeLuYongValue intValue],[jianzhi.jianZhiRecruitment intValue]];
    //待完善
    cell.distanceLabelWithinUnitLabel.text=[NSString stringWithFormat:@"%@km",@"10"];
    cell.IconView.badgeText=jianzhi.jianZhiKaoPuDu;
    //兼职的IconView
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobDetailVC *detailVC=[[JobDetailVC alloc]initWithData:[self.viewModel.resultsList objectAtIndex:indexPath.row]];
    detailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSArray*)getViewModelResultsList
{
    return self.viewModel.resultsList;
}

@end
