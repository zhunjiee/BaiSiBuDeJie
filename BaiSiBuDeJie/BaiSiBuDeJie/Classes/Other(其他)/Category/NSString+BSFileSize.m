//
//  NSString+BSFileSize.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/8.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "NSString+BSFileSize.h"

@implementation NSString (BSFileSize)

/**
 *  获取文件的大小
 */
- (unsigned long long)fileSize{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 1. 先判断是否存在
    BOOL isDirectory = NO;
    BOOL exist = [fileManager fileExistsAtPath:self isDirectory:&isDirectory];
    if (exist == NO) {
        return 0;
    }
    // 2. 再判断类型
    // 如果是文件夹
    if (isDirectory) {
        unsigned long long size = 0;
        // 通过遍历器遍历获取文件夹的大小
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 获取文件全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            // 获取属性
            NSDictionary *attrs = [fileManager attributesOfItemAtPath:fullSubpath error:nil];
            // 过滤掉文件夹
            if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) {
                continue;
            }
            size += [attrs[NSFileSize] integerValue];
        }
        return size;
    }
    
    // 如果是文件
    return [[fileManager attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
}

/**
 *  以字符串形式返回文件大小
 */
- (NSString *)fileSizeString{
    unsigned long long fileSize = self.fileSize;
    CGFloat unit = 1000.0;
    
    if (fileSize >= pow(unit, 3)) {
        return [NSString stringWithFormat:@"%.1fGB", fileSize / pow(unit, 3)];
    }else if (fileSize >= pow(unit, 2)) {
        return [NSString stringWithFormat:@"%.1fMB", fileSize / pow(unit, 2)];
    }else if (fileSize >= unit) {
        return [NSString stringWithFormat:@"%.1fKB", fileSize / unit];
    }else{
        return [NSString stringWithFormat:@"%zdB", fileSize];
    }
}
@end
