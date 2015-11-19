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
                 };
    }];
}
@end
