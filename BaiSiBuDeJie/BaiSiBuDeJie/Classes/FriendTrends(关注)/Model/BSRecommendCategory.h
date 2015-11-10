//
//  BSRecommendCategory.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/9.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendCategory : NSObject
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 数量 */
@property (nonatomic, assign) NSInteger count;
/** ID */
@property (nonatomic, copy) NSString *ID;

/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 总页数 */
@property (nonatomic, assign) NSInteger total;

/** 推荐用户数组 */
@property (nonatomic, strong) NSMutableArray *users;

@end
