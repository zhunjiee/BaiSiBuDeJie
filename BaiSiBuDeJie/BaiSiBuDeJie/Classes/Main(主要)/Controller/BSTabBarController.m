//
//  BSTabBarController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/1.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTabBarController.h"
#import "BSNavigationController.h"
#import "BSEssenceViewController.h"
#import "BSNewViewController.h"
#import "BSFriendTrendsViewController.h"
#import "BSMeViewController.h"
#import "BSTabBar.h"

@interface BSTabBarController ()

@end

@implementation BSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllViewController];
    
    [self setUpTabBarItemAttrs];
    
    [self setUpTabBar];
}

/**
 *  通过KVC方式修改系统的私有成员属性TabBar
 */
- (void)setUpTabBar{
    BSTabBar *tabBar = [[BSTabBar alloc] init];
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
}


/**
 *  通过appearance统一设置TabBar按钮的文字
 */
- (void)setUpTabBarItemAttrs{
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  设置所有控制器子
 */
- (void)setUpAllViewController{
    BSEssenceViewController *essence = [[BSEssenceViewController alloc] init];
    [self setUpOneChildViewController:essence image:[UIImage imageNamed:@"tabBar_essence_icon"] selImage:[UIImage imageNamed:@"tabBar_essence_click_icon"] title:@"精华"];
    
    BSNewViewController *new = [[BSNewViewController alloc] init];
    [self setUpOneChildViewController:new image:[UIImage imageNamed:@"tabBar_new_icon"] selImage:[UIImage imageNamed:@"tabBar_new_click_icon"] title:@"新帖"];
    
    BSFriendTrendsViewController *friendTrends = [[BSFriendTrendsViewController alloc] init];
    [self setUpOneChildViewController:friendTrends image:[UIImage imageNamed:@"tabBar_friendTrends_icon"] selImage:[UIImage imageNamed:@"tabBar_friendTrends_click_icon"] title:@"关注"];
    
    BSMeViewController *me = [[BSMeViewController alloc] init];
    [self setUpOneChildViewController:me image:[UIImage imageNamed:@"tabBar_me_icon"] selImage:[UIImage imageNamed:@"tabBar_me_click_icon"] title:@"我的"];
}

/**
 *  设置单个子控制器
 *
 *  @param viewController 子控制器名称
 *  @param image          tabBar按钮默认图片
 *  @param selImage       TabBar按钮选中图片
 *  @param title          TabBar按钮名称
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selImage:(UIImage *)selImage title:(NSString *)title {
    viewController.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.title = title;
    
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}

@end
