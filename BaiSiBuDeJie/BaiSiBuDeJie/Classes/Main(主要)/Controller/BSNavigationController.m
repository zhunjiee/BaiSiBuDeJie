//
//  BSNavigationController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/1.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSNavigationController.h"

@interface BSNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation BSNavigationController

+ (void)initialize{
    /** 设置UINavigationBar */
    UINavigationBar *bar = [UINavigationBar appearance];
    // 统一设置导航栏背景
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏 标题文字 相关属性
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20]; // 粗体
    [bar setTitleTextAttributes:titleAttrs];
    
    
    /** 设置UIBarButtonItem */
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置导航栏 左右按钮文字 相关属性
    // UIControlStateNormal
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *disableAttrs = [NSMutableDictionary dictionary];
    disableAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:disableAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置pop手势代理
    self.interactivePopGestureRecognizer.delegate = self;
}


/**
 *  重写push方法实现界面跳转后的各种设置
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        // push跳转后隐藏底部TabBar栏
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置返回按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:BSColor(251, 32, 37, 100) forState:UIControlStateHighlighted];
        // 按钮里面的内容朝左移动10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button sizeToFit];
        
        [button addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    // 先设置属性,再调用super的push方法,避免设置的属性被覆盖
    [super pushViewController:viewController animated:animated];
}

- (void)cancelButtonClick{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
// 是否启用手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count > 1;
}

@end
