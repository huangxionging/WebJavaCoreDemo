//
//  TSMainWebViewController.m
//  Hydrodent
//
//  Created by huangxiong on 2017/1/4.
//  Copyright © 2017年 xiaoli. All rights reserved.
//

#import "TSMainWebViewController.h"
#import <WebKit/WebKit.h>


@interface TSMainWebViewController ()<WKNavigationDelegate, WKUIDelegate>

/**
 url 地址
 */
@property (nonatomic, copy) NSString *url;

/**
 memberId
 */
@property (nonatomic, copy) NSString *memberId;

/**
 token
 */
@property (nonatomic, copy) NSString *token;

/**
 WKWebView
 */
@property (nonatomic, strong) WKWebView *webView;

/**
 是否加载完成
 */
@property (nonatomic, assign) BOOL isShowFinished;

@end

@implementation TSMainWebViewController

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview: self.webView];
    self.isShowFinished = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"web_close"] style:UIBarButtonItemStylePlain target: self action: @selector(close)];
    UIBarButtonItem *iyem1 = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"web_back"] style:UIBarButtonItemStylePlain target: self action: @selector(back)];
    self.navigationItem.leftBarButtonItems = @[iyem1, item];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    [self.webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: self.url]]];
}

- (void)back {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)close {
    [self.navigationController popToRootViewControllerAnimated: YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)token {
    return @"88888888";
}

- (NSString *)memberId {
    return @"";
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.isShowFinished = YES;
    self.navigationItem.title = self.webView.title;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (self.isShowFinished) {
        NSLog(@"%@", navigationAction.request.URL.absoluteString);
        decisionHandler(WKNavigationActionPolicyCancel);
        // 为什么写 [self class] 而不是 TSMainWebViewController?
        // 因为写 TSMainWebViewController 会限制扩展性, 当我们需要继承 TSMainWebViewController 来实现某些功能时, [self class]
        // 是 TSMainWebViewController 的子类, 仍然可以使用我们实现的某些功能.
        TSMainWebViewController *webViewController = [[[self class] alloc] initWithURL: navigationAction.request.URL.absoluteString];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: webViewController animated: YES];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    if (self.isShowFinished) {
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%@", webView.URL.absoluteString);
//    NSString *host = webView.URL.host;
    
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
#pragma mark- WKUIDelegate
#pragma mark - js allert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    
    // 警告框控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self  presentViewController:alertController animated:YES completion:nil];
    
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



@end
