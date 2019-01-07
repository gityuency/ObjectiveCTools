//
//  HomePagePopView.m
//  yuency
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 yuency. All rights reserved.
//

#import "HomePagePopView.h"

@implementation HomePagePopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HomePagePopView" owner:nil options:nil] firstObject];
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return self;
}

///显示
+ (void)show:(nullable NSString *)title subTitle:(nullable NSString *)subtitle image:(nullable UIImage *)image content:(nullable NSString *)content click:(nullable BlockClick)click close:(nullable BlockClose)close {

    HomePagePopView *v = [[[NSBundle mainBundle] loadNibNamed:@"HomePagePopView" owner:nil options:nil] firstObject];
    v.frame = UIScreen.mainScreen.bounds;
    v.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    v.blockClick = click;
    v.blockClose = close;
    
    v.labelTitle.text = title == nil ? @"" : title;
    
    if (subtitle == nil || subtitle.length == 0) {
        [v.labelSubTitle removeFromSuperview];
    } else {
        v.labelSubTitle.text = subtitle;
    }

    if (image == nil) {
        v.imageView.hidden = YES;
    } else {
        v.imageView.image = image;
    }
    
    if (content == nil) {
        v.textView.hidden = YES;
    } else {
        v.textView.text = content;
        v.textView.contentOffset = CGPointZero;
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:v];
}

/// 消失
- (void)disMiss {
    [self removeFromSuperview];
    self.blockClose = nil;
    self.blockClick = nil;
}

/// 确定
- (IBAction)actionSure:(UIButton *)sender {
    if (self.blockClick) {
        self.blockClick();
    }
    [self disMiss];
}

/// 关闭
- (IBAction)actionClose:(UIButton *)sender {
    if (self.blockClose) {
        self.blockClose();
    }
    [self disMiss];
}

@end
