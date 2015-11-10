//
//  BSFooterView.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/7.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSFooterView.h"
#import "BSSquareButton.h"
#import "BSHTTPSessionManager.h"
#import <MJExtension.h>
#import "BSSquare.h"
#import <SVProgressHUD.h>
#import "BSWebViewController.h"

@interface BSFooterView ()
/** 请求管理者 */
@property (nonatomic, weak) BSHTTPSessionManager *manager;
/** 存放模型的数组 */
@property (nonatomic, strong) NSMutableArray *squareArray;
@end

@implementation BSFooterView
#pragma mark - 懒加载
/** manager的懒加载 */
- (BSHTTPSessionManager *)manager{
    if (!_manager) {
        BSHTTPSessionManager *manager = [BSHTTPSessionManager manager];
        _manager = manager;
    }
    return _manager;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [SVProgressHUD show];
        
        NSDictionary *params = @{
                                 @"a" : @"square",
                                 @"c" : @"topic",
                                 };
        BSWeakSelf;
        [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject == nil) {
                [SVProgressHUD showErrorWithStatus:@"哎呀,出错啦~~"];
            }
            // 字典数组 -> 模型数组
            weakSelf.squareArray = [BSSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            // 创建方块
            [weakSelf createSquares];
            
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:@"哎呀,出错啦~~"];
        }];
    }
    return self;
}




#define BSColumnCount 4 // 列数
/**
 *  创建方块(九宫格)
 */
- (void)createSquares{
    // 创建九宫格布局
    NSInteger count = self.squareArray.count;
    
    CGFloat buttonW = BSScreenW / BSColumnCount;
    CGFloat buttonH = buttonW + BSMargin;
    for (int i = 0; i < count; i++) {
        BSSquareButton *button = [BSSquareButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat col = i % BSColumnCount;
        CGFloat row = i / BSColumnCount;
        // 计算frame
        button.width = buttonW;
        button.height = buttonH;
        button.x = col * buttonW;
        button.y = row * buttonH;
        
        [self addSubview:button];
        
        [button addTarget:self action:@selector(squareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置数据
        button.square = self.squareArray[i];
        
        // --------设置footerView的高度 按钮才可以点击----------
        self.height = CGRectGetMaxY(button.frame);
        
        // 重新设置footerView才可以滚动
        UITableView *tableView = (UITableView *)self.superview;
        tableView.tableFooterView = self;
    }
}

/**
 *  方块按钮被点击时调用
 */
- (void)squareButtonClick:(BSSquareButton *)button{
    NSString *url = button.square.url;
    if ([url hasPrefix:@"mod://"]) {
        if ([url hasSuffix:@"BDJ_To_Check"]) {
            BSLog(@"跳转到Check控制器");
        } else if ([url hasSuffix:@"App_To_SearchUser"]) {
            BSLog(@"跳转到SearchUser控制器");
        }
    }else if ([url hasPrefix:@"http://"]){ // 利用webView展示网页
        // 获取当前页面所处的导航控制器
        UITabBarController *root = (UITabBarController *)self.window.rootViewController;
        UINavigationController *nav = root.selectedViewController;
        
        BSWebViewController *web = [[BSWebViewController alloc] init];
        web.url = url;
        web.navigationItem.title = button.square.name;
        
        [nav pushViewController:web animated:YES];
    }else{
        BSLog(@"其他");
    }
}

@end
