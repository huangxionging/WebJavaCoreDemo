//
//  TSWebViewController.h
//  TSWeb
//
//  Created by huangxiong on 2017/5/12.
//  Copyright © 2017年 huangxiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWebView.h"
@interface TSWebViewController : UIViewController

/**
 TSWebView
 */
@property (nonatomic, strong, readonly) TSWebView *webView;

/**
 标题, 如果有就全部固定, 没有就加载网页本身的标题
 */
@property (nonatomic, copy) NSString *webTitle;

/**
 是否出现关闭按钮, 默认是 YES 
 */
@property (nonatomic, assign) BOOL isShowClose;

/**
 通过 URL 初始化
 
 @param url url 地址
 @return 返回的控制器对象
 */
- (instancetype)initWithURL: (NSString *)url;

@end
