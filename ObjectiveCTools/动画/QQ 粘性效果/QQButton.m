//
//  QQButton.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/6.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "QQButton.h"

@interface QQButton ()

/// 底部的小圆
@property (nonatomic, strong) UIView *smallCircle;
/// 中间的形状
@property (nonatomic, strong) CAShapeLayer *shapLayer;
/// 标记一下视图需要额外初始化
@property (nonatomic, assign) BOOL isNeedUpdate;

@end


@implementation QQButton

- (CAShapeLayer *)shapLayer {
    if (_shapLayer == nil) {
        _shapLayer = [CAShapeLayer layer];
        _shapLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:_shapLayer atIndex:0];
    }
    return _shapLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self setUp];
}

- (void)setUp {
    
    UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:p];
    self.backgroundColor = [UIColor redColor];
    
    //添加一个底部的圆形
    self.smallCircle = [[UIView alloc] init];
    self.smallCircle.backgroundColor = self.backgroundColor;
    
    self.isNeedUpdate = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isNeedUpdate == YES) {
        self.layer.cornerRadius = self.frame.size.width * 0.5;
        self.smallCircle.frame = self.frame;
        self.smallCircle.layer.cornerRadius = self.layer.cornerRadius;
        [self.superview addSubview:self.smallCircle];
        [self.superview insertSubview:self.smallCircle belowSubview:self];
        self.isNeedUpdate = NO;
    }
}


- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self];
    
    // transform 修改的是 frme, 并没有修改 center
    //self.transform = CGAffineTransformTranslate(self.transform, p.x, p.y);
    CGPoint center = self.center;
    center.x += p.x;
    center.y += p.y;
    self.center = center;
    [pan setTranslation:CGPointZero inView:self]; // 复位
    
    //让小圆的半径根据距离的增大而减小
    CGFloat distance = [self distanceWithView:self.smallCircle view:self];
    CGFloat smallR = self.bounds.size.width * 0.5; //这里取得是大圆的宽度的一半, 因为这个值不会动态改变
    smallR -= distance / 5.0;
    self.smallCircle.bounds = CGRectMake(0, 0, smallR * 2, smallR * 2); //这里修改 bounds 不是 frame
    self.smallCircle.layer.cornerRadius = smallR;
    
    if (self.smallCircle.hidden == NO) {
        UIBezierPath *path = [self pathWithView:self.smallCircle view:self];
        self.shapLayer.path = path.CGPath;
    }
    
    if (distance > 200) { //让小圆隐藏 路径隐藏
        self.smallCircle.hidden = YES;
        [self.shapLayer removeFromSuperlayer];
        self.shapLayer = nil;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (distance < 200) { //复位
            [self.shapLayer removeFromSuperlayer];
            self.shapLayer = nil;
            self.center = self.smallCircle.center;
            self.smallCircle.hidden = NO;
        } else { //消失
            
        }
    }
}

/// 给定两个视图,计算点 ABCDOP
- (UIBezierPath *)pathWithView:(UIView *)viewA view:(UIView *)viewB {
    
    CGFloat x1 = viewA.center.x;
    CGFloat y1 = viewA.center.y;
    
    CGFloat x2 = viewB.center.x;
    CGFloat y2 = viewB.center.y;
    
    CGFloat d = [self distanceWithView:viewA view:viewB];
    
    if (d <= 0) {
        return nil;
    }
    
    CGFloat cosθ = (y2 - y1) / d;
    CGFloat sinθ = (x2 - x1) / d;
    
    CGFloat r1 = viewA.bounds.size.width * 0.5;
    CGFloat r2 = viewB.bounds.size.width * 0.5;
    
    //开始描述点
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ, y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ, y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ, y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ, y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d * 0.5 * sinθ, pointA.y + d * 0.5 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d * 0.5 * sinθ, pointB.y + d * 0.5 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //AB
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    //BC 曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //CD
    [path addLineToPoint:pointD];
    //DA 曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}


/// 求两个圆之间的距离
- (CGFloat)distanceWithView:(UIView *)viewA view:(UIView *)viewB {
    CGFloat offsetX = viewA.center.x - viewB.center.x;
    CGFloat offsetY = viewA.center.y - viewB.center.y;
    return sqrt(offsetX * offsetX + offsetY * offsetY);
}


@end
