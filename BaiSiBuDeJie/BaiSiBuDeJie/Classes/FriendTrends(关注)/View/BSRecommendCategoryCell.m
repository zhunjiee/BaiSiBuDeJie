//
//  BSRecommendCategoryCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/9.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSRecommendCategoryCell.h"
#import "BSRecommendCategory.h"

@interface BSRecommendCategoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *leftIndicator;

@end

@implementation BSRecommendCategoryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
//    if (selected) {// 选中
//        self.leftIndicator.hidden = NO;
//        self.categoryLabel.textColor = [UIColor redColor];
//    }else{// 取消选中
//        self.leftIndicator.hidden = YES;
//        self.categoryLabel.textColor = [UIColor blackColor];
//    }
    
    self.leftIndicator.hidden = selected ? NO : YES;
    self.categoryLabel.textColor = selected ? [UIColor redColor] : [UIColor blackColor];
}

- (void)setCategory:(BSRecommendCategory *)category{
    _category = category;
    self.categoryLabel.text = category.name;
}

@end
