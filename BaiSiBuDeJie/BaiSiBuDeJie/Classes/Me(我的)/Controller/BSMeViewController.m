//
//  BSMeViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/1.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSMeViewController.h"

@interface BSMeViewController ()

@end

@implementation BSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithTarget:self action:@selector(settingButtonClick) normalImage:@"mine-setting-icon" highlightImage:@"mine-setting-icon-click"];
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithTarget:self action:nil normalImage:@"mine-moon-icon" highlightImage:@"mine-sun-icon-click"];
    
    self.navigationItem.rightBarButtonItems = @[item1, item2];
}

- (void)settingButtonClick{
    BSLogFunc;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
