//
//  BSStatusBarViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSStatusBarViewController.h"

@interface BSStatusBarViewController ()

@end

@implementation BSStatusBarViewController

#pragma mark - 单例
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)sharedStatusBarViewController{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- copyWithZone:(NSZone *)zone{
    return _instance;
}


#pragma mark - 控制状态栏
// getter方法
- (BOOL)prefersStatusBarHidden{
    return self.statusBarHidden;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}

// setter方法
- (void)setStatusBarHidden:(BOOL)statusBarHidden{
    _statusBarHidden = statusBarHidden;
    // 刷新状态栏（内部会重新调用prefersStatusBarHidden和preferredStatusBarStyle方法）
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
    // 刷新状态栏（内部会重新调用prefersStatusBarHidden和preferredStatusBarStyle方法）
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - window相关处理
static UIWindow *window_;
+ (void)show{
    window_ = [[UIWindow alloc] init];
    window_.backgroundColor = [UIColor clearColor];
    window_.frame = [UIApplication sharedApplication].statusBarFrame;
    window_.hidden = NO;
    window_.windowLevel = UIWindowLevelAlert;
    window_.rootViewController = [[BSStatusBarViewController alloc] init];
    
    // 窗口显示级别:
    // UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
}

// 不要让状态栏隐藏了,这个可能和后面的功能有冲突，后面再删除吧，现在先保留着
//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 让scrollView滚动到最前面
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

/**
 *  在view中搜索所有的scrollView,找到需要回滚的view,滚动到最顶部
 */
- (void)searchScrollViewInView:(UIView *)view{
    // 遍历所有子控件
    // 递归
    for (UIView *subView in view.subviews) {
        [self searchScrollViewInView:subView];
    }
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        
        // 计算出 scrollView 以 window 为坐标系的 Rect
        CGRect scrollViewRect = [scrollView convertRect:scrollView.bounds toView:nil];
        CGRect windowRect = scrollView.window.bounds;
        
        // 判断 scrollView 和 window 是否重合
        if (CGRectIntersectsRect(windowRect, scrollViewRect)) {
            return;
        }
        
        // 滚动到最前面
        CGPoint offset = scrollView.contentOffset;
        offset.y = - scrollView.contentInset.top;
        [scrollView setContentOffset:offset animated:YES];
    }
}

@end
