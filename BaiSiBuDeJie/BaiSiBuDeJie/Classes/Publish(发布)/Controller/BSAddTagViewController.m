//
//  BSAddTagViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSAddTagViewController.h"

@interface BSAddTagViewController ()

@end

@implementation BSAddTagViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
}

- (void)setUpNav{
    self.navigationItem.title = @"添加标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClick)];
        
    // 强制更新
    [self.navigationController.navigationBar layoutIfNeeded];
}

#pragma maek - 监听方法
- (void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonClick{
    
}
@end
