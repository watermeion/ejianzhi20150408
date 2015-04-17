//
//  MLApplicationList.m
//  ejianzhi
//
//  Created by RAY on 15/4/16.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "MLApplicationList.h"
#import "DVSwitch.h"

@interface MLApplicationList ()
{
    DVSwitch *switcher;
}
@end

@implementation MLApplicationList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self switcherInit];
}

- (void)switcherInit{
    switcher = [DVSwitch switchWithStringsArray:@[@"申请中", @"已录用", @"全部"]];
    switcher.frame = CGRectMake(0, 160,[[UIScreen mainScreen] bounds].size.width, 44);
    switcher.backgroundColor = [UIColor whiteColor];
    switcher.sliderColor = [UIColor colorWithRed:0.16 green:0.73 blue:0.65 alpha:1.0];
    switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    switcher.labelTextColorOutsideSlider = [UIColor blackColor];
    switcher.cornerRadius = 0;
    switcher.sliderType=lineSlider;
    
    //__weak typeof(self) weakSelf = self;
    
    [switcher setWillBePressedHandler:^(NSUInteger index) {
        if (index==0){
            //weakSelf.currentPage=0;
        }
        else if (index==1){

            //weakSelf.currentPage=1;
        }
        else if (index==2){

            //weakSelf.currentPage=2;
        }
    }];
    
    self.tableView.tableHeaderView=switcher;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

@end
