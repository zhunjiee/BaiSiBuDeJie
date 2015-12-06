//
//  BSStatusBarViewController.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSStatusBarViewController : UIViewController
/**
 *  显示状态栏上的view
 */
+ (void)show;

// 单例
+ (instancetype)sharedStatusBarViewController;

/** 状态栏的显示与隐藏 */
@property (nonatomic, assign, getter=isStatusBarHidden) BOOL statusBarHidden;

/** 状态栏的样式 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end
