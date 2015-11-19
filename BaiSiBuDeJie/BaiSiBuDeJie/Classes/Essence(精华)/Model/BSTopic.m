//
//  BSTopic.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopic.h"

@implementation BSTopic

/**
 *  设置日期格式
 *
 *  兼容iOS8.0以前
 */
- (NSString *)created_at{
    // 服务器返回日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createAtDate = [fmt dateFromString:_created_at];
    
    if (createAtDate.isThisYear) { // 今年
        if (createAtDate.isToday) { // 今天
            // 获取系统当前时间
            NSDate *nowDate = [NSDate date];
            // 日历对象
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            
            NSDateComponents *cmps = [calendar components:unit fromDate:createAtDate toDate:nowDate options:0];
            
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            }else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            }else{
                return @"刚刚";
            }
        }else if (createAtDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }
    }else { // 非今年
        return _created_at;
    }
}


- (NSString *)created_at8{
    // 服务器返回日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createAtDate = [fmt dateFromString:_created_at];
    
    // 获取当前系统时间
    NSDate *nowDate = [NSDate date];
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:nowDate];
    NSInteger createAtYear = [calendar component:NSCalendarUnitYear fromDate:createAtDate];
    
    if (nowYear == createAtYear) { // 今年
        if ([calendar isDateInToday:createAtDate]) { // 今天
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            NSDateComponents *cmps = [calendar components:unit fromDate:createAtDate toDate:nowDate options:0];
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            }else if (cmps.minute >= 1){
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            }else{
                return @"刚刚";
            }
        }else if ([calendar isDateInYesterday:createAtDate]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }else{
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createAtDate];
        }
        
        
    } else { // 非今年
        return _created_at;
    }
}


@end
