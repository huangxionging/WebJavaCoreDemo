//
//  TSWebViewController.m
//  WebJavaCoreDemo
//
//  Created by huangxiong on 2017/1/4.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "TSWebViewController.h"
#import <WebKit/WebKit.h>

@interface TSWebViewController ()<WKNavigationDelegate, WKUIDelegate>

/**
 url 地址
 */
@property (nonatomic, copy) NSString *url;

/**
 WKWebView
 */
@property (nonatomic, strong) WKWebView *webView;

/**
 是否加载完成
 */
@property (nonatomic, assign) BOOL isShowFinished;

@end

@implementation TSWebViewController

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
    self.isShowFinished = NO;
    
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
        _webView.UIDelegate = self;
    }
    return _webView;
}


- (void)back {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)close {
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    NSLog(@"%@", webView.URL.absoluteString);
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"%@", webView.URL.absoluteString);
    self.isShowFinished = YES;
    self.navigationItem.title = self.webView.title;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.isShowFinished) {
        NSLog(@"%@", navigationAction.request.URL.absoluteString);
        decisionHandler(WKNavigationActionPolicyCancel);
        TSWebViewController *webViewController = [[TSWebViewController alloc] initWithURL: navigationAction.request.URL.absoluteString];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: webViewController animated: YES];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    NSLog(@"%@", webView.URL.absoluteString);
    if (self.isShowFinished) {
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
//    if (self.isShowFinished) {
//        decisionHandler(WKNavigationResponsePolicyCancel);
//        TSWebViewController *webViewController = [[TSWebViewController alloc] initWithURL: navigationResponse.response.URL.absoluteString];
//        webViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController: webViewController animated: YES];
//    } else {
//        
//        decisionHandler(WKNavigationResponsePolicyAllow);
//        self.isShowFinished = YES;
//    }
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    
//    NSLog(@"%@", webView.URL.absoluteString);
    NSString *host = webView.URL.host;
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
//    NSLog(@"%@", webView.URL.absoluteString);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%@", webView.URL.absoluteString);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%@", webView.URL.absoluteString);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
//    NSLog(@"%@", webView.URL.absoluteString);
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
//    NSLog(@"%@", webView.URL.absoluteString);
}

#pragma mark- WKUIDelegate
#pragma mark - js allert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    
    // 警告框控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark- js 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self  presentViewController:alertController animated:YES completion:nil];
}

#pragma mark- 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self  presentViewController:alertController animated:YES completion:nil];
}

@end
