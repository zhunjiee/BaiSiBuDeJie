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
/** 加载下一组数据的参数 */
@property (nonatomic, copy) NSString *maxtime;
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

#pragma mark 初始化
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpRefresh];
}

- (void)setUpTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset = UIEdgeInsetsMake(BSNavMaxY + BSTitleViewH, 0, BSTabBarH, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTopicCell class]) bundle:nil] forCellReuseIdentifier:BSCellID];
    self.tableView.delegate = self;
    self.tableView.rowHeight = 400;
}


#pragma mark 设置数据
/**
 *  设置刷新
 */
- (void)setUpRefresh{
    // 下拉刷新 加载新数据
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
#warning 进入APP自动刷新
    [self.tableView.header beginRefreshing];
    
    // 刷新完后自动隐藏刷新控件
    self.tableView.header.automaticallyChangeAlpha = YES;
    
    
    // 上拉刷新 加载更多数据
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

/**
 *  加载新数据
 */
- (void)loadNewTopics{
    NSDictionary *params = @{
                             @"a" : @"list",
                             @"c" : @"data",
                             };
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        BSWriteToFile(responseObject, @"123");
        
        weakSelf.topicArray = [BSTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
#warning 获取哪些帖子有最热评论
//        NSArray *dictArray = responseObject[@"list"];
//        int i = 0;
//        for (NSMutableDictionary *dict in dictArray) {
//            NSArray *top_cmt = dict[@"top_cmt"];
//            if (top_cmt.count) {
//                BSLog(@"第%zd个帖子有最热评论", i);
//            }
//            i++;
//        }
        
        
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.tableView.header endRefreshing];
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreTopics{
    NSDictionary *params = @{
                             @"a" : @"list",
                             @"c" : @"data",
                             @"maxtime" : self.maxtime,
                             };
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf.topicArray addObjectsFromArray:[BSTopic objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
#warning 获取哪些帖子有最热评论
//        NSArray *dictArray = responseObject[@"list"];
//        int i = 0;
//        for (NSMutableDictionary *dict in dictArray) {
//            NSArray *top_cmt = dict[@"top_cmt"];
//            if (top_cmt.count) {
//                BSLog(@"第%zd个帖子有最热评论", i);
//            }
//            i++;
//        }
        
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.tableView.footer endRefreshing];
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

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSTopic *topic = self.topicArray[indexPath.row];
    return topic.cellHeight;
}
@end
