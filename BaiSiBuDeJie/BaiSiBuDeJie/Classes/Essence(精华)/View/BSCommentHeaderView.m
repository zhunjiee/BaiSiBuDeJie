//
//  BSCommentHeaderView.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/27.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSCommentHeaderView.h"

@interface BSCommentHeaderView ()
/** label */
@property (nonatomic, weak) UILabel *label;
@end

@implementation BSCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = BSGlobalColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        
        label.x = 10;
        label.width = 100;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight; // 行高跟随父控件
        self.label = label;
        [self addSubview:label];
    }
    return self;
}


- (void)setText:(NSString *)text{
    _text = [text copy];
    
    self.label.text = text;
}
@end