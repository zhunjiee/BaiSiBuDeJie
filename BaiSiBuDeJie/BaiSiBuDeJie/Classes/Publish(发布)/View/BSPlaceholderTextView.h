//
//  BSPlaceholderTextView.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/13.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
