//
//  BSPostWordToolbar.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/12/14.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSPostWordToolbar.h"
#import "BSNavigationController.h"
#import "BSAddTagViewController.h"

@interface BSPostWordToolbar ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation BSPostWordToolbar

- (void)awakeFromNib{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    button.y = 4;
    [button sizeToFit];
    [self.topView addSubview:button];
    
    [button addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  我们是从PostWordController控制器再modal控制器,
 *  又因为PostWordController是由根控制器modal出来的,所以必须先拿到根控制器,
 *  再通过 .presentedViewController 方法才可以拿到PostWordController,之后再modal到新控制器
 *  这种做法遵从了MVC思想---view里不应该有控制器
 */
- (void)addButtonClick{
    BSAddTagViewController *addTag = [[BSAddTagViewController alloc] init];
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:addTag];
    
    // 拿到根控制器
    UIViewController *root = self.window.rootViewController;
    // 获取PostWordViewController
    UIViewController *postWord = root.presentedViewController;
    
    [postWord presentViewController:nav animated:YES completion:nil];
}
@end
