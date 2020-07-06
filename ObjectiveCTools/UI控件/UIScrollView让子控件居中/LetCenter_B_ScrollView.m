//
//  LetCenter_B_ScrollView.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/7/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "LetCenter_B_ScrollView.h"

@interface LetCenter_B_ScrollView () <UIScrollViewDelegate>
/// 存放子控件
@property (nonatomic, strong) NSMutableArray <UIView *> *arrayItemViews;
/// 存放标题,根据标题个数来计算子控件数
@property (nonatomic, strong) NSArray *titleArray;
/// 小尺寸数组
@property (nonatomic, strong) NSMutableArray *arraySmallSize;
/// 大尺寸数组
@property (nonatomic, strong) NSMutableArray *arrayLargeSize;
/// 小字体尺寸
@property (nonatomic) NSInteger smallFontSize;
/// 大字体尺寸
@property (nonatomic) NSInteger largeFontSize;

@end


@implementation LetCenter_B_ScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        _smallFontSize = 12;
        _largeFontSize = 26;
        [self randomButtonWidth];
        self.delegate = self;
    }
    return self;
}

/// 变宽 按钮
- (void)randomButtonWidth {
    
    _arrayItemViews = [NSMutableArray array];
    
    _titleArray = @[@"按钮宽度动态放大", @"小米锅巴", @"茶π", @"冰糖雪梨", @"汇源牌肾宝", @"昆仑山", @"鲜之每日C", @"REKORDERLIG瑞可德林", @"王老吉", @"RedBull红牛", @"健力宝", @"宝矿力水特", @"维维", @"Gatorade佳得乐", @"黑牛", @"东鹏特饮", @"Starbucks星巴克", @"Maxwell麦斯威尔", @"HOGOOD后谷咖啡", @"五粮液", @"古井贡酒", @"永和豆浆", @"南方黑芝麻", @"Soyspring冰泉", @"锐澳RIO"];
    
    //先算一遍大小尺寸
    _arraySmallSize = [NSMutableArray array];
    _arrayLargeSize = [NSMutableArray array];
    for (NSString *s in _titleArray) {
        CGSize sizeS = [self needSize:s fontSize:_smallFontSize];
        CGSize sizeL = [self needSize:s fontSize:_largeFontSize];
        [_arraySmallSize addObject:@(sizeS)];
        [_arrayLargeSize addObject:@(sizeL)];
    }
    
    NSLog(@"%@  %@", _arraySmallSize, _arrayLargeSize);
    
    UIButton *beforeButton;
    for (int i = 0; i < _titleArray.count; i ++) {
        UIButton *b = [[UIButton alloc] init];
        b.backgroundColor = [self RandomColor];
        NSString *s = _titleArray[i];
        [b setTitle:s forState:UIControlStateNormal];
        //[b setTitleColor:[self RandomColor] forState:UIControlStateNormal];
        if (beforeButton) {  //第二个按钮开始排
            CGSize size = [_arraySmallSize[i] CGSizeValue];
            b.frame = CGRectMake(CGRectGetMaxX(beforeButton.frame), 0, size.width, self.frame.size.height);
            b.titleLabel.font = [UIFont systemFontOfSize:_smallFontSize];
        } else {              //第一个按钮
            CGSize size = [_arrayLargeSize[i] CGSizeValue];
            b.frame = CGRectMake(0, 0, size.width, self.frame.size.height);
            b.titleLabel.font = [UIFont systemFontOfSize:_largeFontSize];
        }
        
        /*
         可以使用自定义的View, 先把需要的各种宽度计算好, 同样可以正常滑动.
         */
        
        beforeButton = b;
        [b addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [_arrayItemViews addObject:b];
    }
    self.contentSize = CGSizeMake(CGRectGetMaxX(beforeButton.frame), self.frame.size.height);
}


/// 计算尺寸
- (CGSize)needSize:(NSString *)title fontSize:(CGFloat)fontSize {
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]}];
    size.width += 20; //左右两边留 10 白
    return size;
}

/// 按钮点击事件
- (void)actionButton:(UIButton *)buttonCurrent {
    
    UIButton *beforeButton;
    for (UIButton *b in _arrayItemViews) {
        if (b == buttonCurrent) {
            NSUInteger index = [_arrayItemViews indexOfObject:b];
            CGSize size = [_arrayLargeSize[index] CGSizeValue];
            b.titleLabel.font = [UIFont systemFontOfSize:_largeFontSize];
            [UIView animateWithDuration:0.2 animations:^{
                b.frame = CGRectMake(CGRectGetMaxX(beforeButton.frame), 0, size.width, self.frame.size.height);
            }];
        } else {
            NSUInteger index = [_arrayItemViews indexOfObject:b];
            CGSize size = [_arraySmallSize[index] CGSizeValue];
            b.titleLabel.font = [UIFont systemFontOfSize:_smallFontSize];
            [UIView animateWithDuration:0.2 animations:^{
                b.frame = CGRectMake(CGRectGetMaxX(beforeButton.frame), 0, size.width, self.frame.size.height);
            }];
        }
        beforeButton = b;
    }
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(beforeButton.frame), self.frame.size.height);
    
    //设置滚动
    CGFloat scrollViewCenterX = self.frame.size.width * 0.5;
    if (scrollViewCenterX == 0) {
        return;
    }
    if (self.contentSize.width < self.frame.size.width) {
        return;
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

/// 代理
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
