//
//  BSRecommendUSers.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/9.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendUsers : NSObject
/** 粉丝数 */
@property (nonatomic, copy) NSString *fans_count;
/** 头像*/
@property (nonatomic, copy) NSString *header;
/** 名字 */
@property (nonatomic, copy) NSString *screen_name;
@end
