//
//  SearchViewController.m
//  ejianzhi
//
//  Created by Mac on 4/23/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//


#define resultsTableTag 99999


#import "SearchViewController.h"
#import "JobListTableViewCell.h"
#import "JobListTableViewController.h"
#import "JianZhi.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic)JobListTableViewController *tableListController;
@property (strong,nonatomic)UITableView *searchHistoryTableView;
@property (strong,nonatomic)NSMutableArray *searchHistoryWordsArray;

//@property (strong,nonatomic)NSArray* searchResultsArray;

//@property (strong,nonatomic)UITableView* resultsTableView;

@end

@implementation SearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"搜索";
    _tableListController=[[JobListTableViewController alloc]initWithAutoLoad:NO];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.titleView=self.searchBar;
    self.searchBar.delegate=self;
    //    self.tableList=[[JobListTableViewController alloc]initWithAutoLoad:NO];
    //    self.tableList.tableView.dataSource=self;
    self.searchHistoryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-64) style:UITableViewStylePlain];
    
    self.searchHistoryTableView.delegate=self;
    self.searchHistoryTableView.dataSource=self;
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 20, 50)];
    headerLabel.text=@"历史搜索记录";
    
    self.searchHistoryTableView.tableHeaderView=headerLabel;
    headerLabel.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.searchHistoryTableView];
    //设置搜索历史
    
    self.searchHistoryWordsArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryArray"]];
    if (self.searchHistoryWordsArray==nil) self.searchHistoryWordsArray=[NSMutableArray array];
//    self.resultsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-64) style:UITableViewStylePlain];
//    self.resultsTableView.delegate=self;
//    self.resultsTableView.dataSource=self;
//    self.resultsTableView.tag=resultsTableTag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    [mysettings setObject:self.searchHistoryWordsArray forKey:@"searchHistoryArray"];
    [mysettings synchronize];
    self.searchHistoryWordsArray=nil;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma --mark SearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}                    // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
}                           // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}                             // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    
}                            // called when text ends editing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
}         // called when text changes (including clear)
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}       // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //FIXME：执行搜索
    NSLog(@"搜索内容：%@",searchBar.text);
    //记录搜索历史数据，不超过10条
    if(![self.searchHistoryWordsArray containsObject:searchBar.text]){
    if(self.searchHistoryWordsArray.count>10) [self.searchHistoryWordsArray removeLastObject];
//    NSString *searchtext=[searchBar.text copy];
    [self.searchHistoryWordsArray insertObject:searchBar.text atIndex:0];
    [self.searchHistoryTableView reloadData];
    }
    [self AVquery:searchBar.text];
    
}
// called when keyboard search button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //终止搜索
    
}

-(void)dealloc
{
    //对象销毁前 写入数据
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    [mysettings setObject:self.searchHistoryWordsArray forKey:@"searchHistoryArray"];
    [mysettings synchronize];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.searchHistoryWordsArray!=nil) {
        return self.searchHistoryWordsArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (tableView.tag==resultsTableTag) {
//
//    }
//    else
//    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell123"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell123"];
        }
        cell.textLabel.text=[self.searchHistoryWordsArray objectAtIndex:indexPath.row];
        return cell;
//    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchBar.text=[self.searchHistoryWordsArray objectAtIndex:indexPath.row];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:1.0f];
}

- (void)deselect
{
    [self.searchHistoryTableView deselectRowAtIndexPath:[self.searchHistoryTableView indexPathForSelectedRow] animated:YES];
}


#pragma --mark 应用内搜索

-(void)AVquery:(NSString*)searchText
{
    //执行搜索
    AVSearchQuery *searchQuery = [AVSearchQuery searchWithQueryString:searchText];
    searchQuery.className = @"JianZhi";
    //    searchQuery.highlights = @"field1,field2";
    searchQuery.limit = 10;
    searchQuery.cachePolicy = kAVCachePolicyCacheElseNetwork;
    searchQuery.maxCacheAge = 60;
    //    searchQuery.fields = @[@"field1", @"field2"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [searchQuery findInBackground:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error==nil) {
            NSArray *array=[NSArray array];
            for (AVObject *object in objects) {
                NSString *appUrl = [object objectForKey:@"_app_url"];
                NSString *deeplink = [object objectForKey:@"_deeplink"];
                NSString *hightlight = [object objectForKey:@"_highlight"];
                // other fields
                // code is here
                
                array=[array arrayByAddingObject:object];
            }
            if(array.count!=0)
            {
                self.tableListController.resultsArray=array;
                [self.navigationController pushViewController:self.tableListController animated:YES];
//                [self.tableListController.tableView reloadData];
            }else
            {
                [MBProgressHUD showError:@"没有你要找的信息" toView:nil];
                
            }
            
        }else
        {
            
            NSString *errorString=[NSString stringWithFormat:@"出错啦:%@",error.description];
            [MBProgressHUD showError:errorString toView:nil];
            
        }
    }];
}



@end
