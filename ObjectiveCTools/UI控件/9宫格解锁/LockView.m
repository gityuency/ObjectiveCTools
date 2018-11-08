//
//  LockView.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/11/8.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "LockView.h"

@interface LockView()

/// 记录选中的按钮数组
@property (nonatomic, strong) NSMutableArray *selectedButtonArray;
/// 记录当前手指所在的点
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation LockView

/// 数组懒加载
- (NSMutableArray *)selectedButtonArray {
    if (!_selectedButtonArray) {
        _selectedButtonArray = [NSMutableArray array];
    }
    return _selectedButtonArray;
}

///使用代码的方式加载视图
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

///使用XIB的方式加载视图
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

///初始化
- (void)setUp {
    self.backgroundColor = [UIColor clearColor];  //需要给个背景色,否则从代码加载将有特效出现
    for (int i = 0; i < 9; i ++) { //生成9个按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        button.tag = i;
        [button setImage:[UIImage imageNamed:@"lock_selected"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"lock_normal"] forState:UIControlStateNormal];
        [self addSubview:button];
    }
}

/// 获取当前手指的点
- (CGPoint)getCurrentPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    return curP;
}

/// 当前点有没有在按钮上,如果在,返回这个按钮
- (UIButton *)buttonRectContainsPoint:(CGPoint)point {
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, point)) {  //表示当前的点, 在某个 Rect 上
            return button;
        }
    }
    return nil;
}

#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint p = [self getCurrentPoint:touches];
    UIButton *b = [self buttonRectContainsPoint:p];
    if (b && b.selected == NO) {
        b.selected = YES;
        [self.selectedButtonArray addObject:b];
    }
}

#pragma mark - 触摸移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint p = [self getCurrentPoint:touches];
    self.currentPoint = p;
    UIButton *b = [self buttonRectContainsPoint:p];
    if (b && b.selected == NO) {
        b.selected = YES;
        [self.selectedButtonArray addObject:b];
    }
    //只要是触摸移动, 就触发重绘
    [self setNeedsDisplay];
}

#pragma mark - 触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *s = [NSMutableString string];
    //取消所有选中的按钮
    for (UIButton *b in self.selectedButtonArray) {
        [s appendFormat:@"%ld ", b.tag];
        b.selected = NO;
    }
    //清空路径
    [self.selectedButtonArray removeAllObjects];
    [self setNeedsDisplay];
    //查看按钮选中顺序
    NSLog(@"%@", s);
}


/// 绘制当前的视图
- (void)drawRect:(CGRect)rect {
    
    if (self.selectedButtonArray.count) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectedButtonArray.count; i++) {
            UIButton *b = self.selectedButtonArray[i];
            if (i == 0) {
                [path moveToPoint:b.center];
            } else {
                [path addLineToPoint:b.center];
            }
        }
        [path addLineToPoint:self.currentPoint];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path setLineWidth:10];
        [[UIColor orangeColor] set];
        [path stroke];
    }
}


/// 获得布局尺寸 在布局确定后,调整按钮的位置和大小
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat buttonwh = 74;
    int column = 3;
    CGFloat margin = (self.bounds.size.width - (buttonwh * column)) / (column + 1);
    int curC = 0;
    int curR = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        curC = i % column;
        curR = i / column;
        x = margin + (buttonwh + margin) * curC;
        y = margin + (buttonwh + margin) * curR;
        UIButton *b = self.subviews[i];
        b.frame = CGRectMake(x, y, buttonwh, buttonwh);
    }
}


@end
