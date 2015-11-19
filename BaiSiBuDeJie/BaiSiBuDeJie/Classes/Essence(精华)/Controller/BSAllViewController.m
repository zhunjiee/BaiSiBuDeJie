//
//  BSAllViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/10.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSAllViewController.h"
#import "BSHTTPSessionManager.h"
#import "BSTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "BSTopicCell.h"

@interface BSAllViewController ()
/** 请求管理者 */
@property (nonatomic, weak)  BSHTTPSessionManager *manager;
/** 保存帖子的数组 */
@property (nonatomic, strong) NSMutableArray *topicArray;
@end

@implementation BSAllViewController

static NSString * const BSCellID = @"topic";

#pragma mark - 懒加载
/** manager的懒加载 */
- (BSHTTPSessionManager *)manager{
    if (!_manager) {
        BSHTTPSessionManager *manager = [BSHTTPSessionManager manager];
        _manager = manager;
    }
    return _manager;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset = UIEdgeInsetsMake(BSNavMaxY + BSTitleViewH, 0, BSTabBarH, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTopicCell class]) bundle:nil] forCellReuseIdentifier:BSCellID];
    
    self.tableView.rowHeight = 200;
    
    [self loadNewTopics];
}

- (void)loadNewTopics{
    NSDictionary *params = @{
                             @"a" : @"list",
                             @"c" : @"data",
                             };
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        weakSelf.topicArray = [BSTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - Table View Date Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCellID forIndexPath:indexPath];
    cell.topic = self.topicArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
