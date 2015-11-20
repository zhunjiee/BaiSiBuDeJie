//
//  BSExtensionConfig.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/9.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSExtensionConfig.h"
#import <MJExtension.h>
#import "BSRecommendCategory.h"
#import "BSTopic.h"

@implementation BSExtensionConfig

+ (void)load{
    [BSRecommendCategory setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
    
    [BSTopic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"top_cmt" : @"top_cmt[0]",
                 @"smallImage" : @"image0",
                 @"largeImage" : @"image1",
                 @"middleImage" : @"image2",
                 };
    }];
}
@end
