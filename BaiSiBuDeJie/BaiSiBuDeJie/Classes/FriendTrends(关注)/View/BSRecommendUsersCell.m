//
//  BSRecommendUsersCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/9.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSRecommendUsersCell.h"
#import "BSRecommendUsers.h"

@interface BSRecommendUsersCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end


@implementation BSRecommendUsersCell

- (void)setUser:(BSRecommendUsers *)user{
    _user = user;
    
    [self.headerView setHeaderImage:[NSURL URLWithString:user.header]];
    self.nameLabel.text = user.screen_name;
    
    self.fansCountLabel.text = user.fans_count;
}

@end
