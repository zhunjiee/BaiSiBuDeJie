//
//  BSTopic.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopic.h"
#import "BSComment.h"
#import "BSUser.h"

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

/**
 *  设置帖子中间内容的frame,可以在cellHeight中设置
 */
//- (CGRect)centerViewFrame{
//    // 避免重复计算
//    if (_centerViewFrame.size.height) {
//        return _centerViewFrame;
//    }
//    
//    CGFloat centerViewX = BSMargin;
//    CGFloat centerViewW = [UIScreen mainScreen].bounds.size.width - 2 * BSMargin;
//    CGFloat centerViewH = centerViewW / self.width * self.height;
//    CGFloat textY = 55;
//    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(centerViewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
//    CGFloat centerViewY = textH + textY;
//    
//    if (centerViewH >= [UIScreen mainScreen].bounds.size.height) {
//        centerViewH = 200;
//        self.bigImage = YES;
//    }
//    
//    return CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
//}

/**
 *  设置帖子模型的高度和centerViewFrame
 */
- (CGFloat)cellHeight{
    // 避免重复计算
    if (_cellHeight) {
        return _cellHeight;
    }
    
    CGFloat textY = 55;
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * BSMargin;
    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height;
    _cellHeight = textY + textH;
    
    // 有中间的内容
    if (self.type != BSTopicTypeWord) {
        CGFloat centerViewX = BSMargin;
        CGFloat centerViewW = [UIScreen mainScreen].bounds.size.width - 2 * BSMargin;
        CGFloat centerViewH = centerViewW / self.width * self.height;
        CGFloat centerViewY = textH + textY;
        
        if (centerViewH >= [UIScreen mainScreen].bounds.size.height) {
            centerViewH = 200;
            self.bigImage = YES;
        }
        
        _centerViewFrame = CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
        
        _cellHeight += centerViewH + BSMargin;
    }
    
    // 有最热评论
    if (self.top_cmt) {
        CGFloat topCmtMaxY = 24;
        NSString *topCmtText = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, self.top_cmt.content];
        CGFloat topCmtTextH = [topCmtText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * BSMargin - 6, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
        _cellHeight += topCmtMaxY + topCmtTextH + BSMargin;
    }
    
    CGFloat toolBarH = 40;
    
    _cellHeight += toolBarH + BSMargin;
    
    return _cellHeight;
}
@end
