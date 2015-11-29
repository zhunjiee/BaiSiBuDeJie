//
//  BSCommentCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/27.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSCommentCell.h"
#import "BSComment.h"
#import "BSUser.h"

@interface BSCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dingCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@end

@implementation BSCommentCell

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setComment:(BSComment *)comment{
    _comment = comment;
    
//    if (arc4random_uniform(100) > 50) {
//        comment.voicetime = arc4random_uniform(60);
//        comment.voiceuri = @"http://123.mp3";
//        comment.content = nil;
//    }
    
    self.nameLabel.text = comment.user.username;
    self.commentLabel.text = comment.content;
    
    self.sexView.image = [comment.user.sex isEqualToString:@"m"] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    
    [self.headerView setHeaderImage:[NSURL URLWithString:comment.user.profile_image]];
    self.dingCountLabel.text = comment.like_count;
    
    // 设置声音评论内容
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        self.voiceButton.titleLabel.text = [NSString stringWithFormat:@"%zd''", comment.voicetime];
    }else{
        self.voiceButton.hidden = YES;
    }
}

@end
