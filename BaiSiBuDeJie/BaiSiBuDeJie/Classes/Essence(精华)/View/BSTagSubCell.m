//
//  BSTagSubCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTagSubCell.h"
#import "BSTagSub.h"

@interface BSTagSubCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subCountLabel;

@end

@implementation BSTagSubCell
- (IBAction)subButtonClick {
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setTagSub:(BSTagSub *)tagSub{
    _tagSub = tagSub;
    
    [self.headerImageView setHeaderImage:[NSURL URLWithString:tagSub.image_list]];
    
    self.nameLabel.text = tagSub.theme_name;

    if (tagSub.sub_number >= 10000) {
        self.subCountLabel.text = [NSString stringWithFormat:@"%.2f万人订阅", tagSub.sub_number / 10000.0];
    }else{
        self.subCountLabel.text = [NSString stringWithFormat:@"%zd人订阅", tagSub.sub_number];
    }
}

@end
