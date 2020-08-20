//
//  TestViewController.m
//  SwiftDemo
//
//  Created by HouWan on 2020/8/20.
//  Copyright © 2020 HouWan. All rights reserved.
//

#import "TestViewController.h"
#import "SwiftDemo-Swift.h"

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/// 测试用例 1
- (void)test_get_a {
    NSString *url = @"http://game.gtimg.cn/images/lol/act/img/js/heroList/hero_list.js";
    NSDictionary *dict = @{@"v": @(33)};

    [HWNetworkingOC GET:url info:@"LOL英雄列表" parameters:dict success:^(id response) {
        NSLog(@"get --> %@", response);
    } failed:^(HWNetworkingError *error) {
        NSLog(@"xxx -> %@", error.localizedDescription);
    }];
}

/// 测试用例 2
- (void)test_post_a {
    NSString *url = @"https://api.sunpig.cn/member/myDetailsNew";
    NSDictionary *dict = @{@"userId": @"02363BC2523811E68BD95CB9018916241119"};

    [HWNetworkingOC POST:url info:@"我的页面" parameters:dict success:^(id response) {
        NSLog(@"post --> %@", response);
    } failed:^(HWNetworkingError *error) {
        NSLog(@"xxx -> %@", error.localizedDescription);
    }];
}

/// 测试用例 3
- (void)test_error_a {
    NSString *url = @"https://api.sunpig.cn/member/myDetailsNew";
    NSDictionary *dict = @{@"userId": @"123"};

    [HWNetworkingOC POST:url info:@"我的页面" parameters:dict success:^(id response) {
        NSLog(@"post --> %@", response);
    } failed:^(HWNetworkingError *error) {
        NSLog(@"xxx -> %@", error.localizedDescription);
    }];
}

/// 测试用例 3
- (void)test_error_b {
    NSString *url = @"https://api.sunpig.cn/member/myDetailsw";
    NSDictionary *dict = @{@"userId": @"123"};

    [HWNetworkingOC POST:url info:@"我的页面" parameters:dict success:^(id response) {
        NSLog(@"post --> %@", response);
    } failed:^(HWNetworkingError *error) {
        NSLog(@"xxx -> %@", error.localizedDescription);
    }];
}


@end
