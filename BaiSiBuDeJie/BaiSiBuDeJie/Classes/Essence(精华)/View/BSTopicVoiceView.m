//
//  BSTopicVoiceView.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/22.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopicVoiceView.h"
#import <UIImageView+WebCache.h>
#import "BSTopic.h"

@interface BSTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@end

@implementation BSTopicVoiceView

+ (instancetype)voiceView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setTopic:(BSTopic *)topic{
    _topic = topic;
    
    // 下载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.playCountLabel.hidden = NO;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.playCountLabel.hidden = YES;
    }];
}

@end
