//
//  BSSettingViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/8.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSSettingViewController.h"
#import "BSClearCachesCell.h"
#import <SVProgressHUD.h>
#import <SDImageCache.h>

@interface BSSettingViewController () <UITableViewDelegate>

@end

@implementation BSSettingViewController

static NSString * const BSClearCachesID = @"clearCaches";
static NSString * const BSOtherCellID = @"otherCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.navigationItem.title = @"设置";
    self.tableView.backgroundColor = BSGlobalColor;
    
    // 注册cell
    [self.tableView registerClass:[BSClearCachesCell class] forCellReuseIdentifier:BSClearCachesID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BSOtherCellID];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:BSClearCachesID forIndexPath:indexPath];
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSOtherCellID];
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd组--第%zd行", indexPath.section, indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /** -----删除缓存----- */
    if (indexPath.section == 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
            
            BSClearCachesCell *cell = (BSClearCachesCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell reset];
        }];
    }
}
@end
