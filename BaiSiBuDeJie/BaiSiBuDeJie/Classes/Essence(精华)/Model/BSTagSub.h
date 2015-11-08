//
//  BSTagSub.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTagSub : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
/** 名称 */
@property (nonatomic, copy) NSString *theme_name;
@end
