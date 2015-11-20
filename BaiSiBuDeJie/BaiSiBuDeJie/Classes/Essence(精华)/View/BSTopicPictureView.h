//
//  BSTopicPictureView.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/20.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopic;

@interface BSTopicPictureView : UIView
/** 帖子模型数据 */
@property (nonatomic, strong) BSTopic *topic;

+ (instancetype)pictureView;
@end
