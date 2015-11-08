//
//  BSClearCachesCell.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/8.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSClearCachesCell.h"

@interface BSClearCachesCell ()
/** 圈圈 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation BSClearCachesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加圈圈
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loadingView startAnimating];
        [self.contentView addSubview:loadingView];
        self.loadingView = loadingView;
        
        self.textLabel.text = @"清除缓存";
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self getCachesSize];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.height = self.contentView.height;
    
    self.loadingView.centerY = self.width * 0.5;
    self.loadingView.x = CGRectGetMaxX(self.contentView.frame) + BSMargin;
}

/**
 *  获取缓存的大小
 */
- (void)getCachesSize{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *file = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
        
        NSString *fileSize = [file fileSizeString];
        NSString *text = [NSString stringWithFormat:@"清除缓存(%@)", fileSize];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textLabel.text = text;
            // 删除圈圈
//            [self.loadingView removeFromSuperview];
        });
    });
}

- (void)reset{
    self.textLabel.text = @"清除缓存(0B)";
}

@end
