//
//  BSPublishViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/3.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPublishViewController.h"
#import <POP.h>
#import "BSPublishButton.h"
#import "BSPostWordViewController.h"
#import "BSNavigationController.h"

@interface BSPublishViewController ()
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttonArray;
/** 标语 */
@property (nonatomic, weak) UIImageView *sloganView;
/** 动画时间 */
@property (nonatomic, strong) NSArray *times;
@end

@implementation BSPublishViewController

/** 动画的弹性参数 */
static CGFloat const BSSpringFactor = 10;
/** 动画之间的时间间隔 */
static CGFloat const BSDelayTime = 0.1;

#pragma mark - 懒加载
/** buttonArray的懒加载 */
- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
/** times的懒加载 */
- (NSArray *)times{
    if (!_times) {
        _times = @[
                   @(BSDelayTime * 5),
                   @(BSDelayTime * 3),
                   @(BSDelayTime * 4),
                   @(BSDelayTime * 2),
                   @(BSDelayTime * 0),
                   @(BSDelayTime * 3),
                   @(BSDelayTime * 6)
                   ];
    }
    return _times;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSlogan];
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    [self setUpButtonsWithImageArray:images titleArray:titles];
}

/**
 *  设置标语
 */
- (void)setUpSlogan{
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.centerX = BSScreenW * 0.5;
    sloganView.y = - BSScreenH * 0.15;
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;
    
    // 添加动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(BSScreenH * 0.15);
    // 设置时间
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    // 设置弹性系数
    anim.springSpeed = BSSpringFactor;
    anim.springBounciness = BSSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 恢复用户点击
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView.layer pop_addAnimation:anim forKey:nil];
}

/**
 *  设置按钮
 */
- (void)setUpButtonsWithImageArray:(NSArray *)images titleArray:(NSArray *)titles{
    // 禁止用户点击
    self.view.userInteractionEnabled = NO;
    
    // ----创建按钮----
    int columnCount = 3;
    CGFloat buttonW = BSScreenW / columnCount;
    CGFloat buttonH = buttonW;
    // 按钮的行数
    NSUInteger rows = (images.count + columnCount - 1) / columnCount;
    // 按钮的初始Y值
    CGFloat buttonsY = (BSScreenH - rows * buttonH) * 0.5;

    for (int i = 0; i < images.count; i++) {
        int col = i % columnCount;
        int row = i / columnCount;

        BSPublishButton *button = [[BSPublishButton alloc] init];
        button.width = buttonW;
        button.height = buttonH;
        button.x = col * buttonW;
        button.y = row * buttonH + buttonsY;
//        button.backgroundColor = BSRandomColor;
        button.tag = i;
        [self.view addSubview:button];
        [self.buttonArray addObject:button];
        
        // 设置数据
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        
        // 监听按钮点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        // 设置frame
        CGFloat buttonX = col * buttonW;
        CGFloat buttonY = buttonsY + row * buttonH;
        CGFloat buttonFromY = buttonY - BSScreenH; // 随便设置,只要在屏幕上面外面即可

        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonFromY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];

        // 设置时间
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        
        // 设置弹性系数
        anim.springSpeed = BSSpringFactor;
        anim.springBounciness = BSSpringFactor;
        
        [button pop_addAnimation:anim forKey:nil];
    }
}

/**
 *  关闭界面代码块
 *
 *  @param task 关闭界面后需要执行的任务(是否弹出新界面)
 */
- (void)closeWithTask:(void (^)())task{
    // 禁止点击
    self.view.userInteractionEnabled = NO;
    
    // -----按钮退出动画-----
    for (int i = 0; i < self.buttonArray.count; i++) {
        BSPublishButton *button = self.buttonArray[i];
        
        // 标语的退出动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anim.toValue = @(BSScreenH + button.height * 0.5);
        // 设置时间
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];

        [button.layer pop_addAnimation:anim forKey:nil];
    }
    
    
    // -----slogan退出动画-----
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(BSScreenH * 1.5); // 随便写,只要超过屏幕即可
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    // 动画完成销毁界面
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 关闭控制器
        [self dismissViewControllerAnimated:NO completion:nil];

#warning block需要执行的代码
        // 执行一段动画完毕后的代码
//        if (task) {
//            task();
//        }
        !task ? : task(); // 这样比较装逼
    }];
    
    [self.sloganView.layer pop_addAnimation:anim forKey:nil];
}

#pragma mark - 监听方法
/**
 *  按钮点击时调用
 *
 *  @param button 被点击的按钮
 */
- (void)buttonClick:(BSPublishButton *)button{
    [self closeWithTask:^{
        if (button.tag == 2) {
            BSPostWordViewController *postWord = [[BSPostWordViewController alloc] init];
            
            BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:postWord];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }else{
            BSLog(@"点击了%@", button.currentTitle);
        }
    }];
}

/**
 *  点击空白处调用
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeWithTask:nil];
}

/**
 *  点击取消按钮
 */
- (IBAction)cancelBtnClick {
    [self closeWithTask:nil];
}
@end
