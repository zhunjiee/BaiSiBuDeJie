//
//  BSClearCachesCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/8.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSClearCachesCell.h"

@implementation BSClearCachesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = @"清除缓存";
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
