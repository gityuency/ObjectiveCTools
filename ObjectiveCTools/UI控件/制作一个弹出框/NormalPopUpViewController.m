//
//  NormalPopUpViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/11/22.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "NormalPopUpViewController.h"
#import "MemoryView.h"
#import "BankCardListView.h"
#import "RebateTradingKeyBoardView.h"
#import "HomePagePopView.h"

@interface NormalPopUpViewController ()

@end

@implementation NormalPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


/// 弹框 首页弹框
- (IBAction)homePagePop:(UIButton *)sender {
    
    [HomePagePopView show:@"莣了噯" subTitle:@"莪庰騑別妩選萚，軹煶罘厢弌錯侢錯。" image:[UIImage imageNamed:@"忘了爱.jpg"] content:@"過祛锝憱穰τā過祛，曾俓滭竟枳褆曾俓。" click:^{
        
    } close:^{
        
    }];
}


/// 弹框 密码交易键盘
- (IBAction)tradingPwdView:(UIButton *)sender {
    [RebateTradingKeyBoardView showWith:@"主标题" sub:@"副标题" password:^(NSString *password) {
        
        NSLog(@"%@", password);
        
    } hiden:^{
        NSLog(@"隐藏键盘");
    } forget:^{
        NSLog(@"忘记密码");
    }];
}


/// 弹框 银行卡列表
- (IBAction)bankCardListPo:(UIButton *)sender {
    
    NSArray *array = @[@"工商银行", @"建设银行", @"招商银行", @"农业银行", @"上海银行", @"浦发银行", @"花旗银行", ];
    [BankCardListView showWith:@"这是标题" list:array selectIndex:^(NSInteger selectedIndex) {
        NSLog(@"选择 %ld", selectedIndex);
    } addNew:^{
        NSLog(@"添加新的银行");
    }];
    
}


/// 弹框 最简单的示例
- (IBAction)simplePopInstance:(UIButton *)sender {
    
    [MemoryView showWithAction:^(NSInteger index) {
        NSLog(@"回调");
    }];
}


@end
