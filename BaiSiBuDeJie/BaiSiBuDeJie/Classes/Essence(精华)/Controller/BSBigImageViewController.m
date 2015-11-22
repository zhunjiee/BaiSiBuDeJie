//
//  BSBigImageViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/22.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSBigImageViewController.h"
#import <UIImageView+WebCache.h>
#import "BSTopic.h"

@interface BSBigImageViewController () <UIScrollViewDelegate>
/** 图片视图 */
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation BSBigImageViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpScrollView];
}

- (void)setUpScrollView{
    // 创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:scrollView atIndex:0];
    
    scrollView.delegate = self;
    
    // 创建imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.largeImage]];
    
    imageView.width = scrollView.width;
    imageView.height = imageView.width * self.topic.height / self.topic.width;
    imageView.x = 0;
    if (imageView.height >= scrollView.height) {
        imageView.y = 0;
    }else{
        imageView.centerY = scrollView.height * 0.5;
    }
    [scrollView addSubview:imageView];
    
    scrollView.contentSize = imageView.frame.size;
    CGFloat maxScale = self.topic.width / imageView.width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
    }
    
    self.imageView = imageView;
}


#pragma mark 监听方法
- (IBAction)save {
}


/**
 *  返回
 */
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

// 开始缩放的时候调用,频率很高
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if (self.imageView.height < [UIScreen mainScreen].bounds.size.height - 20) { // 20为状态的高度
        self.imageView.y = ([UIScreen mainScreen].bounds.size.height - 20 - self.imageView.height) * 0.5;
    }
}
@end
