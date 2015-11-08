//
//  BSQuickLoginButton.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/6.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSQuickLoginButton.h"

@implementation BSQuickLoginButton

- (void)awakeFromNib{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.width = self.width;
}

@end
