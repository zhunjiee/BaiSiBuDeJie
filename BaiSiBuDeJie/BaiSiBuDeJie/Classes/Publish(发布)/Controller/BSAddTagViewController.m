//
//  BSAddTagViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSAddTagViewController.h"
#import <objc/runtime.h>

@interface BSAddTagViewController () <UITextFieldDelegate>
/** 存放所有控件的视图 */
@property (nonatomic, weak) UIView *contentView;
/** 输入框 */
@property (nonatomic, weak) UITextField *textField;
/** 提示按钮 */
@property (nonatomic, weak) UIButton *tipButton;
@end

@implementation BSAddTagViewController
#pragma mark - 懒加载
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
    UITextField *textField = [[UITextField alloc] init];
    textField.width = self.contentView.width;
    textField.height = BSTagH;
    // 设置占位文字
    textField.placeholderColor = [UIColor grayColor];
    textField.placeholder = @"多个标签用逗号或者换行隔开";
//    [textField setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
    
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    // 成为第一响应者,就可以直接弹出键盘
    [textField becomeFirstResponder];
    
    [textField addTarget:self action:@selector(textEditingDidChange) forControlEvents:UIControlEventEditingChanged];
    
    // 刷新前提:这个控件已经被添加到了父控件中
    [textField layoutIfNeeded];
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
- (void)textEditingDidChange{
    if (self.textField.hasText) {
        self.tipButton.hidden = NO;
        self.tipButton.y = CGRectGetMaxY(self.textField.frame) + BSSmallMargin;
        [self.tipButton setTitle:[NSString stringWithFormat:@"添加标签：%@", self.textField.text] forState:UIControlStateNormal];
    }else{
        self.tipButton.hidden = YES;
    }
}


- (void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonClick{
    
}
@end
