//
//  BSPostWordViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/13.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPostWordViewController.h"
#import "BSPlaceholderTextView.h"
#import "BSPostWordToolbar.h"

@interface BSPostWordViewController () <UITextViewDelegate>
/** textView */
@property (nonatomic, weak) UITextView *textView;
/** 工具条 */
@property (nonatomic, weak) UIView *toolbar;
@end

@implementation BSPostWordViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
    
    [self setUpTextView];
    
    [self setUpToolbar];
}

/**
 *  设置工具条
 */
- (void)setUpToolbar{
    BSPostWordToolbar *toolbar = [BSPostWordToolbar loadViewFromXib];
    toolbar.width = self.view.width;
    toolbar.y = BSScreenH - toolbar.height;
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.view addSubview:toolbar];
    
    self.toolbar = toolbar;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    // 键盘弹出时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        CGFloat transformY = keyboardY - BSScreenH; // 上移所以是负数
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

/**
 *  设置文本视图,整个文本输入框视图
 */
- (void)setUpTextView{
    BSPlaceholderTextView *textView = [[BSPlaceholderTextView alloc] init];
    
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。\n\n~亲，拖拽屏幕可退出键盘哦!~";
    
    textView.frame = self.view.bounds;
    
#warning 竖直方向永远可以拖拽(滚动)
    textView.alwaysBounceVertical = YES; // 竖直方向永远可以拖拽(滚动)
//    textView.alwaysBounceHorizontal = YES; // 水平方向永远可以拖拽(滚动)
    
    textView.delegate = self;
    
    [self.view addSubview:textView];
    self.textView = textView;
}

/**
 *  设置导航栏
 */
- (void)setUpNav{
    // 设置按钮文字
    self.navigationItem.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(postWord)];
//    // 设置文字颜色
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    // 刚进入界面"发表"按钮无法点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // 强制更新
    [self.navigationController.navigationBar layoutIfNeeded];
}


#pragma mark - 监听方法
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)postWord{
    BSLog(@"发表成功!");
}



#pragma mark - 代理方法
// 根据有没有文字确定"发表按钮"是否可以点击
- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
    [self.view layoutIfNeeded];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
