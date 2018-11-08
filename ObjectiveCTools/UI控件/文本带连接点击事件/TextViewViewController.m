//
//  TextViewViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/8/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "TextViewViewController.h"

@interface TextViewViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *vvv;

@end

@implementation TextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vvv.delegate = self;
    self.vvv.editable = NO;
    self.vvv.scrollEnabled = NO;
    //self.vvv.selectable = NO; 这一句写了点击事件就失效
    
    NSString *aLink = @"《青米网络科技无限公司协议》";
    NSString *bLink = @"《青米网络科卖身协议》";
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
                             value:[UIFont systemFontOfSize:20]
                             range:[[attributedString string] rangeOfString:link]];
    
    //设置链接样式
    self.vvv.linkTextAttributes = @{
                                    NSForegroundColorAttributeName: [UIColor redColor],
                                    NSUnderlineColorAttributeName: [UIColor clearColor],
                                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                    };
    
    self.vvv.attributedText = attributedString;
    
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
