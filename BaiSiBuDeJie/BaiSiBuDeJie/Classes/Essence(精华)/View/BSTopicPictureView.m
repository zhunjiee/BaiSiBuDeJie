//
//  BSTopicPictureView.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/20.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopicPictureView.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import <DALabeledCircularProgressView.h>
#import <AFNetworking.h>
#import "BSBigImageViewController.h"

@interface BSTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigImageButton;
/** 网络监听管理者 */
@property (nonatomic, weak) AFNetworkReachabilityManager *manager;

@end

@implementation BSTopicPictureView

static NSString *image = nil;

/** manager的懒加载 */
- (AFNetworkReachabilityManager *)manager{
    if (!_manager) {
        AFNetworkReachabilityManager *manager= [AFNetworkReachabilityManager sharedManager];
        _manager = manager;
    }
    return _manager;
}

+ (instancetype)pictureView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 进度条相关初始化设置
    self.progressView.roundedCorners = 5; // 设置进度条头的弧度
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    
    
    // 点击图片查看大图
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigImage)];
    [self.imageView addGestureRecognizer:tap];
}

- (void)seeBigImage{
    BSBigImageViewController *bigImage = [[BSBigImageViewController alloc] init];
    
    // 写在后面会报NaN(Not a Number)的错误，因为先modal过去，topic还是0
    bigImage.topic = self.topic;
    
    [self.window.rootViewController presentViewController:bigImage animated:YES completion:nil];
}


- (IBAction)seeBigImageButtonClick {
    [self seeBigImage];
}

- (void)setTopic:(BSTopic *)topic{
    _topic = topic;

    // 利用AFNetworking根据网络环境下载图片
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case 0:
                BSLog(@"无网络连接");
                break;
            case 1: // 蜂窝数据
                image = topic.smallImage;
                break;
            case 2: // WiFi
                image = topic.largeImage;
                break;
            default:
                NSLog(@"未知");
                break;
        }
        
    }];
    
    [self.manager startMonitoring];
    
    // 后缀名是否为gif
    self.gifView.hidden = !topic.is_gif;
/**
    NSString *extension = self.image.pathExtension.lowercaseString;
    if ([extension isEqualToString:@"gif"]) {
        self.gifView.hidden = NO;
    }else{
        self.gifView.hidden = YES;
    }
*/
    
    // 查看大图
    self.seeBigImageButton.hidden = !topic.isBigImage;
    // 大图只显示顶部
    if (topic.isBigImage) {
        self.imageView.contentMode = UIViewContentModeTop;
        // 检调多余部分
        self.imageView.clipsToBounds = YES;
    }else{
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.largeImage] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        self.placeholderView.hidden = NO;
        
        if (receivedSize < 0.0 || expectedSize < 0.0) {
            return;
        }
        
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        self.progressView.progress = progress;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        self.placeholderView.hidden = YES;
    }];
    
}

#pragma mark - 监听方法

@end
