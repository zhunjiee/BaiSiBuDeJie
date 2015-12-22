//
//  BSTextField.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/22.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTextField : UITextField

/** 点击键盘删除按钮可以删除标签按钮的block */
@property (nonatomic, copy) void (^deleteBackwardOperation)();

@end
