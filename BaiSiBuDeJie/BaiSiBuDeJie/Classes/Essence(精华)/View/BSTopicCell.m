//
//  BSTopicCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopicCell.h"
#import "BSTopic.h"

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
@end

@implementation BSTopicCell

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
