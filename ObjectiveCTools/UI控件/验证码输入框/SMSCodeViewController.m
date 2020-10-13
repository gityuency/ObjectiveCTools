//
//  SMSCodeViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/10/13.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "SMSCodeViewController.h"
#import "SMSCodeInputView.h"

@interface SMSCodeViewController ()

@property (strong, nonatomic) SMSCodeInputView *inputView;

@end

@implementation SMSCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.inputView = [[SMSCodeInputView alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, 60)];
    [self.view addSubview:self.inputView];
    self.inputView.center = self.view.center;
    
    
    UIButton *b = [[UIButton alloc] init];
    [b setTitle:@"随机更改输入框的个数和间距" forState:UIControlStateNormal];
    b.backgroundColor = UIColor.brownColor;
    b.titleLabel.font = [UIFont systemFontOfSize:14];
    b.frame = CGRectMake(0, 100, 300, 44);
    [b addTarget:self action:@selector(chage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)chage {
    self.inputView.codeCount = arc4random_uniform(8) + 2;
    self.inputView.codeSpace = arc4random_uniform(60) + 10;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.inputView becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView resignFirstResponder];
    NSLog(@"获取到输入: %@", self.inputView.codeText);
}

@end
