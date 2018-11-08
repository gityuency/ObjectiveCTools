//
//  DrawView.h
//  涂鸦
//
//  Created by 姬友大人 on 2018/11/2.
//  Copyright © 2018年 comming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawView : UIView

/// 要绘制的图片
@property (nonatomic, strong) UIImage *image;

///清屏
- (void)clear;
///撤销
- (void)undo;
///橡皮擦
- (void)erase;
/// 设置线的宽度
- (void)setLineWidth:(CGFloat)lineWidth;
/// 设置线的颜色
- (void)setLineColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
