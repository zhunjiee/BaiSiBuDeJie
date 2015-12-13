//
//  BSQuickLoginButton.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/6.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSQuickLoginButton.h"

@implementation BSQuickLoginButton
// 通过代码的方式创建
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

// 从xib加载时调用
- (void)awakeFromNib{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.width = self.width;
}

@end
