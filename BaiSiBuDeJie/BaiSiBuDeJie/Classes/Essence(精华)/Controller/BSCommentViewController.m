//
//  BSCommentViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/27.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSCommentViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "BSTopic.h"
#import "BSComment.h"
#import "BSUser.h"
#import "BSHTTPSessionManager.h"
#import "BSCommentCell.h"
#import "BSCommentHeaderView.h"
#import "BSTopicCell.h"

@interface BSCommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputCommentView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputLabelBottom;
/** 请求管理者 */
@property (nonatomic, weak) BSHTTPSessionManager *manager;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotestComment;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *lastestComment;

/** 保存最热评论 */
@property (nonatomic, strong) id top_cmt;
@end

@implementation BSCommentViewController

static NSString * const BSCommentID = @"commentCell";
static NSString * const BSCommentHeaderID = @"header";

#pragma mark - 懒加载
/** manager的懒加载 */
- (BSHTTPSessionManager *)manager{
    if (!_manager) {
        BSHTTPSessionManager *manager= [BSHTTPSessionManager manager];
        _manager = manager;
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpTableView];
    
    [self setUpRefresh];
    [self loadNewComments];
    
    [self setUpTableHeaderView];
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setUpTableView{
#warning 估算cell的高度
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 70;
    
    // 注册cell
    [self.commentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSCommentCell class]) bundle:nil] forCellReuseIdentifier:BSCommentID];
    [self.commentTableView registerClass:[BSCommentHeaderView class] forHeaderFooterViewReuseIdentifier:BSCommentHeaderID];
}

- (void)setUpTableHeaderView{
#warning 加载顶部帖子内容(头部控件)
    // 处理模型数据,如果有最热评论,就清空最热评论,然后高度置为0,重新计算高度
    if (self.topic.top_cmt) {
        self.top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil; // 先清空模型,再高度置0,就可以重新计算cell的高度
        self.topic.cellHeight = 0;
    }
    
    UIView *headerView = [[UIView alloc] init];
    BSTopicCell *headerCell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BSTopicCell class]) owner:nil options:nil].firstObject;
    
    headerCell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topic.cellHeight);
    
    // 传递模型设置数据
    headerCell.topic = self.topic;
    
    [headerView addSubview:headerCell];
    
    // 设置headerView的高度
    headerView.height = headerCell.height + BSMargin;
    
    self.commentTableView.tableHeaderView = headerView; // 由于系统会反复调用BSTopicCell的setFrame方法，cell的frame被我们重写为调用一次就减小10，所以采用嵌套，调用headerView的就没关系了
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 将最热评论还原重新计算外面的cell的高度
    if (self.top_cmt) {
        self.topic.top_cmt = self.top_cmt;
        self.topic.cellHeight = 0;
    }
    
}

#pragma mark 设置数据
/**
 *  设置刷新
 */
- (void)setUpRefresh{
    // 下拉刷新 加载新数据
    self.commentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    
#warning 进入APP自动刷新
    [self.commentTableView.header beginRefreshing];
    
    // 刷新完后自动隐藏刷新控件
//    self.commentTableView.header.automaticallyChangeAlpha = YES;
    
    
    // 上拉刷新 加载更多数据
    self.commentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}



/**
 *  加载新数据
 */
- (void)loadNewComments{
    // 取消上次请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSDictionary *params = @{
                             @"a" : @"dataList",
                             @"c" : @"comment",
                             @"data_id" : self.topic.ID,
                             @"hot" : @"1"
                             };
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        BSWriteToFile(responseObject, @"123");
        
        // 有数据服务器返回字典,没有数据服务器会返回数组(空数组),直接返回
        if ([responseObject isKindOfClass:[NSArray class]]) {
            // 没有数据,结束刷新,直接返回
            [weakSelf.commentTableView.header endRefreshing];
            return;
        }

        weakSelf.lastestComment = [BSComment objectArrayWithKeyValuesArray:responseObject[@"data"]];

        weakSelf.hotestComment = [BSComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];

        [weakSelf.commentTableView reloadData];
        
        // 判断数据是否全部加载
        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.lastestComment.count == total) {
            weakSelf.commentTableView.footer.hidden = YES;
        }
        
        [weakSelf.commentTableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.commentTableView.header endRefreshing];
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreComments{
    // 取消上次请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    BSComment *lastComment = (BSComment *)self.lastestComment.lastObject;
    NSDictionary *params = @{
                             @"a" : @"dataList",
                             @"c" : @"comment",
                             @"data_id" : self.topic.ID,
                             @"lastcid" : lastComment.ID,
                             };
    BSWeakSelf;
    [self.manager GET:BSBaseURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 没有数据服务器会返回空数组,直接返回
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf.commentTableView.header endRefreshing];
            return;
        }

        
        [weakSelf.lastestComment addObjectsFromArray:[BSComment objectArrayWithKeyValuesArray:responseObject[@"data"]]];
        
        [weakSelf.commentTableView reloadData];
        
        // 判断数据是否全部加载
        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.lastestComment.count == total) {
            weakSelf.commentTableView.footer.hidden = YES;
        }
        
        [weakSelf.commentTableView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.commentTableView.footer endRefreshing];
    }];
}

#pragma mark - 监听方法
/**
 *  输入框跟随键盘移动
 *
 *  constant方式
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification{

    //键盘的Y值
    CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    // 输入框的位置 = 屏幕高度 - 键盘的Y值
    self.inputLabelBottom.constant = BSScreenH - keyboardY;
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  输入框跟随键盘移动
 *
 *  transform方式
 */
- (void)keyboardWillChangeFrame1:(NSNotification *)notification{
    
    //键盘的Y值
    CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    // 键盘的移动量 = 键盘的Y值 - 屏幕高度   (从下朝上,所以是负数)
    CGFloat transformY = keyboardY - BSScreenH;
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.inputCommentView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}





#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.hotestComment.count) return 2;
    if (self.lastestComment.count) return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.hotestComment.count && section == 0) {
        return self.hotestComment.count;
        
    }
    return self.lastestComment.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCommentID];
    
    // 设置数据
    if (self.hotestComment.count && indexPath.section == 0) {
        cell.comment = self.hotestComment[indexPath.row];
    }else{
        cell.comment = self.lastestComment[indexPath.row];
    }
    
    return cell;
}


#pragma mark - 代理方法

#warning 自定义header视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BSCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BSCommentHeaderID];
    
    if (self.hotestComment.count && section == 0) {
        headerView.text = @"最热评论";
    }else{
        headerView.text = @"最新评论";
    }
    
    return headerView;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [self.view endEditing:YES];
}
@end
