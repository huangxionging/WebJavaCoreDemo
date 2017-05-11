//
//  ViewController.m
//  WebJavaCoreDemo
//
//  Created by huangxiong on 2016/11/30.
//  Copyright © 2016年 huangxiong. All rights reserved.
//

#import "ViewController.h"
#import "TSWebViewController.h"
#import "TSSingleWebViewController.h"
#import "TSWebToNativeViewController.h"
#import "TSMainWebViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden: YES animated: YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self.navigationController.topViewController isEqual: self]) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)webToNative:(id)sender {
    TSWebToNativeViewController *webVC = [[TSWebToNativeViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: webVC animated: YES];
    
}

- (IBAction)multiWebViewController:(id)sender {
    
    TSMainWebViewController *webVC = [[TSMainWebViewController alloc] initWithURL: @"http://32teeth.cn/blog/index/index/tid/21"];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: webVC animated: YES];
}

- (IBAction)singleWebViewController:(id)sender {
    TSSingleWebViewController *webVC = [[TSSingleWebViewController alloc] initWithURL: @"http://dcloud.io/hellomui/"];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: webVC animated: YES];
}
@end
