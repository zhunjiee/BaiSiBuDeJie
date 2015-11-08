//
//  BSMeViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/1.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSMeViewController.h"
#import "BSMeCell.h"
#import "BSFooterView.h"
#import "BSSettingViewController.h"

@interface BSMeViewController ()

@end

@implementation BSMeViewController

static NSString *const BSMeID = @"me";

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    
    [self setUpTableView];
}

- (void)setUpTableView{
    self.tableView.backgroundColor = BSGlobalColor;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = BSMargin;
    
    self.tableView.contentInset = UIEdgeInsetsMake(BSMargin - BSFirstCellTopY, 0, 0, 0);
    [self.tableView registerClass:[BSMeCell class] forCellReuseIdentifier:BSMeID];
    
    // 设置底部footerView
    self.tableView.tableFooterView = [[BSFooterView alloc] init];
}

- (void)setUpNav{
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithTarget:self action:@selector(settingButtonClick) normalImage:@"mine-setting-icon" highlightImage:@"mine-setting-icon-click"];
    
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithTarget:self action:@selector(moonButtonClick:) normalImage:@"mine-moon-icon" selImage:@"mine-sun-icon-click"];
    
    self.navigationItem.rightBarButtonItems = @[item1, item2];
}

#pragma mark - 监听方法
- (void)moonButtonClick:(UIButton *)button{
    button.selected = !button.isSelected;
}

- (void)settingButtonClick{
    BSSettingViewController *setting = [[BSSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setting animated:YES];
}

#pragma mark - Table View Controller Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSMeCell *cell = [tableView dequeueReusableCellWithIdentifier:BSMeID];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录/注册";
    }else{
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}

// 选中cell后立即取消选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
