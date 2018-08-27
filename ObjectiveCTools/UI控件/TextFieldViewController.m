//
//  TextFieldViewController.m
//  ObjectiveCTools
//
//  Created by ChinaRapidFinance on 2018/8/27.
//  Copyright © 2018年 ChinaRapidFinance. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()

@property (weak, nonatomic) IBOutlet UITextField *t;

@property (weak, nonatomic) IBOutlet UILabel *l;

@property (weak, nonatomic) IBOutlet UILabel *lc;

@end

@implementation TextFieldViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"监听输入框里输入的文本";
    
    [self.t becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self.t];
    
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *sender = (UITextField *)[notification object];
    self.l.text = sender.text;
    self.lc.text = [NSString stringWithFormat:@"个数: %ld",sender.text.length];
}

@end
