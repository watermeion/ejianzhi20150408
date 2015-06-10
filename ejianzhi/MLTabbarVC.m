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
#import "MLChatVC.h"
#import "MLForthVC.h"

#import "JobListTableViewController.h"
#import "JobListWithDropDownListVCViewController.h"
@interface MLTabbarVC ()

@property (strong,nonatomic)MLFirstVC *firstVC;
//@property (strong,nonatomic)MLSecondVC *secondVC;
@property (strong,nonatomic)MLChatVC *chatVC;
@property (strong,nonatomic)MLForthVC *forthVC;

@end

@implementation MLTabbarVC

static  MLTabbarVC *thisController=nil;

+(MLTabbarVC*)shareInstance
{
    if (thisController==nil) {
        thisController=[[MLTabbarVC alloc] init];
    }
    return thisController;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(MLFirstVC*)firstVC
{
  if(_firstVC==nil)
  {
      _firstVC=[[MLFirstVC alloc]init];
  }
    return _firstVC;

}


-(MLChatVC*)chatVC
{
    if(_chatVC==nil)
    {
        _chatVC=[[MLChatVC alloc]init];
    }
    return _chatVC;
}

-(MLForthVC*)forthVC
{
    if (_forthVC==nil) {
        _forthVC=[[MLForthVC alloc]init];
    }
    return  _forthVC;
}

-(MLNavi*)makeRootByNavigationController:(UIViewController*) childVC
{
    @try {
        if (childVC==nil) {
            return [[MLNavi alloc]initWithRootViewController:[[UIViewController alloc]init]];
        }
        return [[MLNavi alloc]initWithRootViewController:childVC];
    }
    @catch (NSException *exception) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self viewControllersInit];
}

-(void)viewControllersInit
{

    UIViewController *pageOneVC=[self makeRootByNavigationController:self.firstVC];
    
    JobListWithDropDownListVCViewController *myJobVC=[[JobListWithDropDownListVCViewController alloc]init];
    
    UIViewController *pageTwoVC=[self makeRootByNavigationController:myJobVC];
    
    //UIViewController *pageThreeVC=[self makeRootByNavigationController:self.chatVC];

    UIViewController *pageFourVC=[self makeRootByNavigationController:self.forthVC];
    
    self.viewControllers=@[pageOneVC,pageTwoVC,pageFourVC];
    
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
    UITabBarItem *tabBarItem4=[tabBar.items objectAtIndex:2];
    
    tabBarItem1.title=@"首页";
    
    tabBarItem2.title=@"分类导航";
    
    //tabBarItem3.title=@"消息";
    
    tabBarItem4.title=@"我的";
    

    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[[UIImage imageNamed:@"partTime1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"partTime"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"explore1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"explore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //[[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"message1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"mine1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
