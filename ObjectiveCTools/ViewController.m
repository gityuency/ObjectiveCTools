//
//  ViewController.m
//  ObjectiveCTools
//
//  Created by ChinaRapidFinance on 2018/7/31.
//  Copyright © 2018年 ChinaRapidFinance. All rights reserved.
//

#import "ViewController.h"
#import "UIView+DotterLine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 160, 200, 2)];
    [self.view addSubview:line3];
    [line3 drawTransverseDotterLineWithLength:3 lineSpacing:2 lineColor:[UIColor grayColor]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
