//
//  BSTopicCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopicCell.h"
#import "BSTopic.h"
#import "BSComment.h"
#import "BSUser.h"
#import "BSTopicPictureView.h"

@interface BSTopicCell()
@property (weak, nonatomic) IBOutlet UIImageView *profile_imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

/** 最热评论的View */
@property (weak, nonatomic) IBOutlet UIView *top_cmtView;
/** 最热评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *top_cmtLabel;

/** 用户名 */
@property (nonatomic, copy) NSString *username;

// 中间的控件
/** 图片控件 */
@property (nonatomic, weak) BSTopicPictureView *pictureView;
@end

@implementation BSTopicCell
#pragma mark 懒加载
/** pictureView的懒加载 */
- (BSTopicPictureView *)pictureView{
    if (!_pictureView) {
        BSTopicPictureView *pictureView = [BSTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

#pragma mark - 初始化设置
- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

// 点击更多按钮
- (IBAction)moreButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BSLog(@"点击了收藏按钮");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BSLog(@"点击了举报按钮");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

/**
 *  设置帖子模型数据
 */
- (void)setTopic:(BSTopic *)topic{
    _topic = topic;
    [self.profile_imageView setHeaderImage:[NSURL URLWithString:topic.profile_image]];
    self.nameLabel.text = topic.name;
    self.text_label.text = topic.text;
    self.createdAtLabel.text = topic.created_at;
    
    [self setUpButton:self.dingButton withCount:topic.ding title:@"顶"];
    [self setUpButton:self.caiButton withCount:topic.cai title:@"踩"];
    [self setUpButton:self.repostButton withCount:topic.repost title:@"分享"];
    [self setUpButton:self.commentButton withCount:topic.comment title:@"评论"];
    
    // 设置最热评论
    if (topic.top_cmt) {
        self.top_cmtView.hidden = NO;
        
        // 设置最热评论的内容
        NSString *content = topic.top_cmt.content;
        NSString *username = topic.top_cmt.user.username;
        self.top_cmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
        
    }else {
        self.top_cmtView.hidden = YES;
    }
    
    // 设置中间具体内容
    if (topic.type == BSTopicTypePicture) { // 图片
        self.pictureView.hidden = NO;
        
        self.pictureView.frame = topic.centerViewFrame;
        self.pictureView.topic = topic;
    }else if (topic.type == BSTopicTypeVideo) { // 视频
        self.pictureView.hidden = YES;
    }else if (topic.type == BSTopicTypeVoice) { // 音频
        self.pictureView.hidden = YES;
    }else{ // 文字
        self.pictureView.hidden = YES;
    }
}

/**
 *  设置帖子cell底部按钮上的数量
 */
- (void)setUpButton:(UIButton *)button withCount:(NSInteger)count title:(NSString *)title {
    if (count >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", count / 10000.0] forState:UIControlStateNormal];
    }else if (count == 0){
        [button setTitle:title forState:UIControlStateNormal];
    }else{
        [button setTitle:[NSString stringWithFormat:@"%zd", count] forState:UIControlStateNormal];
    }
}

@end
