//
//  FliterTableViewController.m
//  ejianzhi
//
//  Created by Mac on 4/21/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "FliterTableViewController.h"

@interface FliterTableViewController ()



@end

@implementation FliterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectedAction)];
    self.navigationItem.backBarButtonItem.title=@"返回";
    //初始化
    self.row=-1;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [RACObserve(self, datasource) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.datasource!=nil) {
        return [self.datasource count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"flitercell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text=[self.datasource objectAtIndex:indexPath.row];
    if (self.row!=-1 && self.row==indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    if (self.row!=-1){
        if (indexPath.row!=self.row) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.row inSection:0];
            //就值设为none
            UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexpath];
            cellView.accessoryType=UITableViewCellAccessoryNone;
            
            //新值设为check
            UITableViewCell *cellView1 = [tableView cellForRowAtIndexPath:indexPath];
            cellView1.accessoryType=UITableViewCellAccessoryCheckmark;
            self.row=indexPath.row;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else{
        UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
        if (cellView.accessoryType == UITableViewCellAccessoryNone) {
            cellView.accessoryType=UITableViewCellAccessoryCheckmark;
            self.row=indexPath.row;
        }
    }
}

-(void)selectedAction
{
    if(self.row!=-1)
    {
        NSString *currentselect=[self.datasource objectAtIndex:self.row];
        [self.delegate selectedResults:currentselect ViewType:self.viewType];
        //返回后设置-1;
        self.row=-1;
        [self.navigationController popViewControllerAnimated:YES];
    }
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
