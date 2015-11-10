//
//  BSRecommentViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/5.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSRecommentViewController.h"
#import <SVProgressHUD.h>
#import "BSHTTPSessionManager.h"
#import "BSRecommendCategory.h"
#import "BSRecommendUsers.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "BSRecommendCategoryCell.h"
#import "BSRecommendUsersCell.h"

@interface BSRecommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
/** 请求管理者 */
@property (nonatomic, weak) BSHTTPSessionManager *manager;
/** 分类数组 */
@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation BSRecommentViewController
// 通过storyboard创建的cell不需要注册
static NSString * const BSCategoryID = @"categoryCell";
static NSString * const BSUsersID = @"usersCell";


#pragma mark - 懒加载
/** manager的懒加载 */
- (BSHTTPSessionManager*)manager{
    if (!_manager) {
        BSHTTPSessionManager *manager = [BSHTTPSessionManager manager];
        _manager = manager;
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetUpTableView];
    
    [self loadCategory];

    [self setUpRefresh];
}

- (void)SetUpTableView{
    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = BSGlobalColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(BSNavMaxY, 0, 0, 0);
    self.usersTableView.separatorInset = self.categoryTableView.separatorInset = self.usersTableView.contentInset = self.categoryTableView.contentInset;
    self.usersTableView.rowHeight = 70;
}

- (void)setUpRefresh{
    self.usersTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    self.usersTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

#pragma mark - 加载数据
/**
 *  加载分类数据
 */
- (void)loadCategory{
    [SVProgressHUD show];
    NSDictionary *params = @{
                             @"a" : @"category",
                             @"c" : @"subscribe",
                             };
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        BSWriteToFile(responseObject, @"123");
        
        if (responseObject == nil) {
            [SVProgressHUD showErrorWithStatus:@"哎呀,出错啦~"];
        }
        
        weakSelf.categories = [BSRecommendCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [weakSelf.categoryTableView reloadData];
        
        [SVProgressHUD dismiss];
        
#pragma mark - 默认选中第一个
        [weakSelf.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 让右边推荐用户表格进入刷新
        [weakSelf.usersTableView.header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"哎呀,出错啦~"];
    }];
}

/**
 *  下拉加载推荐用户数据
 */
- (void)loadNewUsers{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 当前 左边分类 选中行 的 模型
    BSRecommendCategory *categorySelRow = self.categories[self.categoryTableView.indexPathForSelectedRow.row];

    NSDictionary *params = @{
                             @"a" : @"list",
                             @"c" : @"subscribe",
                             @"category_id" : categorySelRow.ID,
                             };
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
#pragma mark - 放在这里是为了防止刷新失败页码还会加1的bug
        categorySelRow.page = 1;
        
        // 将 模型 存入类别选中行的用户
        // 字典数组 -> 模型数组
        categorySelRow.users = [BSRecommendUsers objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 推荐用户总数
        categorySelRow.total = [responseObject[@"total"] integerValue];
        
        [weakSelf.usersTableView reloadData];
        
        [weakSelf.usersTableView.header endRefreshing];
        
        // 判断是否是最后一组数据
        if (categorySelRow.users.count == categorySelRow.total) {
            weakSelf.usersTableView.footer.hidden = YES;
        }else{
            [weakSelf.usersTableView.footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.usersTableView.header endRefreshing];
    }];
}

/**
 *  上拉加载更多推荐用户数据
 */
- (void)loadMoreUsers{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 当前 左边分类 选中行 的 模型
    BSRecommendCategory *categorySelRow = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    
    NSInteger page = categorySelRow.page + 1;
    
    NSDictionary *params = @{
                             @"a" : @"list",
                             @"c" : @"subscribe",
                             @"category_id" : categorySelRow.ID,
                             @"page" : @(page),
                             };
    
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        categorySelRow.page = page;
        
#pragma mark - 数组后面追加数据,而不是覆盖数据
        [categorySelRow.users addObjectsFromArray:[BSRecommendUsers objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        [weakSelf.usersTableView reloadData];
        
        categorySelRow.total = [responseObject[@"total"] integerValue];
        
        // 判断是否是最后一组数据
        if (categorySelRow.users.count == categorySelRow.total) {
            weakSelf.usersTableView.footer.hidden = YES;
        }else{
            [weakSelf.usersTableView.footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.usersTableView.footer endRefreshing];
    }];
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) {
        return self.categories.count;
    }else{
        BSRecommendCategory *categorySelRow = self.categories[self.categoryTableView.indexPathForSelectedRow.row];

        return categorySelRow.users.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        BSRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCategoryID];
        cell.category = self.categories[indexPath.row];
        
        return cell;
    }else{
        BSRecommendUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:BSUsersID];
        
        BSRecommendCategory *categorySelRow = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        
        cell.user = categorySelRow.users[indexPath.row];
        return cell;
    }
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击左边,刷新右边
    if (tableView == self.categoryTableView) {
        BSRecommendCategory *categorySelRow = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        
        if (categorySelRow.users.count == 0) {
            
#pragma mark - 在这里明显的取消一下上次请求，避免数据加载很慢还没有刷新出来就点击了别的按钮出现bug
            [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
            
            [self.usersTableView.header beginRefreshing];
        }
        
        [self.usersTableView reloadData];
    }
}
@end
