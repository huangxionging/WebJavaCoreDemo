//
//  TSWebViewController.m
//  TSWeb
//
//  Created by huangxiong on 2017/5/12.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "TSWebViewController.h"
#import "TSWebView.h"

@interface TSWebViewController ()<WKNavigationDelegate, WKUIDelegate>
/**
 url 地址
 */
@property (nonatomic, copy) NSString *url;

/**
 进度条
 */
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation TSWebViewController

@synthesize webView = _webView;

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
        self.isShowClose = YES;
    }
    return self;
}

#pragma mark- webView 加载
- (TSWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.size.height -= 64;
        _webView = [[TSWebView alloc] initWithFrame: rect configuration: config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_webView addObserver: self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // scrollView
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 配置左上角按钮
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"web_back"] style:UIBarButtonItemStylePlain target: self action: @selector(back)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"web_close"] style:UIBarButtonItemStylePlain target: self action: @selector(close)];
    self.navigationItem.leftBarButtonItems = @[item1, item2];
    // 滑动手势
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    // 禁止关闭按钮
    if (self.isShowClose == NO) {
        self.navigationItem.leftBarButtonItems = @[item1];
    }
    
    [self.view addSubview: self.webView];
    // 加载网页地址
    [self.webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: self.url ? self.url : @""]]];
}

#pragma mark- 观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark- 进度条
- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 3)];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.backgroundColor = [UIColor blackColor];
        [self.view addSubview: _progressView];
    }
    return _progressView;
}

#pragma mark- 回退
- (void) back {
    if (self.webView.backForwardList.backList.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated: YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView goBack];
            self.navigationItem.title = self.webView.backForwardList.backItem.title;
        });
    }
}

#pragma mark- 关闭按钮点击事件
- (void)close {
    // 关闭导航栈所有网页页面
    for (UIViewController *viewController in [self.navigationController.viewControllers reverseObjectEnumerator]) {
        if (![viewController isKindOfClass: [TSWebViewController class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController: viewController animated: YES];
            });
            return;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.navigationItem.title = self.webView.title;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%@", navigationAction.request.URL.absoluteString);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSLog(@"%@", navigationAction.request.URL.absoluteString);
        decisionHandler(WKNavigationActionPolicyCancel);
        // 为什么写 [self class] 而不是 TSMainWebViewController?
        // 因为写 TSMainWebViewController 会限制扩展性, 当我们需要继承 TSMainWebViewController 来实现某些功能时, [self class]
        // 是 TSMainWebViewController 的子类, 仍然可以使用我们实现的某些功能.
        TSWebViewController *webViewController = [[[self class] alloc] initWithURL: navigationAction.request.URL.absoluteString];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: webViewController animated: YES];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    //    if (self.isShowFinished) {
    //        decisionHandler(WKNavigationResponsePolicyCancel);
    //    } else {
    //
    //    }
    
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


-(void)dealloc {
    NSLog(@"%@ 挂了....挂了", self);
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
    if (self.webView) {
        [self.webView removeObserver: self forKeyPath: @"estimatedProgress"];
    }
    
}

@end
