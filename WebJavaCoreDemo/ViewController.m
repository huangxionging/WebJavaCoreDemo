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
    
    TSWebViewController *webVC = [[TSWebViewController alloc] initWithURL: @"http://32teeth.cn/doctor/api/dump?uid=40f595d7a10fbdeef11280cca5837bc8&token=eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiI0MGY1OTVkN2ExMGZiZGVlZjExMjgwY2NhNTgzN2JjODE0ODM3NzQzMzYyNDAifQ.msGcbLtpnGO5qgXp97-roR6RreOYTxK7Ghvz7UFLqsxCptFSjzN2MNF0KV2k0lzPiZgan54Cw1_zq_rIMuHZaQ&x=22.52547611720078&y=113.9179266966234&url=https%3A%2F%2F32teeth.cn%2Fdoctor%2Ffamily%2Fuserlist.html&removetitle=1"];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: webVC animated: YES];
}

- (IBAction)singleWebViewController:(id)sender {
    TSSingleWebViewController *webVC = [[TSSingleWebViewController alloc] initWithURL: @"http://32teeth.cn/doctor/api/dump?uid=40f595d7a10fbdeef11280cca5837bc8&token=88888888&x=22.55160361751236&y=113.9475423792024&url=https://32teeth.cn/mall/ads/index&removetitle=1"];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: webVC animated: YES];
}
@end
