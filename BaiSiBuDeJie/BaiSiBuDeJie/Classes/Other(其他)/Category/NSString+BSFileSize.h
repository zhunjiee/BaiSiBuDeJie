//
//  NSString+BSFileSize.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/8.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BSFileSize)

/**
 *  获取文件的大小
 */
- (unsigned long long)fileSize;

/**
 *  以字符串形式返回文件大小
 */
- (NSString *)fileSizeString;

@end
