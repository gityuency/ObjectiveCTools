//
//  AsyncDemoView.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/7/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "AsyncDemoView.h"

@interface AsyncDemoView ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation AsyncDemoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_label];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imageView];
        
        //手写约束
        NSLayoutConstraint *consImgL = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *consImgB = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *consImgW = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil  attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
        NSLayoutConstraint *consImgH = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil  attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
        [_imageView addConstraint:consImgW];
        [_imageView addConstraint:consImgH];
        [self addConstraint:consImgL];
        [self addConstraint:consImgB];
        
        //添加约束
        NSLayoutConstraint *consLabelB = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *consLabelR = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *consLabelL = [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imageView  attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraint:consLabelB];
        [self addConstraint:consLabelR];
        [self addConstraint:consLabelL];
        
        //颜色
        self.backgroundColor = [UIColor redColor];
        _imageView.backgroundColor = [UIColor greenColor];
        _label.backgroundColor = [UIColor purpleColor];
        _label.textColor = [UIColor yellowColor];
        
    }
    return self;
}


- (void)setString:(NSString *)string {
    _string = string;
    self.label.text = _string;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}
@end
