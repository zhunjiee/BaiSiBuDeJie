//
//  BSCommentViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/27.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSCommentViewController.h"

@interface BSCommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputCommentView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputLabelBottom;

@end

@implementation BSCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    self.view.backgroundColor = BSGlobalColor;
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听方法
/**
 *  输入框跟随键盘移动
 *
 *  constant方式
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification{

    //键盘的Y值
    CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    // 输入框的位置 = 屏幕高度 - 键盘的Y值
    self.inputLabelBottom.constant = BSScreenH - keyboardY;
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  输入框跟随键盘移动
 *
 *  transform方式
 */
- (void)keyboardWillChangeFrame1:(NSNotification *)notification{
    
    //键盘的Y值
    CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    // 键盘的移动量 = 键盘的Y值 - 屏幕高度   (从下朝上,所以是负数)
    CGFloat transformY = keyboardY - BSScreenH;
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.inputCommentView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}





#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [self.view endEditing:YES];
}
#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
