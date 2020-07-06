//
//  LetCenter_A_ScrollView.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/7/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "LetCenter_A_ScrollView.h"

@interface LetCenter_A_ScrollView () <UIScrollViewDelegate>

/// 放入子视图
@property (nonatomic, strong) NSMutableArray <UIView *> *arrayItemViews;

@end

@implementation LetCenter_A_ScrollView

- (instancetype)initWithFrameFixedSubViewWidth:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self fixedButtonWidth];
        self.delegate = self;
    }
    return self;
}

- (instancetype)initWithFrameRandomSubViewWidth:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self randomButtonWidth];
        self.delegate = self;
    }
    return self;
}

/// 变宽 按钮
- (void)randomButtonWidth {
    UIButton *beforeButton;
    _arrayItemViews = [NSMutableArray array];
    for (int i = 0; i < 25; i ++) {
        UIButton *b = [[UIButton alloc] init];
        b.backgroundColor = [self RandomColor];
        [b setTitle:@"变宽按钮" forState:UIControlStateNormal];
        CGFloat w = 50 + (arc4random_uniform(30) / 2) * 10;
        if (beforeButton) {  //第二个按钮开始排
            b.frame = CGRectMake(CGRectGetMaxX(beforeButton.frame), 0, w, self.frame.size.height);
        } else {              //第一个按钮
            b.frame = CGRectMake(0, 0, w, self.frame.size.height);
        }
        beforeButton = b;
        [b addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [_arrayItemViews addObject:b];
    }
    self.contentSize = CGSizeMake(CGRectGetMaxX(beforeButton.frame), self.frame.size.height);
}

/// 定宽 按钮
- (void)fixedButtonWidth {
    CGFloat w = 120;
    _arrayItemViews = [NSMutableArray array];
    for (int i = 0; i < 25; i ++) {
        UIButton *b = [[UIButton alloc] init];
        b.backgroundColor = [self RandomColor];
        [b setTitle:@"定宽按钮" forState:UIControlStateNormal];
        b.frame = CGRectMake(i * w, 0, w, self.frame.size.height);
        [b addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [_arrayItemViews addObject:b];
    }
    self.contentSize = CGSizeMake(w * _arrayItemViews.count, self.frame.size.height);
}


/// 按钮点击事件
- (void)actionButton:(UIButton *)buttonCurrent {
    //设置滚动
    CGFloat scrollViewCenterX = self.frame.size.width * 0.5;
    if (scrollViewCenterX == 0) {  //宽度都没有,啥也不用干了
        return;
    }
    
    if (self.contentSize.width < self.frame.size.width) {
        return;                     //内容宽度小于外部宽度, 啥也不用干了
    }
    
    CGFloat buttonCenterX = buttonCurrent.center.x;
    if (buttonCenterX < scrollViewCenterX) {
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (buttonCenterX > scrollViewCenterX) {
        CGFloat unVisiableWidth = self.contentSize.width - self.frame.size.width;
        CGFloat needOffset = buttonCenterX - scrollViewCenterX;
        if (unVisiableWidth > needOffset) {  //剩下的可滑动的区域可以给与偏移
            [self setContentOffset:CGPointMake(needOffset, 0) animated:YES];
        } else {  //剩下的已经不够了, 那么就直接显示
            [self setContentOffset:CGPointMake(unVisiableWidth, 0) animated:YES];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"停止减速 offsetX %f", scrollView.contentOffset.x);
    
    CGFloat offsetX = scrollView.contentOffset.x + self.frame.size.width * 0.5;  // 哪个按钮和这个距离最接近,就放大哪个按钮
    
    UIButton *needLargeButton;
    for (UIButton *b in _arrayItemViews) {
        if ((CGRectGetMinX(b.frame) <= offsetX) && (CGRectGetMaxX(b.frame) >= offsetX)) {
            needLargeButton = b;
            NSLog(@" %@", b.titleLabel.text);
            break;
        }
    }
    [self actionButton:needLargeButton];
}


- (UIColor *)RandomColor {
    UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    return randomColor;
}

@end
