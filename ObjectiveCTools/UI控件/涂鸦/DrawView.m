//
//  DrawView.m
//  涂鸦
//
//  Created by 姬友大人 on 2018/11/2.
//  Copyright © 2018年 comming. All rights reserved.
//

#import "DrawView.h"
#import "MyBezierPath.h"

@interface DrawView()

/// 当前绘制的路径
@property (nonatomic, strong) UIBezierPath *path;
/// 保存当前绘制的所有路径
@property (nonatomic, strong) NSMutableArray *allPathArray;
/// 当前路径的宽度
@property (nonatomic, assign) CGFloat currentWidth;
/// 当前路劲的颜色
@property (nonatomic, strong) UIColor *currentColor;

@end


@implementation DrawView

- (NSMutableArray *)allPathArray {
    if (nil == _allPathArray) {
        _allPathArray = [NSMutableArray array];
    }
    return _allPathArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}


- (void)setImage:(UIImage *)image {
    _image = image;
    [self.allPathArray addObject:_image];
    [self setNeedsDisplay];
}


- (void)setUp {
    UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:p];
    self.currentWidth = 1;
    self.currentColor = [UIColor blackColor];
}

- (void)pan:(UIPanGestureRecognizer *)p {
    
    CGPoint currentPoint = [p locationInView:self];
    
    if (p.state == UIGestureRecognizerStateBegan) {
        
        MyBezierPath *newPath = [[MyBezierPath alloc] init];
        newPath.color = self.currentColor;
        [newPath setLineWidth:self.currentWidth];
        
        self.path = newPath;
        [self.path moveToPoint:currentPoint];
        [self.allPathArray addObject:newPath];
        
    } else if (p.state == UIGestureRecognizerStateChanged) {
        
        [self.path addLineToPoint:currentPoint];
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect {
    for (MyBezierPath *path in self.allPathArray) {
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage *img = (UIImage *)path;
            [img drawInRect:rect];
        } else {
            [path.color set];
            [path stroke];
        }
    }
}


///清屏
- (void)clear {
    [self.allPathArray removeAllObjects];
    [self setNeedsDisplay];
}
///撤销
- (void)undo {
    [self.allPathArray removeLastObject];
    [self setNeedsDisplay];
}
///橡皮擦 用白色去覆盖
- (void)erase {
    [self setLineColor:[UIColor whiteColor]];
}
/// 设置线的宽度
- (void)setLineWidth:(CGFloat)lineWidth {
    self.currentWidth = lineWidth;
}
/// 设置线的颜色
- (void)setLineColor:(UIColor *)color {
    self.currentColor = color;
}


@end
