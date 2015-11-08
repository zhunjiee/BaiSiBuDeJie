//
//  BSFriendTrendsViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/1.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSFriendTrendsViewController.h"
#import "BSRecommentViewController.h"

@interface BSFriendTrendsViewController ()

@end

@implementation BSFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
}

- (void)setUpNav{
    self.navigationItem.title = @"关注";
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(friendsRecommentClick) normalImage:@"friendsRecommentIcon" highlightImage:@"friendsRecommentIcon-click"];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)friendsRecommentClick{
    [self performSegueWithIdentifier:@"friendsTrendsToRecomment" sender:nil];
}

- (IBAction)backToFriendsTrendsViewController:(UIStoryboardSegue *)segue{
    BSLog(@"从%@控制器退出", segue.sourceViewController);
}

@end
