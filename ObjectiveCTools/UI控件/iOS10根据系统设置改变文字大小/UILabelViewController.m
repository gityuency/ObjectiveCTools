//
//  UILabelViewController.m
//  ObjectiveCTools
//
//  Created by Yuency on 2018/9/6.
//  Copyright © 2018年 Yuency. All rights reserved.
//

#import "UILabelViewController.h"

@interface UILabelViewController ()

/// iOS 10 根据系统设置来改变文字大小
@property (weak, nonatomic) IBOutlet UILabel *labeliOS10DynamicType;


@end

@implementation UILabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置字体大小
    self.labeliOS10DynamicType.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    //允许调整
    self.labeliOS10DynamicType.adjustsFontForContentSizeCategory = YES;
    
}

@end
