//
//  ULTabBarController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULTabBarController.h"
#import "ULNavigationController.h"
#import "ULLabViewController.h"
#import "ULMessageViewController.h"
#import "ULHomeMainViewController.h"

@interface ULTabBarController ()

@property (strong, nonatomic) NSArray *itemArray;  /**< tabbar数组 */

@end

@implementation ULTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBarItem];
    
}

- (void)initTabBarItem
{
    self.tabBar.backgroundImage = [UIImage imageNamed:@"ulab_bottom"];
    self.tabBar.barTintColor = kCommonWhiteColor;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:[self tabbarDefines].count];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kCommonWhiteColor}   forState:UIControlStateNormal];
    for (NSDictionary *itemDic in [self tabbarDefines])
    {
        Class vcClass = NSClassFromString(itemDic[@"viewController_class"]);
        UIViewController *viewController = [[vcClass alloc] init];
        viewController.title = itemDic[@"name"];
        
        ULNavigationController *naviController = [[ULNavigationController alloc] initWithRootViewController:viewController];
        
        
        [naviController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ulab_navigationBar"] forBarMetrics:UIBarMetricsDefault];
        naviController.tabBarItem.title = itemDic[@"name"];
        [naviController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        //        [naviController.navigationBar setBackgroundImage:kNavbar_BgImage forBarMetrics:UIBarMetricsDefault];
        naviController.tabBarItem.image = [[UIImage imageNamed:itemDic[@"icon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        naviController.tabBarItem.selectedImage = [[UIImage imageNamed:itemDic[@"icon_s"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //        naviController.navigationBar.barStyle = UIStatusBarStyleLightContent;
        [viewControllers addObject:naviController];
    }
    self.viewControllers = viewControllers;
    self.selectedIndex = 0;
}

- (NSArray *)tabbarDefines
{
    NSArray *defineArray = @[
                             @{@"name" : @"首页",
                               @"icon" : @"home_sign",
                               @"icon_s" : @"home_sign_s",
                               @"viewController_class" : NSStringFromClass([ULHomeMainViewController class])} ,
                             @{@"name" : @"消息",
                               @"icon" : @"message_sign",
                               @"icon_s" : @"message_sign_s",
                               @"viewController_class" : NSStringFromClass([ULMessageViewController class])} ,
                             @{@"name" : @"实验室",
                               @"icon" : @"lab_sign",
                               @"icon_s" : @"lab_sign_s",
                               @"viewController_class" : NSStringFromClass([ULLabViewController class])}];
    return [defineArray copy];
}
@end
