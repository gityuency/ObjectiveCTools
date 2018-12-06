//
//  TradingkeyBoardViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/6.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "TradingkeyBoardViewController.h"
#import "RebateTradingKeyBoardView.h"

@interface TradingkeyBoardViewController ()

@end

@implementation TradingkeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击屏幕";
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [RebateTradingKeyBoardView showWith:@"主标题" sub:@"副标题" password:^(NSString *password) {
        
        NSLog(@"%@", password);
        
    } hiden:^{
        NSLog(@"隐藏键盘");
    } forget:^{
        NSLog(@"忘记密码");
    }];
}

@end
