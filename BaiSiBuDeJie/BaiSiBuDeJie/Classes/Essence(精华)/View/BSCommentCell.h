//
//  BSCommentCell.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/27.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSComment;

@interface BSCommentCell : UITableViewCell
/** 评论模型 */
@property (nonatomic, strong) BSComment *comment;
@end
