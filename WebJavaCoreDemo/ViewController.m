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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)webToNative:(id)sender {
    TSWebToNativeViewController *webVC = [[TSWebToNativeViewController alloc] init];
    [self.navigationController pushViewController: webVC animated: YES];
    
}

- (IBAction)multiWebViewController:(id)sender {
    
    TSWebViewController *webVC = [[TSWebViewController alloc] initWithURL: @"https://wwww.baidu.com"];
    [self.navigationController pushViewController: webVC animated: YES];
}

- (IBAction)singleWebViewController:(id)sender {
    TSSingleWebViewController *webVC = [[TSSingleWebViewController alloc] initWithURL: @"https://wwww.baidu.com"];
    [self.navigationController pushViewController: webVC animated: YES];
}
@end
