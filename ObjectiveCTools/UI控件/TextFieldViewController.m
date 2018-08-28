//
//  TextFieldViewController.m
//  ObjectiveCTools
//
//  Created by ChinaRapidFinance on 2018/8/27.
//  Copyright © 2018年 ChinaRapidFinance. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()

#pragma mark - 第一种方案,属性
@property (weak, nonatomic) IBOutlet UITextField *t;

@property (weak, nonatomic) IBOutlet UILabel *l;

@property (weak, nonatomic) IBOutlet UILabel *lc;

#pragma mark - 第二种方案,属性

@property (weak, nonatomic) IBOutlet UITextField *t_2;
@property (weak, nonatomic) IBOutlet UILabel *l_2;



@end

@implementation TextFieldViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"监听输入框里输入的文本";
    
    [self planA];
    
    [self planB];
    
}

#pragma mark - 第一种方案
- (void)planA {
    //第一种  需要移除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self.t];
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *sender = (UITextField *)[notification object];
    self.l.text = sender.text;
    self.lc.text = [NSString stringWithFormat:@"方案1 个数: %ld",sender.text.length];
}


#pragma mark - 第二种方案
- (void)planB {
    
    [_t_2 addTarget:self action:@selector(t_2_DidChangeValue:) forControlEvents:UIControlEventEditingChanged];
}

- (void)t_2_DidChangeValue:(id)sender {
    UITextField *t = (UITextField *)sender;
    self.l_2.text = t.text;
    self.lc.text = [NSString stringWithFormat:@"方案2 个数: %ld",t.text.length];
}


@end

