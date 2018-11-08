//
//  Lock9PointViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/11/8.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "Lock9PointViewController.h"
#import "LockView.h"

@interface Lock9PointViewController ()

@end

@implementation Lock9PointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LockView *v = [[LockView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    v.center = self.view.center;
    [self.view addSubview:v];
    
}

@end
