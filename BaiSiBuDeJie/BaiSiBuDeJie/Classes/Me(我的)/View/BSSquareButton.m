//
//  BSSquareButton.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/7.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSSquareButton.h"
#import "BSSquare.h"
#import <UIButton+WebCache.h>

@implementation BSSquareButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.imageView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 图片位置
    self.imageView.width = self.width - 3 * BSMargin;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX =self.width * 0.5;
    self.imageView.y = self.height * 0.1;
    
    // 文字位置
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


/**
 *  重写setter方法设置数据
 */
- (void)setSquare:(BSSquare *)square{
    _square = square;
    // 设置标题
    [self setTitle:square.name forState:UIControlStateNormal];

    // 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
@end
