//
//  BSEssenceViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSEssenceViewController.h"
#import "BSTagSubViewController.h"

@interface BSEssenceViewController ()

@end

@implementation BSEssenceViewController

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
    BSTagSubViewController *tagSub = [[BSTagSubViewController alloc] init];
    [self.navigationController pushViewController:tagSub animated:YES];
}

@end
