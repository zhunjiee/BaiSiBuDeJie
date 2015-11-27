//
//  BSTopicVideoView.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/22.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopic;

@interface BSTopicVideoView : UIView
/** 帖子模型 */
@property (nonatomic, strong) BSTopic *topic;

+ (instancetype)videoView;
@end
