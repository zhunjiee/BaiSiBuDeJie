//
//  BSTagSubViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTagSubViewController.h"
#import "BSHTTPSessionManager.h"
#import "BSTagSub.h"
#import "BSTagSubCell.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface BSTagSubViewController ()
/** 请求管理者 */
@property (nonatomic, weak) BSHTTPSessionManager *manager;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *tagSubArray;
@end

@implementation BSTagSubViewController

static NSString * const ID = @"tagCell";
#pragma mark - 懒加载
/** manager的懒加载 */
- (BSHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [BSHTTPSessionManager manager];
    }
    return _manager;
}
/** tagSubArray的懒加载 */
- (NSMutableArray *)tagSubArray{
    if (!_tagSubArray) {
        _tagSubArray = [NSMutableArray array];
    }
    return _tagSubArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTags];
    
    [self setUpTableView];
}

- (void)setUpTableView{
    self.tableView.backgroundColor = BSGlobalColor;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTagSubCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

- (void)loadTags{
    [SVProgressHUD show];
    
    NSDictionary *params = @{
                             @"a" : @"tag_recommend",
                             @"action" : @"sub",
                             @"c" : @"topic",
                             };
    
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        // 请求失败，关闭弹窗
        if (responseObject == nil) {
            [SVProgressHUD showErrorWithStatus:@"加载标签失败"];
            return;
        }
        
        weakSelf.tagSubArray = [BSTagSub objectArrayWithKeyValuesArray:responseObject];
        
        [weakSelf.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (error.code == NSURLErrorCancelled) {
            return;
        }else if (error.code == NSURLErrorTimedOut){
            [SVProgressHUD showErrorWithStatus:@"请求超时，请稍后再试"];
        }
        [SVProgressHUD showErrorWithStatus:@"加载标签失败"];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 隐藏弹框
    [SVProgressHUD dismiss];
    // 取消任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tagSubArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSTagSubCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.tagSub = self.tagSubArray[indexPath.row];
    
    return cell;
}


@end
