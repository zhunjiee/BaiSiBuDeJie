//
//  BSRecommentViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/5.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSRecommentViewController.h"
#import <SVProgressHUD.h>

@interface BSRecommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;

@end

@implementation BSRecommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"推荐关注";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.usersTableView.contentInset = self.categoryTableView.contentInset = UIEdgeInsetsMake(BSNavMaxY, 0, 0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}
@end
