//
//  SlidingCircularViewController.m
//  ObjectiveCTools
//
//  Created by EF on 2019/7/29.
//  Copyright © 2019 ChinaRapidFinance. All rights reserved.
//

#import "SlidingCircularViewController.h"
#import "YXGoalReviewView.h"

@interface SlidingCircularViewController ()

@property (weak, nonatomic) IBOutlet YXGoalReviewView *goalView;


@end

@implementation SlidingCircularViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.goalView.stringsArray = @[@"扣三丝", @"宫保鸡丁", @"番茄汤", @"炖鸡", @"红烧狮子头"];

}

@end
