//
//  UITextField+BSPlaceholderColor.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/7.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "UITextField+BSPlaceholderColor.h"

@implementation UITextField (BSPlaceholderColor)

static NSString *const BSPlaceholderColor = @"placeholderLabel.textColor";
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    if (placeholderColor == nil) {
        [self setValue:[UIColor lightGrayColor] forKeyPath:BSPlaceholderColor];
    }else{
        // 保存之前的展位文字
        NSString *placeholder = self.placeholder;
        
        self.placeholder = @" "; // 保证placeholderLabel被创建了
        [self setValue:placeholderColor forKeyPath:BSPlaceholderColor];
        
        // 恢复之前的占位文字
        self.placeholder = placeholder;
    }
}

- (UIColor *)placeholderColor{
    return [self valueForKeyPath:BSPlaceholderColor];
}
@end
