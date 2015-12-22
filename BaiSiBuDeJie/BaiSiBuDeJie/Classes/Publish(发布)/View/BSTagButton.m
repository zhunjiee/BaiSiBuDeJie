//
//  BSTagButton.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/16.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTagButton.h"

@implementation BSTagButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BSTagButtonColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    }
    return self;
}

// 在设置标题的时候对按钮的尺寸进行微调
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    
    // 自动计算
    [self sizeToFit];
    
    // 微调
    self.height = BSTagH;
    self.width += 3 * BSSmallMargin;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x = BSSmallMargin;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + BSSmallMargin;
}

@end
