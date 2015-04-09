//
//  MLJobListViewController.m
//  EJianZhi
//
//  Created by Mac on 1/30/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "MLJobListViewController.h"
#import "JobListTableViewCell.h"
#import "JobDetailVC.h"
@interface MLJobListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger cellNum;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MLJobListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self tableViewInit];
    self.edgesForExtendedLayout=UIRectEdgeNone;
}


-(void)tableViewInit
{
    cellNum=10;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;

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

#pragma --mark  tableView  Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNum;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"JobListTableViewCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"JobListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    JobListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobDetailVC *detailVC=[[JobDetailVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    
    
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}



@end
