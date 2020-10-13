//
//  SMSCodeView.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/10/13.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "SMSCodeView.h"

@interface SMSCodeView ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *cursor;

@end

@implementation SMSCodeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    
    self.userInteractionEnabled = NO;
    
    _line = [[UIView alloc] init];
    _line.userInteractionEnabled = NO;
    _line.backgroundColor = UIColor.grayColor;
    [self addSubview:_line];
    
    _label = [[UILabel alloc] init];
    _label.textColor = UIColor.blackColor;
    [self addSubview:_label];
    
    //默认关闭
    _showCursor = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    CGFloat x = (self.frame.size.width - self.label.frame.size.width) / 2.0;
    CGFloat y = (self.frame.size.height - self.label.frame.size.height) / 2.0;
    self.label.frame = CGRectMake(x, y, self.label.frame.size.width, self.label.frame.size.height);
    
    [self updateCursorFrame];
}

- (void)setText:(NSString *)text {
    _text = text;
    if (_text.length > 0) {
        _line.backgroundColor = UIColor.redColor;
    } else {
        _line.backgroundColor = UIColor.grayColor;
    }
    _label.text = text;
    [self.label sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)updateCursorFrame {
    CGFloat x = 0;
    if (self.label.frame.size.width <= 0) {
        x = (self.frame.size.width - 1.6) / 2.0;
    } else {
        x = CGRectGetMaxX(self.label.frame);
    }
    _cursor.frame = CGRectMake(x, 10, 1.6, self.frame.size.height - 20);
}

- (void)setShowCursor:(BOOL)showCursor {
    
    if (_showCursor == YES && showCursor == YES) { //重复开始, 那么,什么也不做
    } else if (_showCursor == YES && showCursor == NO) { //原来是开始的, 现在要求关闭, 那么,就关闭
        [_cursor removeFromSuperview];
    } else if (_showCursor == NO && showCursor == YES) { //原来是关闭, 现在要求开始, 那么, 开始
        _cursor = [[UIView alloc] init];
        _cursor.userInteractionEnabled = NO;
        _cursor.backgroundColor = UIColor.redColor;
        [self addSubview:_cursor];
        [self updateCursorFrame];
        _cursor.alpha = 0;
        [self animationOne:_cursor];
    } else if (_showCursor == NO && showCursor == NO) { //重复关闭
        [_cursor removeFromSuperview];
    }
    _showCursor = showCursor;
}

// 光标效果
- (void)animationOne:(UIView *)aView {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        aView.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.showCursor) {
            [self performSelector:@selector(animationTwo:) withObject:aView afterDelay:0.5];
        }
    }];
}

- (void)animationTwo:(UIView *)aView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        aView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.showCursor) {
            [self performSelector:@selector(animationOne:) withObject:aView afterDelay:0.1];
        }
    }];
}

@end
