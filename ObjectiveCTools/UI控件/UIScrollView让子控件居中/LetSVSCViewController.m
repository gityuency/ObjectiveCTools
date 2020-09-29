//
//  LetSVSCViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/7/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "LetSVSCViewController.h"
#import "LetCenter_RandomWidth_ScrollView.h"
#import "LetCenter_ScaleWidth_ScrollView.h"
#import "LetCenter_FixedWidth_UIScrollView.h"

@interface LetSVSCViewController ()

@end

@implementation LetSVSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    
    LetCenter_FixedWidth_UIScrollView *scrollView1 = [[LetCenter_FixedWidth_UIScrollView alloc] initWithFrameFixedSubViewWidth:CGRectMake(0, 100, sw, 80)];
    [self.view addSubview:scrollView1];
    
    LetCenter_RandomWidth_ScrollView *scrollView2 = [[LetCenter_RandomWidth_ScrollView alloc] initWithFrameRandomSubViewWidth:CGRectMake(0, 220, sw, 80)];
    [self.view addSubview:scrollView2];
    
    LetCenter_ScaleWidth_ScrollView *scrollView3 = [[LetCenter_ScaleWidth_ScrollView alloc] initWithFrame:CGRectMake(0, 350, sw, 80)];
    [self.view addSubview:scrollView3];
    
    CGFloat x = (sw + 1) / 2;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 1, sh)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
}

@end
