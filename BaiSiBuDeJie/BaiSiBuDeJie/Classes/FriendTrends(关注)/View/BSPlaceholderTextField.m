//
//  BSPlaceholderTextField.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/6.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPlaceholderTextField.h"
#import <objc/runtime.h>

@implementation BSPlaceholderTextField

static NSString * const BSPlaceholderColor = @"placeholderLabel.textColor";
- (void)awakeFromNib{
 
    // 自定义光标颜色
    self.tintColor = [UIColor whiteColor];
    
    /** 设置占位文字颜色 */
    self.placeholderColor = [UIColor lightGrayColor];
/*
    // addTarget方式
    [self addTarget:self action:@selector(didBeginEdit) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(didEndEdit) forControlEvents:UIControlEventEditingDidEnd];
 
    //通知方式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEdit) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEdit) name:UITextFieldTextDidEndEditingNotification object:nil];
*/

}
/*
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didBeginEdit{
//    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = [UIColor whiteColor];
    [self setValue:[UIColor whiteColor] forKeyPath:BSPlaceholderColor];
}
- (void)didEndEdit{
    [self setValue:[UIColor lightGrayColor] forKeyPath:BSPlaceholderColor];
}
*/

- (BOOL)becomeFirstResponder{
    self.placeholderColor = [UIColor whiteColor];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    self.placeholderColor = [UIColor lightGrayColor];
    return [super resignFirstResponder];
}

@end
