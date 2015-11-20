//
//  BSUser.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/20.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUser : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
@end
