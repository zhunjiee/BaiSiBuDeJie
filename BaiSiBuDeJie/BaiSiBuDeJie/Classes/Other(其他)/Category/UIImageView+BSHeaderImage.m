//
//  UIImageView+BSHeaderImage.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "UIImageView+BSHeaderImage.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (BSHeaderImage)

- (void)setHeaderImage:(NSURL *)url{
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            return;
        }
        
        self.image = [image circleImage];
    }];
}
@end
