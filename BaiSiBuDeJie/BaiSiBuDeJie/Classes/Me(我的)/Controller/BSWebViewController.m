//
//  BSWebViewController.m
//  BaiSiBuDeJie
//
//  Created by 侯宝伟 on 15/11/7.
//  Copyright © 2015年 ZHUNJIEE. All rights reserved.
//

#import "BSWebViewController.h"

@interface BSWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;

@end

@implementation BSWebViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)backward:(UIBarButtonItem *)sender {
    [self.webView goBack];
}
- (IBAction)forward:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.backward.enabled = webView.canGoBack;
    self.forward.enabled = webView.canGoForward;
}
@end
