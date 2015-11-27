//
//  BSTopicVideoView.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/22.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopicVideoView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BSTopic.h"
#import <UIImageView+WebCache.h>

@interface BSTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 播放器 */
@property (nonatomic, strong) MPMoviePlayerViewController *player;
@end


@implementation BSTopicVideoView
/** player的懒加载 */
- (MPMoviePlayerViewController *)player{
    if (!_player) {
        _player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.topic.videouri]];
    }
    return _player;
}
+ (instancetype)videoView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)]];
}


- (void)playVideo{
    [self.window.rootViewController presentMoviePlayerViewControllerAnimated:self.player];
}

- (IBAction)playButtonClick {
    [self playVideo];
}


- (void)setTopic:(BSTopic *)topic{
    _topic = topic;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.placeholderView.hidden = NO;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.placeholderView.hidden = YES;
    }];
    
    // 设置播放次数
    if (topic.playcount >= 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.2f万次播放", topic.playcount / 10000.0];
    }else{
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd次播放", topic.playcount];
    }
    
    // 设置音频时长
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd : %02zd", topic.videotime / 60, topic.videotime % 60];
}

@end
