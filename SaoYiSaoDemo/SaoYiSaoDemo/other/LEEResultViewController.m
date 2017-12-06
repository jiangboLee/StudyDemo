//
//  LEEResultViewController.m
//  SaoYiSaoDemo
//
//  Created by ljb48229 on 2017/12/6.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

#import "LEEResultViewController.h"

@interface LEEResultViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@end

@implementation LEEResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:_webView];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
