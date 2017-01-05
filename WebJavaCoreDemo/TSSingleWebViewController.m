//
//  TSSingleWebViewController.m
//  WebJavaCoreDemo
//
//  Created by huangxiong on 2017/1/4.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "TSSingleWebViewController.h"
#import <WebKit/WebKit.h>
@interface TSSingleWebViewController ()<WKNavigationDelegate>

/**
 url 地址
 */
@property (nonatomic, copy) NSString *url;

/**
 WKWebView
 */
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TSSingleWebViewController

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview: self.webView];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle: @"关闭" style:UIBarButtonItemStylePlain target: self action: @selector(close)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle: @"返回" style:UIBarButtonItemStylePlain target: self action: @selector(back)];
    self.navigationItem.leftBarButtonItems = @[item2, item1];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    [self.webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: self.url]]];
}


- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.size.height -= 64;
        _webView = [[WKWebView alloc] initWithFrame: rect configuration: config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}


- (void)back {
    if (self.webView.backForwardList.backList.count == 0) {
        [self.navigationController popViewControllerAnimated: YES];
    } else {
        [self.webView goBack];
        self.navigationItem.title = self.webView.backForwardList.backItem.title;
    }
}

- (void)close {
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%@", webView.URL.absoluteString);
    self.navigationItem.title = self.webView.backForwardList.currentItem.title;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%@", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%@", webView.URL.absoluteString);
    NSString *host = webView.URL.host;
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}


@end
