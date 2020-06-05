//
//  TextViewViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/8/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "TextViewViewController.h"
#import "MyTextView.h"

@interface TextViewViewController () <UITextViewDelegate>

@property (nonatomic, strong) MyTextView *tview;

@end

@implementation TextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tview = [[MyTextView alloc] initWithFrame:CGRectMake(20, 150, [UIScreen mainScreen].bounds.size.width - 40, 300)];
    self.tview.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.tview];
    
    self.tview.delegate = self;
    self.tview.editable = NO;
    self.tview.scrollEnabled = NO;
    //self.vvv.selectable = NO; 这一句写了点击事件就失效
    
    NSString *aLink = @"《青米网络科技无限公司隐私协议》";
    NSString *bLink = @"《青米网络科技卖身协议》";
    NSString *link = [NSString stringWithFormat:@"我已经同意并且认真阅读了遵守%@%@",aLink,bLink];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:link];
    
    //设置链接文本
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"http://www.baidu.com"
                             range:[[attributedString string] rangeOfString:aLink]];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"http://www.163.com"
                             range:[[attributedString string] rangeOfString:bLink]];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:24]
                             range:[[attributedString string] rangeOfString:link]];
    
    //设置链接样式
    self.tview.linkTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor redColor],
        NSUnderlineColorAttributeName: [UIColor clearColor],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
    };
    
    self.tview.attributedText = attributedString;
    
    
    NSLog(@"各种手势:\n %@", self.tview.gestureRecognizers);
}

#pragma mark - 实现链接代理
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSLog(@"可以判断一下链接, %@",URL);
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
    NSLog(@"iOS 10+ %@",URL);
    return YES;
}

@end

