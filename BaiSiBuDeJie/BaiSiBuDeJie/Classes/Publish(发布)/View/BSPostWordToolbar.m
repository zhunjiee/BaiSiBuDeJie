//
//  BSPostWordToolbar.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPostWordToolbar.h"
#import "BSNavigationController.h"
#import "BSAddTagViewController.h"

@interface BSPostWordToolbar ()
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 所有的标签label数组 */
@property (nonatomic, strong) NSMutableArray *tagLabels;
/** 加号按钮 */
@property (nonatomic, weak) UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation BSPostWordToolbar
/** tagLabels的懒加载 */
- (NSMutableArray *)tagLabels{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addButton.x = BSSmallMargin;
    addButton.y = BSSmallMargin;
    [addButton sizeToFit];
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建默认的两个按钮
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}

/**
 *  我们是从PostWordController控制器再modal控制器,
 *  又因为PostWordController是由根控制器modal出来的,所以必须先拿到根控制器,
 *  再通过 .presentedViewController 方法才可以拿到PostWordController,之后再modal到新控制器
 *  这种做法遵从了MVC思想---view里不应该有控制器
 */
- (void)addButtonClick{
    BSWeakSelf;
    BSAddTagViewController *addTag = [[BSAddTagViewController alloc] init];

#warning 逆传：后一个页面返回的标签数组
    addTag.getTagsBlock = ^(NSArray *tags){
        [weakSelf createTagLabels:tags];
    };

#warning 顺传：从 标签页 传递到 编辑标签页
    addTag.tags = [self.tagLabels valueForKeyPath:@"text"];
    
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:addTag];
    
    // 拿到根控制器
    UIViewController *root = self.window.rootViewController;
    // 获取PostWordViewController
    UIViewController *postWord = root.presentedViewController;
    
    [postWord presentViewController:nav animated:YES completion:nil];
}

/**
 *  创建标签Label
 */
- (void)createTagLabels:(NSArray *)tags{
    // 移除所有的label
#warning 让self.tagLabels数组中的所有对象执行removeFromSuperview方法
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    // 重新创建所有的标签label
    for (int i = 0; i < tags.count; i++) {
        // 创建label
        UILabel *newTagLabel = [[UILabel alloc] init];
        newTagLabel.text = tags[i];
        newTagLabel.font = [UIFont systemFontOfSize:14];
        newTagLabel.backgroundColor = BSTagButtonColor;
        newTagLabel.textColor = [UIColor whiteColor];
        newTagLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:newTagLabel];
        [self.tagLabels addObject:newTagLabel];
        
        // 设置尺寸
        [newTagLabel sizeToFit];
        newTagLabel.height = BSTagH;
        newTagLabel.width += 2 * BSSmallMargin;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 所有标签label的位置
    for (int i = 0; i < self.tagLabels.count; i++) {
        UILabel *newTagLabel = self.tagLabels[i];
        
        // 位置
        if (i == 0) {
            newTagLabel.x = 0;
            newTagLabel.y = 0;
        }else{
            // 上一个标签
            UILabel *previousTagLabel = self.tagLabels[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(previousTagLabel.frame) +BSSmallMargin;
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= newTagLabel.width) {
                newTagLabel.x = leftWidth;
                newTagLabel.y = previousTagLabel.y;
            }else{
                newTagLabel.x = 0;
                newTagLabel.y = CGRectGetMaxY(previousTagLabel.frame) + BSSmallMargin;
            }
        }
        
    }
    
    // 加号按钮的位置
    UILabel *lastTagLabel = self.tagLabels.lastObject;
    if (lastTagLabel) {
        CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + BSSmallMargin;
        CGFloat rightWidth = self.topView.width - leftWidth;
        if (rightWidth >= self.addButton.width) {
            self.addButton.x = leftWidth;
            self.addButton.y = lastTagLabel.y;
        }else{
            self.addButton.x = 0;
            self.addButton.y = CGRectGetMaxY(lastTagLabel
                                             .frame) + BSSmallMargin;
        }
    }else{
        self.addButton.x = 0;
        self.addButton.y = 0;
    }
    
    
    // 计算工具条的高度
    self.topViewHeight.constant = CGRectGetMaxY(lastTagLabel.frame) + BSSmallMargin;
    CGFloat oldHeight = self.height;
    CGFloat newHeight = self.height = self.topViewHeight.constant + self.bottomView.height;
    
    self.y += oldHeight - newHeight;
}
@end
