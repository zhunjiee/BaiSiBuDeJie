//
//  BSAddTagViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSAddTagViewController.h"
#import <objc/runtime.h>
#import "BSTagButton.h"
#import <SVProgressHUD.h>
#import "BSTextField.h"

@interface BSAddTagViewController () <UITextFieldDelegate>
/** 存放所有控件的视图 */
@property (nonatomic, weak) UIView *contentView;
/** 输入框 */
@property (nonatomic, weak) BSTextField *textField;
/** 提示按钮 */
@property (nonatomic, weak) UIButton *tipButton;
/** 存放标签按钮的数组 */
@property (nonatomic, strong) NSMutableArray *tagButtonArray;
@end

@implementation BSAddTagViewController
#pragma mark - 懒加载
/** tagButtonArray的懒加载 */
- (NSMutableArray *)tagButtonArray{
    if (!_tagButtonArray) {
        _tagButtonArray = [NSMutableArray array];
    }
    return _tagButtonArray;
}
/** tipButton的懒加载 */
- (UIButton *)tipButton{
    if (!_tipButton) {
        // 创建提醒按钮
        UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tipButton.width = self.contentView.width;
        tipButton.height = BSTagH;
        tipButton.x = 0;
        tipButton.backgroundColor = BSTagButtonColor;
        tipButton.titleLabel.font = [UIFont systemFontOfSize:15];
        // 设置按钮内容对齐方式
        tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [tipButton addTarget:self action:@selector(tipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:tipButton];
        _tipButton = tipButton;
    }
    return _tipButton;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
#warning 运行时
//    unsigned int count = 0;
//    Ivar *ivarList = class_copyIvarList([UITextField class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivarList[i];
//        BSLog(@"%s ----- %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
//    }
//    free(ivarList);
    
    
    [self setUpNav];
    
    [self setUpContentView];
    
    [self setUpTextField];
    
    [self setupTags];
}

// 设置默认的tag标签
- (void)setupTags{
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self tipButtonClick];
    }
}

/**
 *  设置添加标签界面内容视图
 */
- (void)setUpContentView{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = BSSmallMargin;
    contentView.y = BSSmallMargin + BSNavMaxY;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.height = self.view.height;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

/**
 *  设置文本框
 */
- (void)setUpTextField{
    BSWeakSelf;
    
    BSTextField *textField = [[BSTextField alloc] init];
    textField.width = self.contentView.width;
    textField.height = BSTagH;
    // 设置占位文字
    textField.placeholderColor = [UIColor grayColor];
    textField.placeholder = @"多个标签用逗号或者换行隔开";
//    [textField setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
    textField.delegate = self;
    
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    // 成为第一响应者,就可以直接弹出键盘
    [textField becomeFirstResponder];
    
    [textField addTarget:self action:@selector(textEditingDidChange) forControlEvents:UIControlEventEditingChanged];
    
    // 刷新前提:这个控件已经被添加到了父控件中
    [textField layoutIfNeeded];
    
    // 点击删除按钮 删除标签 功能
    textField.deleteBackwardOperation = ^{
      // 判断文本框是否有文字
        if (weakSelf.textField.hasText || self.tagButtonArray.count == 0) return;
        
        // 相当于 点击了最后一个标签按钮 
        [weakSelf tagButtonClick:weakSelf.tagButtonArray.lastObject];
    };
}

/**
 *  设置导航栏
 */
- (void)setUpNav{
    self.navigationItem.title = @"添加标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClick)];

    // 强制更新
    [self.navigationController.navigationBar layoutIfNeeded];
}

#pragma maek - 监听方法
/**
 *  文本框内输入文字时调用
 */
- (void)textEditingDidChange{
    
    if (self.textField.hasText) {
        
        NSString *text = self.textField.text;
        NSString *lastChar = [text substringFromIndex:text.length - 1];
        // 最后一个字符是逗号
        if ([lastChar isEqualToString:@","] || [lastChar isEqualToString:@"，"]) {
            // 去除逗号
//            self.textField.text = [text substringToIndex:text.length - 1];
            [self.textField deleteBackward];
            
            // 相当于自动点击提醒按钮
            [self tipButtonClick];
        }else{
            // 排布文本框
            [self setUpTextFiledFrame];
            
            self.tipButton.hidden = NO;
            [self.tipButton setTitle:[NSString stringWithFormat:@"添加标签：%@", self.textField.text] forState:UIControlStateNormal];
        }
        
    }else{
        self.tipButton.hidden = YES;
    }
}

/**
 *  点击下面的提示按钮时调用
 */
- (void)tipButtonClick{
    if (self.textField.hasText == NO) return;
    
    if (self.tagButtonArray.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    // 创建一个标签按钮
    BSTagButton *newTagButton = [[BSTagButton alloc] init];
    [newTagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [newTagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置按钮的尺寸
    [self setUpTagButtonFrame:newTagButton referenceTagButton:self.tagButtonArray.lastObject];
    
    
    
    [self.contentView addSubview:newTagButton];
    // 隐藏提示按钮
    self.tipButton.hidden = YES;
    
    // 标签按钮存入数组
    [self.tagButtonArray addObject:newTagButton];
    
    // 重新设置输入框的位置
    self.textField.text = nil;
    [self setUpTextFiledFrame];
    
    // 隐藏提醒按钮
    self.tipButton.hidden = YES;
}

/**
 *  点击了标签按钮：会删除标签按钮
 */
- (void)tagButtonClick:(BSTagButton *)clickTagButton{
    // 即将被删除的标签按钮的索引
    NSUInteger index = [self.tagButtonArray indexOfObject:clickTagButton];
    
    // 删除标签按钮
    [clickTagButton removeFromSuperview];
    [self.tagButtonArray removeObject:clickTagButton];
    
    // 处理后面的标签按钮的位置
    for (NSUInteger i = index; i < self.tagButtonArray.count; i++) {
        BSTagButton *tagButton = self.tagButtonArray[i];
        // 如果i不为0，就参照上一个标签按钮
        BSTagButton *previousTagButton = (i == 0) ? nil : self.tagButtonArray[i - 1];
        [self setUpTagButtonFrame:tagButton referenceTagButton:previousTagButton];
    }
    
    // 排布文本框位置
    [self setUpTextFiledFrame];
}

/**
 *  返回
 */
- (void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  完成
 */
- (void)doneButtonClick{
#warning 逆传：传递数据给上一个界面
    // 1. 传递数据给上一个界面
//    NSMutableArray *tags = [NSMutableArray array];
//    for (BSTagButton *tagButton in self.tagButtonArray) {
//        [tags addObject:tagButton.currentTitle];
//    }
    // 将self.tagButtonArray中存放的所有对象的currentTitle取出来放到一个数组中,并返回
    NSArray *tags = [self.tagButtonArray valueForKeyPath:@"currentTitle"];
    !self.getTagsBlock ? : self.getTagsBlock(tags);
    
    // 2. 关闭当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 相关设置
/**
 *  设置标签按钮的位置
 *
 *  @param tagButton          新的标签按钮
 *  @param referenceTagButton 前一个标签按钮用于参照
 */
- (void)setUpTagButtonFrame:(BSTagButton *)tagButton referenceTagButton:(BSTagButton *)referenceTagButton{
    // 没有参照按钮(tagButton是第一个标签按钮）
    if (referenceTagButton == nil) {
        tagButton.x = 0;
        tagButton.y = 0;
        return;
    }
    
    // tagButton不是第一个标签按钮
    CGFloat leftWidth = CGRectGetMaxX(referenceTagButton.frame) + BSSmallMargin;
    CGFloat rightWidth = self.contentView.width - leftWidth;
    if (rightWidth > tagButton.width) { // 新的标签按钮  和前一个标签按钮 处在同一行
        tagButton.x = leftWidth;
        tagButton.y = referenceTagButton.y;
    }else{
        tagButton.x = 0;
        tagButton.y = CGRectGetMaxY(referenceTagButton.frame) + BSSmallMargin;
    }
}

/**
 *  重新设置文本框的位置
 */
- (void)setUpTextFiledFrame{
    // 文本框文字的宽度
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    textW = MAX(100, textW);
    
    BSTagButton *lastTagButton = self.tagButtonArray.lastObject;
    if (lastTagButton == nil) { // 没有标签按钮
        self.textField.x = 0;
        self.textField.y = 0;
    }else{
        CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + BSSmallMargin;
        CGFloat rightWidth = self.contentView.width - leftWidth;
        if (rightWidth >= textW) {
            self.textField.x = leftWidth;
            self.textField.y = lastTagButton.y;
        }else{
            self.textField.x = 0;
            self.textField.y = CGRectGetMaxY(lastTagButton.frame) + BSSmallMargin;
        }
    }
    
    // 重新排布提醒按钮的位置
    self.tipButton.y = CGRectGetMaxY(self.textField.frame) + BSSmallMargin;
}

#pragma mark - UITextFieldDelegate
// 点击了键盘的return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BSLog(@"return");
    [self tipButtonClick];
    return YES;
}
@end
