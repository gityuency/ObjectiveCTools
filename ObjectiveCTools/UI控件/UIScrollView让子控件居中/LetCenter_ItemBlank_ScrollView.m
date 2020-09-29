//
//  LetCenter_ItemBlank_ScrollView.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/9/29.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "LetCenter_ItemBlank_ScrollView.h"

@interface LetCenter_ItemBlank_ScrollView () <UIScrollViewDelegate>

/// 放入子视图
@property (nonatomic, strong) NSMutableArray <UIView *> *arrayItemViews;

@end

@implementation LetCenter_ItemBlank_ScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor systemPinkColor];
        [self randomButtonWidth];
        self.delegate = self;
    }
    return self;
}

/// 变宽 按钮
- (void)randomButtonWidth {
    UIButton *beforeButton;
    _arrayItemViews = [NSMutableArray array];
    
    //间隙
    CGFloat space = 100;
    
    for (int i = 0; i < 25; i ++) {
        UIButton *b = [[UIButton alloc] init];
        b.backgroundColor = UIColor.blackColor;
        
        NSString *t = [NSString stringWithFormat:@"变宽按钮 %d", i];
        
        [b setTitle:t forState:UIControlStateNormal];
        CGFloat w = 50 + (arc4random_uniform(30) / 2) * 10;
        if (beforeButton) {  //第二个按钮开始排
            b.frame = CGRectMake(CGRectGetMaxX(beforeButton.frame) + space, 0, w, self.frame.size.height);
        } else {              //第一个按钮
            b.frame = CGRectMake(space, 0, w, self.frame.size.height);
        }
        beforeButton = b;
        [b addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [_arrayItemViews addObject:b];
    }
    self.contentSize = CGSizeMake(CGRectGetMaxX(beforeButton.frame) + space, self.frame.size.height);
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

//代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"停止减速 offsetX %f", scrollView.contentOffset.x);
    
    //如何找打需要居中的按钮, 方案二
    
    CGFloat offsetX = scrollView.contentOffset.x + self.frame.size.width * 0.5;  // 哪个按钮和这个距离最接近,就放大哪个按钮
    UIButton *aimButton;
    CGFloat maxViewOffset = MAXFLOAT;
    for (UIButton *v in _arrayItemViews) {  //可以用中心点来判断
        CGFloat tempCenter = CGRectGetMidX(v.frame);
        CGFloat a = fabs(tempCenter - offsetX);
        if (a < maxViewOffset) {
            maxViewOffset = a;
            aimButton = v;// 就是上一个
        } else {
            //当最小距离变大的时候,说明上一视图就是需要居中的视图,break掉,取得上一个
            break;
        }
    }
    [self actionButton:aimButton];
}

@end
