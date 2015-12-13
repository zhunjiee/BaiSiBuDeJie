//
//  BSPlaceholderTextView.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/13.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPlaceholderTextView.h"

@implementation BSPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置默认占位文字大小,为了防止用户不设置出现错误
        self.font = [UIFont systemFontOfSize:15];
        // 设置默认占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)TextDidChange:(NSNotification *)notification{
    // 重绘: 会重新调用drawRect:方法
    [self setNeedsDisplay];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  每次调用drawRect:方法,都会将以前画得东西抹掉
 */
- (void)drawRect:(CGRect)rect{
    // 如果有文字,说明输入了文字,就直接返回
//    if (self.text.length || self.attributedText.length) return;
    if (self.hasText) return;
    
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    // 画文字
    BSLog(@"%@", NSStringFromCGRect(self.bounds)); //{{0, -64}, {375, 667}}
    
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

#pragma mark - setter方法
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}
@end
