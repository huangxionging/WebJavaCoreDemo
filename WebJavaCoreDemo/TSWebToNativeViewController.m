//
//  TSWebToNativeViewController.m
//  WebJavaCoreDemo
//
//  Created by huangxiong on 2017/1/5.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import "TSWebToNativeViewController.h"
#import "TSWebView.h"

@interface TSWebToNativeViewController ()
@property (strong, nonatomic) TSWebView *webView;
@end

@implementation TSWebToNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview: self.webView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: @"http://32teeth.cn/index/test/close"]];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [self.webView loadRequest: request];
    
    __weak typeof(self) weakSelf = self;
    
    // 接收 js 调 oc 消息回调
    [weakSelf.webView addScriptMessageHandlerBlock:^(WKScriptMessage *message) {
        NSLog(@"%@ === %@", message, [message body]);
        
        // oc 调 js 代码 像写 fmdb 的 sql 语句
        NSString *jsFun = [NSString stringWithFormat:@"insertText('%@')", @"你好"];
        [weakSelf.webView evaluateJavaScript: jsFun completionHandler:^(id _Nullable dd, NSError * _Nullable error) {
            // 触发 js
            [weakSelf.webView evaluateJavaScript: @"changeClick()" completionHandler:^(id _Nullable dd, NSError * _Nullable error) {
                
            }];
        }];
        
        
    } name: @"TEETH"];
    
    // 添加 js 消息回调, 等待 js 调起原生
    [weakSelf.webView addScriptMessageHandlerBlock:^(WKScriptMessage *message) {
        // 触发 js/ 原生再次调 js
        [weakSelf.webView evaluateJavaScript: @"display_alert()" completionHandler:^(id obj, NSError * _Nullable error) {
            
        }];
    } name: @"xxx"];
    
    // 注入 js 代码 alert 会使用 TSWebView 中的 WKUIDelegate 加载
    [weakSelf.webView addUserScript: [[WKUserScript alloc] initWithSource: @"function display_alert(){window.alert('I am an alert box!!')}" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly: YES]];
    
    // 注入 js 代码 为网页添加内容
    [weakSelf.webView addUserScript: [[WKUserScript alloc] initWithSource: @"function insertText(strText){\
                                      var node = document.createElement('DIV');\
                                      var myNode = document.getElementById('textNode');\
                                      node.innerHTML = strText;\
                                      document.body.insertBefore(node,myNode);}"  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly: YES]];
    
    // 注入第三个 js 代码 当按钮点击的时候触发
    [weakSelf.webView addUserScript: [[WKUserScript alloc] initWithSource: @"function  changeClick(){\
                                      \
                                      window.webkit.messageHandlers.xxx.postMessage(999999);\
                                      }" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly: YES]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (TSWebView *)webView {
    if (_webView == nil) {
        CGRect rect = [UIScreen mainScreen].bounds;
        rect.size.height -= 64;
        _webView = [[TSWebView alloc] initWithFrame: rect];
    }
    return _webView;
}

- (void)dealloc {
    [_webView removeAllScriptMessageHandlerBlock];
    [_webView removeAllUserScripts];
    
}


@end
