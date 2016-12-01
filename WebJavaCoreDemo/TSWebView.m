//
//  TSWebView.m
//  WebJavaCoreDemo
//
//  Created by huangxiong on 2016/11/30.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import "TSWebView.h"

@interface TSWebView ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

/**
 *
 *  @brief js 消息处理回调字典
 *
 *  @since 1.0
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, void(^)(id)> *blockDictionary;

@end

@implementation TSWebView

#pragma mark- 初始化方法
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (self = [super initWithFrame:frame configuration:configuration]) {
    }
    return self;
}

#pragma mark- 默认方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        self.navigationDelegate = self;
        self.UIDelegate = self;
    }
    return self;
}

#pragma mark- blockDictionary
- (NSMutableDictionary<NSString *,void (^)(id)> *)blockDictionary {
    if (_blockDictionary == nil) {
        _blockDictionary = [NSMutableDictionary dictionaryWithCapacity: 10];
    }
    return _blockDictionary;
}

#pragma mark- 添加脚本消息处理的 block
- (void)addScriptMessageHandlerBlock:(void (^)(WKScriptMessage *))block name:(NSString *)name {
    
    if (block && name) {
        void (^temp)(id) = self.blockDictionary[name];
        if (temp != nil) {
            NSLog(@"name : %@, 已被注册, 请换个名字", name);
            return;
        }
        [self.blockDictionary setObject: block forKey: name];
        [self addScriptMessageHandler: self name: name];
    }
}

#pragma mark- 添加脚本处理的代理
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name {
    [self.configuration.userContentController addScriptMessageHandler: scriptMessageHandler name: name];
}

#pragma mark- 添加注入脚本
- (void)addUserScript:(WKUserScript *)userScript {
    [self.configuration.userContentController addUserScript: userScript];
}

#pragma mark- 删除注入脚本
- (void)removeAllUserScripts {
    [self.configuration.userContentController removeAllUserScripts];
}

#pragma mark- 删除脚本消息 handler 代理
-(void)removeScriptMessageHandlerForName:(NSString *)name {
    [self.configuration.userContentController removeScriptMessageHandlerForName: name];
}

#pragma mark- 脚本删除消息 handler 回调
- (void)removeScriptMessageHandlerBlockForName:(NSString *)name {
    if (self.blockDictionary[name]) {
        [self.blockDictionary removeObjectForKey: name];
        // 并删除脚本消息 handler 代理
        [self removeScriptMessageHandlerForName: name];
    }
}

#pragma mark- 删除所有的脚本消息 handler 回调
- (void)removeAllScriptMessageHandlerBlock {
    __weak typeof(self) weakSelf = self;
    [weakSelf.blockDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, void (^ _Nonnull obj)(id), BOOL * _Nonnull stop) {
        [weakSelf removeScriptMessageHandlerForName: key];
    }];
//    [self.blockDictionary removeAllObjects];
}

#pragma mark- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 通过消息的名字查询 block, 并传递消息
    void (^block)(WKScriptMessage *) = self.blockDictionary[message.name];
    if (block) {
        block(message);
    }
}

#pragma mark- 执行 JavaScript 代码
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    [super evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

#pragma mark- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
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
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    
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
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
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
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark---获取当前顶层视图控制器
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    // 获取住窗口
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    // 如果主窗口不是普通的窗口则执行if语句
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        // 遍历窗口找到窗口
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获得窗口的第一个子视图
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    // 先判断 UITransitionView
    NSString *classString = NSStringFromClass([frontView class]);
    if ([classString isEqualToString: @"UITransitionView"]) {
        NSLog(@"%@", frontView);
        if (frontView.subviews.count != 0) {
            frontView = frontView.subviews[0];
        }
    }
    
    // 得到其响应者
    id nextResponder = [frontView nextResponder];
    
    // 获取最上层的控制器
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    
    return result;
}

@end
