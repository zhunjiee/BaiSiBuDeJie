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
#import <SVProgressHUD.h>
#import <AssetsLibrary/AssetsLibrary.h> // iOS9.0以后彻底弃用
#import <Photos/Photos.h> // iOS8.0开始使用


@interface BSBigImageViewController () <UIScrollViewDelegate>
/** 图片视图 */
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation BSBigImageViewController

static NSString * const BSCollectionName = @"百思不得姐";

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
// 保存图片到相机胶卷
- (IBAction)save {
    // 0.判断状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        [SVProgressHUD showErrorWithStatus:@"没有访问相册的权限"];
        BSLog(@"用户拒绝当前应用访问相册,需要提醒用户打开允许访问开关");
    }else if (status == PHAuthorizationStatusRestricted) {
        BSLog(@"家长控制,不允许访问");
    }else if (status == PHAuthorizationStatusNotDetermined) {
        BSLog(@"用户还没有做出选择");
        [self saveImage];
    }else if (status == PHAuthorizationStatusAuthorized) {
        BSLog(@"用户允许当前应用访问相册");
        [self saveImage];
    }
}

/**
 *  返回相册,避免重复创建相册引起不必要的错误
 */
- (PHAssetCollection *)collection{
    // 先获得之前创建过的相册
    PHFetchResult *collectionResult =[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:BSCollectionName]) {
            return collection;
        }
    }
    
    // 如果相册不存在,就创建新的相册(文件夹)
    __block NSString *collectionID = nil; // __block作用:可以修改block外部的变量的值
    // 这个方法会在相册创建完毕后返回
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 新建一个PHAssetCollectionChangeRequest对象,用来创建一个新的相册
        collectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:BSCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionID] options:nil].firstObject;
}

/**
 *  保存图片到相册
 */
- (void)saveImage{
    /*
     PHAsset : 一个PHAsset对象就代表一个资源文件,比如一张图片
     PHAssetCollection : 一个PHAssetCollection对象就代表一个相册
     */
    
    __block NSString *assetID = nil;
    // 1. 存储图片到"相机胶卷"
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ // 这个block里保存一些"修改"性质的代码
        // 新建一个PHAssetCreationRequest对象,保存图片到"相机胶卷"
        // 返回PHAsset(图片资源)的字符串标识
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
        BSLog(@"%@", assetID);
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            BSLog(@"保存图片到相机胶卷中失败");
            return;
        }
        BSLog(@"成功保存图片到相机胶卷中");
        
        // 2. 获取相册对象
        PHAssetCollection *collection = [self collection];
        
        // 3. 将"相机胶卷"中的图片添加到新的相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            BSLog(@"%@", assetID);
            // 根据唯一标识获得相片对象
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil].firstObject;
            // 添加图片到相册中
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                BSLog(@"添加图片到相册中失败");
                      return;
            }
            
            BSLog(@"成功添加图片到相册中");
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }];
        }];
    }];
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
