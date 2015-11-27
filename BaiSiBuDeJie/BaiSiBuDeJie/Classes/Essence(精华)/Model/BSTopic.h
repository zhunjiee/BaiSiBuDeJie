//
//  BSTopic.h
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSComment;

typedef enum {
    /** 全部 */
    BSTopicTypeAll = 1,
    /** 图片 */
    BSTopicTypePicture = 10,
    /** 文字 */
    BSTopicTypeWord = 29,
    /** 声音 */
    BSTopicTypeVoice = 31,
    /** 视频 */
    BSTopicTypeVideo = 41
} BSTopicType;

@interface BSTopic : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;

/** 帖子ID */
@property (nonatomic, copy) NSString *ID;

/** 最热评论 */
@property (nonatomic, strong) BSComment *top_cmt;

/** 帖子类型 */
@property (nonatomic, assign) BSTopicType type;

/** 中间模型的frame */
@property (nonatomic, assign) CGRect centerViewFrame;
/** 帖子模型的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 图片宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片宽度 */
@property (nonatomic, assign) CGFloat height;
/** 是否为大图 */
@property (nonatomic, assign, getter=isBigImage) BOOL bigImage;
/** 是否为gif图片 */
@property (nonatomic, assign) BOOL is_gif;
/** 小图 */
@property (nonatomic, copy) NSString *smallImage;
/** 中图 */
@property (nonatomic, copy) NSString *middleImage;
/** 大图 */
@property (nonatomic, copy) NSString *largeImage;

/** 声音路径 */
@property (nonatomic, copy) NSString *voiceuri;
/** 声音长度 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频播放次数 */
@property (nonatomic, assign) NSInteger playfcount;

/** 视频路径 */
@property (nonatomic, copy) NSString *videouri;
/** 视频长度 */
@property (nonatomic, assign) NSInteger videotime;
/** 视频播放次数 */
@property (nonatomic, assign) NSInteger playcount;

@end
