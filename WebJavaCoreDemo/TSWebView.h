//
//  TSWebView.h
//  WebJavaCoreDemo
//
//  Created by huangxiong on 2016/11/30.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface TSWebView : WKWebView


/**
 默认初始化方法

 @param frame frame 尺寸
 @return webView 对象
 */
- (instancetype)initWithFrame:(CGRect)frame;


/**
 自己配置 configuration 最好为 configuration 添加 userContentController 属性, 以接收 JavaScript 消息

 @param frame frame 尺寸
 @param configuration 配置描述
 @return webView 对象
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;


/**
 添加脚本消息 block 回调

 @param block 脚本消息回调
 @param name name 监听名字
 */
- (void)addScriptMessageHandlerBlock:(void(^)(WKScriptMessage *message)) block name:(NSString *) name;


/**
 自己添加脚本消息处理 handler, 其实就是调用了 WKUserContentController 的同名方法
 [self.configuration.userContentController addScriptMessageHandler: self name: name];
 
 @param scriptMessageHandler scriptMessageHandler 需实现 WKScriptMessageHandler 协议
 @param name 监听的名字
 */
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;


/**
 注入脚本, 调用了 WKUserContentController 的同名方法;

 @param userScript 用户注入的脚本
 */
- (void)addUserScript:(WKUserScript *)userScript;


/**
 删除所有注入的脚本, 调用了 WKUserContentController 的同名方法;
 */
- (void)removeAllUserScripts;


/**
 删除消息处理 handler 的代理, 不要乱删哦.

 @param name 被监听的名称
 */
- (void)removeScriptMessageHandlerForName:(NSString *)name;


/**
 删除消息处理 handler 的 block 回调

 @param name 被监听的名称
 */
- (void)removeScriptMessageHandlerBlockForName:(NSString *)name;


/**
 删除所有脚本消息 handler 回调
 */
- (void)removeAllScriptMessageHandlerBlock;


/**
 声明一下, 其实和父类方法一样

 @param javaScriptString js脚本
 @param completionHandler 完成回调
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

@end
