//
//  BSTextField.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/22.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTextField.h"

@implementation BSTextField

/**
 *  监听键盘删除键的点击
 */
- (void)deleteBackward{
    // 执行需要做的操作
    !self.deleteBackwardOperation ? : self.deleteBackwardOperation();
    
    // 放在前面 当只有一个字时点击删除按钮会把前面的按钮也删除
    [super deleteBackward];
}

@end
