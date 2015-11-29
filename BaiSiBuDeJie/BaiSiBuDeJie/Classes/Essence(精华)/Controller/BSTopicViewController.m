//
//  BSTopicViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/26.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSTopicViewController.h"
#import "BSHTTPSessionManager.h"
#import "BSTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "BSTopicCell.h"
#import "BSNewViewController.h"
#import "BSCommentViewController.h"

@interface BSTopicViewController ()
/** 请求管理者 */
@property (nonatomic, weak)  BSHTTPSessionManager *manager;
/** 保存帖子的数组 */
@property (nonatomic, strong) NSMutableArray *topicArray;
/** 加载下一组数据的参数 */
@property (nonatomic, copy) NSString *maxtime;
@end

@implementation BSTopicViewController

static NSString * const BSCellID = @"topic";

- (BSTopicType)type{
    return 0;
}

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
 *  设置请求参数
 */
- (NSString *)parameter{
// isKindOfClass:判断是否是 该类型 或者 该类型的子类
// isMemberOfClass:判断是否是 该类型
    if ([self.parentViewController isKindOfClass:[BSNewViewController class]]) {
        return @"newlist";
    }
    return @"list";
}

/**
 *  加载新数据
 */
- (void)loadNewTopics{
    NSDictionary *params = @{
                             @"a" : self.parameter,
                             @"c" : @"data",
                             @"type" : @(self.type)
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
                             @"a" : self.parameter,
                             @"c" : @"data",
                             @"maxtime" : self.maxtime,
                             @"type" : @(self.type)
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
/**
 *  返回每个cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSTopic *topic = self.topicArray[indexPath.row];
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BSCommentViewController *comment = [[BSCommentViewController alloc] init];
    
    comment.topic = self.topicArray[indexPath.row];
    
    [self.navigationController pushViewController:comment animated:YES];
}
@end
