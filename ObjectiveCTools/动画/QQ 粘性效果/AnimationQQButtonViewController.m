//
//  AnimationQQButtonViewController.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/6.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "AnimationQQButtonViewController.h"
#import "QQButton.h"
@interface AnimationQQButtonViewController ()

@end

@implementation AnimationQQButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    QQButton *b = [[QQButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    b.center = self.view.center;
    [self.view addSubview:b];
    
}


@end
