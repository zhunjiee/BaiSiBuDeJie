//
//  BSNewViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/1.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSNewViewController.h"

@interface BSNewViewController ()

@end

@implementation BSNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNav];
}

/**
 *  导航栏相关设置
 */
- (void)setUpNav{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(mainTagSubIconClick) normalImage:@"MainTagSubIcon" highlightImage:@"MainTagSubIconClick"];
}

- (void)mainTagSubIconClick{
    BSLogFunc;
}

@end
