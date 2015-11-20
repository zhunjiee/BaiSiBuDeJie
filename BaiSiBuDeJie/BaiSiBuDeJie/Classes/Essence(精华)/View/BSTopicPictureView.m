//
//  BSTopicPictureView.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/20.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopicPictureView.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>

@interface BSTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end

@implementation BSTopicPictureView

+ (instancetype)pictureView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setTopic:(BSTopic *)topic{
    _topic = topic;
    self.gifView.hidden = !topic.is_gif;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage]];
}

@end
