//
//  TSMainWebViewController.h
//  Hydrodent
//
//  Created by huangxiong on 2017/1/4.
//  Copyright © 2017年 xiaoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSMainWebViewController : UIViewController

/**
 通过 URL 初始化

 @param url url 地址
 @return 返回的控制器对象
 */
- (instancetype)initWithURL: (NSString *)url;

@end
