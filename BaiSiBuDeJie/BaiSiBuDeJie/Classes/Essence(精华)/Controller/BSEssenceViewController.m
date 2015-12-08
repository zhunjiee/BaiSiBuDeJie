//
//  BSEssenceViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/4.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSEssenceViewController.h"
#import "BSTagSubViewController.h"
#import "BSAllViewController.h"
#import "BSVideoViewController.h"
#import "BSVoiceViewController.h"
#import "BSPictureViewController.h"
#import "BSWordViewController.h"
#import "BSTitleButton.h"

@interface BSEssenceViewController () <UIScrollViewDelegate>
/** 被选中的按钮 */
@property (nonatomic, strong) BSTitleButton *selectedButton;
/** 按钮指示器 */
@property (nonatomic, weak) UIView *titleIndicatorView;
/** 滚动视图 */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题滚动视图 */
@property (nonatomic, weak) UIScrollView *titleScroll;
/** 存放titleButton的数组 */
@property (nonatomic, strong) NSMutableArray *titleButtonArray;
@end

@implementation BSEssenceViewController
#pragma mark - 懒加载
/** titleButtonArray的懒加载 */
- (NSMutableArray *)titleButtonArray{
    if (!_titleButtonArray) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
    
    [self setUpChildViewControllers];
    
    [self setUpScrollView];
    
    [self setUpTitleView];
    
    [self addChildVCView];
}

/**
 *  添加子控制器
 */
- (void)setUpChildViewControllers{
    BSAllViewController *all = [[BSAllViewController alloc] init];
    all.title = @"全部";
    [self addChildViewController:all];
    
    BSPictureViewController *picture = [[BSPictureViewController alloc] init];
    picture.title = @"图片";
    [self addChildViewController:picture];
    
    BSVideoViewController *video = [[BSVideoViewController alloc] init];
    video.title = @"视频";
    [self addChildViewController:video];
    
    BSVoiceViewController *voice = [[BSVoiceViewController alloc] init];
    voice.title = @"音频";
    [self addChildViewController:voice];
    
    BSWordViewController *word = [[BSWordViewController alloc] init];
    word.title = @"段子";
    [self addChildViewController:word];
    
    UIViewController *add = [[UIViewController alloc] init];
    add.title = @"更多+";
    [self addChildViewController:add];
}

/**
 *  导航栏相关设置
 */
- (void)setUpNav{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(mainTagSubIconClick) normalImage:@"MainTagSubIcon" highlightImage:@"MainTagSubIconClick"];
}

/**
 *  添加滚动视图
 */
- (void)setUpScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.frame;
    scrollView.backgroundColor = BSGlobalColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.view.width * self.childViewControllers.count, 0);
    
    scrollView.pagingEnabled = YES;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    // 这种一次性加载的方式不利于性能优化,而且也不科学,谁说一定都是tableViewController呢?
//    for (int i = 0; i < self.childViewControllers.count; i++) {
//        UITableViewController *vc = self.childViewControllers[i];
//        vc.tableView.frame = CGRectMake(scrollView.width * i, 0, scrollView.width, scrollView.height);
//        // 设置内边距
//        vc.tableView.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
//        vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
//        
//        [scrollView addSubview:vc.view];
//    }
}

#define titleButtonW (self.view.width / 4)  // 标题按钮的宽度
/**
 *  添加标题视图
 */
- (void)setUpTitleView{
    
    // ---创建titleScrollView
    UIScrollView *titleScroll = [[UIScrollView alloc] init];
    titleScroll.backgroundColor = BSColor(255, 255, 255, 50);
    titleScroll.frame = CGRectMake(0, BSNavMaxY, self.view.width, BSTitleViewH);
    titleScroll.showsHorizontalScrollIndicator = NO;
    titleScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:titleScroll];
    
//    CGFloat titleButtonW = self.view.width / 4;
    NSInteger count = self.childViewControllers.count;
    
    titleScroll.contentSize = CGSizeMake(titleButtonW * count, 0);
    
    
    // ---创建titleView用于存放titleButton
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, titleButtonW * count, BSTitleViewH);
    [titleScroll addSubview:titleView];
    self.titleScroll = titleScroll;
    
    // ---创建并添加titleButton到titleView
    for (int i = 0; i < count; i++) {
        BSTitleButton *titleButton = [BSTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleButtonW * i, 0, titleButtonW, BSTitleViewH);
        titleButton.tag = i;
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleButton setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        // 设置按钮颜色,selected方式切换按钮颜色
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

        [titleView addSubview:titleButton];
        
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleButtonArray addObject:titleButton];
    }
    
    
    // ---添加底部指示器
    UIView *titleIndicatorView = [[UIView alloc] init];
    BSTitleButton *firstTitleButton = titleView.subviews.firstObject;
    // 默认第一个按钮是被选中的,所以直接设置指示器颜色为第一个按钮选中状态的颜色即可
    titleIndicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    // 设置frame
    titleIndicatorView.height = 1;
    titleIndicatorView.width = firstTitleButton.width -  4 * BSMargin;
    titleIndicatorView.centerX = firstTitleButton.centerX;
    titleIndicatorView.y = firstTitleButton.height - titleIndicatorView.height;
    [titleView addSubview:titleIndicatorView];
    self.titleIndicatorView = titleIndicatorView;
    
    
    // 默认选中第一个
    firstTitleButton.selected = YES;
    self.selectedButton = firstTitleButton;
}

#pragma mark - 监听方法
- (void)titleButtonClick:(BSTitleButton *)titleButton{
#warning 监听titleButton重复点击
    if (self.selectedButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BSTitleButtonDidRepeatClickNotification object:nil];
    }
    
    [self dealingTitleButtonClick:titleButton];
}

- (void)dealingTitleButtonClick:(BSTitleButton *)titleButton{
    // 设置被选中按钮
    // 让以前被选中的按钮恢复默认状态(取消选中)
    self.selectedButton.selected = NO;
    // 让现在被点击的按钮变成选中状态(改变颜色)
    titleButton.selected = YES;
    // 被点击的标题按钮 变成 选中状态的按钮
    self.selectedButton = titleButton;
    
    // 指示器跟随移动
    [UIView animateWithDuration:0.25 animations:^{
        self.titleIndicatorView.centerX = titleButton.centerX;
    }];
    
    // 滚动到指定视图
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)mainTagSubIconClick{
    BSTagSubViewController *tagSub = [[BSTagSubViewController alloc] init];
    [self.navigationController pushViewController:tagSub animated:YES];
}

#pragma mark - 添加子控制器视图
/**
 *  根据scrollView的偏移量添加对应子控制器的view
 */
- (void)addChildVCView{
    // 计算索引
    int index = self.scrollView.contentOffset.x / self.scrollView.width;
    
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 判断view是否已经存在
//    if (willShowVc.view.superview) return;
//    if (willShowVc.view.window) return;
    if (willShowVc.isViewLoaded) return;
    
    [self.scrollView addSubview:willShowVc.view];
    
//    willShowVc.view.frame = CGRectMake(self.scrollView.width * index, 0, self.scrollView.width, self.scrollView.height);
    // 写成下面这种比较装逼
    willShowVc.view.frame = self.scrollView.bounds;
}

#pragma mark - UIScrollViewDelegate
/**
 *  停止减速(人为拖拽)的时候加载子控制器view
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 凡是牵扯到tag=0的我们就不要用 viewWithTag: 了,因为可能直接返回view自己,导致报错,所以我们还是老实的通过计算索引来拿到titleButton吧
    // 计算索引
    int index = self.scrollView.contentOffset.x / self.scrollView.width;
    BSTitleButton *titleButton = self.titleButtonArray[index];
    [self dealingTitleButtonClick:titleButton];
    
    [self addChildVCView];
    
    
#warning 判断标题滚动视图是否要自动滚动
    if (self.selectedButton.x + titleButtonW > BSScreenW) {
        CGFloat offsetX = self.selectedButton.x + titleButtonW - BSScreenW;
        
        [self.titleScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else{
        [self.titleScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

/**
 *  通过 setContentOffset: animated: 方法让scrollView进行了滚动动画,在动画停止时会调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self addChildVCView];
}

@end
