//
//  HandleImageView.m
//  涂鸦
//
//  Created by 姬友大人 on 2018/11/2.
//  Copyright © 2018年 comming. All rights reserved.
//

#import "HandleImageView.h"

@interface HandleImageView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation HandleImageView

- (UIImageView *)imageView {
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        [self addGes];
    }
    return _imageView;
}


- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)addGes {
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    [self.imageView addGestureRecognizer:pin];
    
    UILongPressGestureRecognizer *lon = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lon:)];
    [self.imageView addGestureRecognizer:lon];
    
    UIRotationGestureRecognizer *roa = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(roa:)];
    [self.imageView addGestureRecognizer:roa];
}


///拖动手势
- (void)pan:(UIPanGestureRecognizer *)p {
    CGPoint point = [p translationInView:p.view];
    p.view.transform = CGAffineTransformTranslate(p.view.transform, point.x, point.y);
    [p setTranslation:CGPointZero inView:p.view]; //复位
}

///缩放手势
- (void)pin:(UIPinchGestureRecognizer *)p {
    p.view.transform = CGAffineTransformScale(p.view.transform, p.scale, p.scale);
    [p setScale:1];
}

///长按手势
- (void)lon:(UILongPressGestureRecognizer *)p {
    
    if (p.state == UIGestureRecognizerStateBegan) { //让图片闪一下,把图片绘制到画板当中
        [UIImageView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIImageView animateWithDuration:0.5 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ctx];
                
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleImageView:newImage:)]) {
                    [self.delegate handleImageView:self newImage:image];
                }
                
                [self removeFromSuperview];
            }];
        }];
    }
}


///旋转手势
- (void)roa:(UIRotationGestureRecognizer *)p {
    p.view.transform = CGAffineTransformRotate(p.view.transform, p.rotation);
    p.rotation = 0;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
