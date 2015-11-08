//
//  UIBarButtonItem+BSExtension.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BSExtension)
/**
 *  自定义barButtonItem按钮
 */
+ (instancetype)itemWithTarget:(id)target action:(SEL)action normalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage;

/**
 *  自定义TabBar按钮checkbox效果
 */
+ (instancetype)itemWithTarget:(id)target action:(SEL)action normalImage:(NSString *)normalImage selImage:(NSString *)selImage;
@end
