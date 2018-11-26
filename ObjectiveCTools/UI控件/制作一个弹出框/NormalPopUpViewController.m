//
//  NormalPopUpViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/11/22.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "NormalPopUpViewController.h"
#import "MemoryView.h"

@interface NormalPopUpViewController ()

@end

@implementation NormalPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"点击空白区域";
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [MemoryView showWithAction:^(NSInteger index) {
        NSLog(@"回调");
    }];
    
}

@end
