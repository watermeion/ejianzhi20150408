//
//  MLTabbarVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLTabbarVC.h"
#import "MLNavi.h"


//tabViewController
#import "MLFirstVC.h"
//#import "MLSecondVC.h"
//#import "MLThirdVC.h"
//#import "MLForthVC.h"

#import "JobListTableViewController.h"

@interface MLTabbarVC ()

@property (strong,nonatomic)MLFirstVC *firstVC;
//@property (strong,nonatomic)MLSecondVC *secondVC;
//@property (strong,nonatomic)MLThirdVC *messageVC;
//@property (strong,nonatomic)MLForthVC *forthVC;

@end

@implementation MLTabbarVC


-(MLFirstVC*)firstVC
{
  if(_firstVC==nil)
  {
      _firstVC=[[MLFirstVC alloc]init];
  }
    return _firstVC;

}
//
//
//-(MLThirdVC*)messageVC
//{
//    if(_messageVC==nil)
//    {
//        _messageVC=[[MLThirdVC alloc]init];
//    }
//    return _messageVC;
//}
//
//
//-(MLSecondVC*)secondVC
//{
//    if(_secondVC==nil)
//    {
//        _secondVC=[[MLSecondVC alloc]init];
//    }
//    return _secondVC;
//}
//
//
//-(MLForthVC*)forthVC
//{
//    if (_forthVC==nil) {
//        _forthVC=[[MLForthVC alloc]init];
//    }
//    return  _forthVC;
//}

-(MLNavi*)makeRootByNavigationController:(UIViewController*) childVC
{
    @try {
        if (childVC==nil) {
            //return [[UIViewController alloc]init];
            return [[MLNavi alloc]initWithRootViewController:[[UIViewController alloc]init]];
        }
        return [[MLNavi alloc]initWithRootViewController:childVC];
    }
    @catch (NSException *exception) {
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewControllersInit];
}

-(void)viewControllersInit
{
   //page 1
    UIViewController *pageOneVC=[self makeRootByNavigationController:self.firstVC];
//   //page 2
    JobListTableViewController *myJobVC=[[JobListTableViewController alloc]init];
     UIViewController *pageTwoVC=[self makeRootByNavigationController:myJobVC];
    
    pageTwoVC.title=@"申请";
//   //page 3
//   UIViewController *pageThreeVC=[self makeRootByNavigationController:self.messageVC];
//   //page 4
//    UIViewController *pageFourVC=[self makeRootByNavigationController:self.forthVC];
//    
    self.viewControllers=@[pageOneVC,pageTwoVC];
    
    [self changeTabbarStyle];
}

-(void)changeTabbarStyle
{
    
    [self.tabBar setTintColor:NaviBarColor];
    self.tabBar.translucent=NO;
    
    UITabBar *tabBar=self.tabBar;

    UITabBarItem *tabBarItem1=[tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2=[tabBar.items objectAtIndex:1];
    //UITabBarItem *tabBarItem3=[tabBar.items objectAtIndex:2];
    //UITabBarItem *tabBarItem4=[tabBar.items objectAtIndex:3];
    //    UITabBarItem *tabBarItem5=[tabBar.items objectAtIndex:4];
    
    tabBarItem1.title=@"首页";
    //    tabBarItem1.image=[UIImage imageNamed:@"userTabbar"];
    
    tabBarItem2.title=@"申请";
    //    tabBarItem2.image=[UIImage imageNamed:@"letter"];
    
    //tabBarItem3.title=@"消息";
    //    tabBarItem3.image=[UIImage imageNamed:@"edit"];
    
    //tabBarItem4.title=@"我的";
    

    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[[UIImage imageNamed:@"releas1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"release"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"explore1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"explore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //[[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"message1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //[[self.tabBar.items objectAtIndex:3] setFinishedSelectedImage:[[UIImage imageNamed:@"mine1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}
- (void)viewWillLayoutSubviews{
    
    //[self.tabBar setSelectedImageTintColor: [UIColor colorWithRed:0.90 green:0.39 blue:0.22 alpha:1.0]];
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
