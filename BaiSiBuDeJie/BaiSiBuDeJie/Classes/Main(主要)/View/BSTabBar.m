//
//  BSTabBar.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/2.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTabBar.h"
#import "BSPublishViewController.h"

@interface BSTabBar ()
/** 发布按钮 */
@property (nonatomic, strong) UIButton *publishBtn;
@end

@implementation BSTabBar
/** publishBtn的懒加载 */
- (UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [_publishBtn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [_publishBtn sizeToFit];
        
        [_publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_publishBtn];
    }
    return _publishBtn;
}

- (void)publishBtnClick{
    BSPublishViewController *publishVc = [[BSPublishViewController alloc] init];
    
//    publishVc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self.window.rootViewController presentViewController:publishVc animated:YES completion:nil];
}


/**
 *  初始化
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
    }
    return self;
}


/**
 *  布局子控件
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 发布按钮控件
    self.publishBtn.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
    // 布局四个TabBarButton控件
    CGFloat buttonWidth = self.width / 5;
    CGFloat i = 0;
    for (UIView *tabBarButton in self.subviews) {
        // 判断是否是TabBarButton类型
        if (![NSStringFromClass([tabBarButton class]) isEqualToString:@"UITabBarButton"]) continue;
        
        tabBarButton.width = buttonWidth;
        tabBarButton.x = i * buttonWidth;
        if (i > 1) {
            tabBarButton.x += buttonWidth;
        }
        i++;
    }
}
@end
