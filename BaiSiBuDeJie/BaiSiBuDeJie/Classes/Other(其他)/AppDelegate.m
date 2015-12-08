//
//  AppDelegate.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/1.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "AppDelegate.h"
#import "BSTabBarController.h"

@interface AppDelegate () <UITabBarControllerDelegate>
/** 上一次点击tabBarButton的位置 */
@property (nonatomic, assign) NSUInteger preSelectedTabBarBtnIndex;
@end

@implementation AppDelegate
#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (self.preSelectedTabBarBtnIndex == tabBarController.selectedIndex) {
        // 向外发送TabBar重复点击的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BSTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.preSelectedTabBarBtnIndex = tabBarController.selectedIndex;
}


#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1. 创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2. 设置根控制器
    BSTabBarController *root = [[BSTabBarController alloc] init];
    root.delegate = self;
    self.window.rootViewController = root;
    
    // 3. 显示主窗口
    [self.window makeKeyAndVisible];
    
    
    // 显示盖住状态栏的控制器
    [BSStatusBarViewController show];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
