//
//  BSComment.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/20.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSUser;

@interface BSComment : NSObject
/** 评论内容 */
@property (nonatomic, copy) NSString *content;
/** 用户 */
@property (nonatomic, strong) BSUser *user;
@end
