//
//  BSAddTagViewController.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSAddTagViewController : UIViewController
/** 传递标签数据的block，block的参数是一个字符串的数组 */
@property (nonatomic, copy) void (^getTagsBlock)(NSArray *);
/** 从上一个界面传递过来的标签数据 */
@property (nonatomic, strong) NSArray *tags;
@end
