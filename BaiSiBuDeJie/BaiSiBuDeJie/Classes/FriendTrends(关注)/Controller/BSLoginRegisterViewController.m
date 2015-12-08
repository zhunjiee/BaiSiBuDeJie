//
//  BSLoginRegisterViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/5.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSLoginRegisterViewController.h"

@interface BSLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation BSLoginRegisterViewController

//  设置状态栏
- (void)viewDidLoad {
    [super viewDidLoad];

    [BSStatusBarViewController sharedStatusBarViewController].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
   [BSStatusBarViewController sharedStatusBarViewController].statusBarStyle = UIStatusBarStyleDefault;
}

/**
 *  注册或登录按钮被点击
 */
- (IBAction)loginOrRegister:(UIButton *)button {
    // 切换按钮
    button.selected = !button.isSelected;
    
    [self.view endEditing:YES];
    
    // 修改约束
    if (self.leftMargin.constant) {
        self.leftMargin.constant = 0;
    }else{
        self.leftMargin.constant = - self.view.width;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
