//
//  BSCommentViewController.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/27.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopic;

@interface BSCommentViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) BSTopic *topic;
@end
