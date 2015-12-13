//
//  BSPublishButton.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/10.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPublishButton.h"

@implementation BSPublishButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

@end
