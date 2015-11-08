//
//  BSMeCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/7.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSMeCell.h"

@implementation BSMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置选中cell不变色
        //    self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置cell右边指示器的样式
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.imageView.image == nil) {
        return;
    }
    
    self.imageView.height = self.height - BSMargin;
    self.imageView.width = self.imageView.height;
    self.imageView.centerY = self.height * 0.5;
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + BSMargin;
}
@end
