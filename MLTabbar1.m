//
//  MLTabbar1.m
//  ejianzhi
//
//  Created by RAY on 15/4/20.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "MLTabbar1.h"
#import "MLNavi.h"

#import "MLForthVC.h"

@interface MLTabbar1 ()
@property (strong,nonatomic)MLForthVC *forthVC;
@end

@implementation MLTabbar1

static  MLTabbar1 *thisController=nil;

+(MLTabbar1*)shareInstance
{
    if (thisController==nil) {
        thisController=[[MLTabbar1 alloc] init];
    }
    return thisController;
}

-(MLForthVC*)forthVC
{
    if (_forthVC==nil) {
        _forthVC=[[MLForthVC alloc]init];
    }
    return  _forthVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewControllersInit];
}

-(void)viewControllersInit
{
    
    UIViewController *pageOneVC=[self makeRootByNavigationController:[[UIViewController alloc] init]];
    pageOneVC.title=@"我发布的兼职";
    UIViewController *pageTwoVC=[self makeRootByNavigationController:[[UIViewController alloc] init]];
    pageTwoVC.title=@"消息";
    UIViewController *pageThreeVC=[self makeRootByNavigationController:self.forthVC];
    pageThreeVC.title=@"我的";
    
    self.viewControllers=@[pageOneVC,pageTwoVC,pageThreeVC];
    
    [self changeTabbarStyle];
}

-(void)changeTabbarStyle
{
    
    [self.tabBar setTintColor:NaviBarColor];
    self.tabBar.translucent=NO;
    
    UITabBar *tabBar=self.tabBar;
    
    UITabBarItem *tabBarItem1=[tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2=[tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3=[tabBar.items objectAtIndex:2];
    
    tabBarItem1.title=@"首页";
    
    tabBarItem2.title=@"申请";
    
    tabBarItem3.title=@"消息";

    
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[[UIImage imageNamed:@"releas1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"release"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"explore1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"explore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"message1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
