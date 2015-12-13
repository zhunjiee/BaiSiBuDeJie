//
//  BSPostWordViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/13.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPostWordViewController.h"
#import "BSPlaceholderTextView.h"

@interface BSPostWordViewController () <UITextViewDelegate>
/** textView */
@property (nonatomic, weak) UITextView *textView;
@end

@implementation BSPostWordViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
    [self setUpTextView];
}

- (void)setUpTextView{
    BSPlaceholderTextView *textView = [[BSPlaceholderTextView alloc] init];
    
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。\n\n~亲，拖拽屏幕可退出键盘哦!~";
    
    textView.frame = self.view.bounds;
    
    textView.delegate = self;
    
    [self.view addSubview:textView];
    self.textView = textView;
}


- (void)setUpNav{
    // 设置按钮文字
    self.navigationItem.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(postWord)];
    // 设置文字颜色
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    // 强制更新
//    [self.navigationController.navigationBar layoutIfNeeded];
}


#pragma mark - 监听方法
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)postWord{
    BSLog(@"发表成功!");
}



#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
