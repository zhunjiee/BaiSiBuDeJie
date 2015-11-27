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
#import <AVFoundation/AVFoundation.h>

@interface BSTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation BSTopicVoiceView
/** player的懒加载 */
- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.topic.voiceuri]];
    }
    return _player;
}
+ (instancetype)voiceView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selector)];
    [self.imageView addGestureRecognizer:tap];
}

- (void)setTopic:(BSTopic *)topic{
    _topic = topic;
    
    // 下载并设置背景图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.placeholderView.hidden = NO;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.placeholderView.hidden = YES;
    }];
    
    // 设置播放次数
    if (topic.playcount >= 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.2f万次播放", topic.playfcount / 10000.0];
    }else{
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd次播放", topic.playfcount];
    }
    
    // 设置音频时长
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd : %02zd", topic.voicetime / 60, topic.voicetime % 60];
}


- (IBAction)playButtonClick:(UIButton *)playButton {
    
    playButton.selected = !playButton.isSelected;
    
    if (playButton.isSelected) {
        [self.player play];
    }else if (!playButton.isSelected){
        [self.player pause];
    }
    
}


@end
