//
//  UIView+DotterLine.h
//  CashLoan
//
//  Created by ObjectiveCTools on 2018/1/10.
//  Copyright © 2018年 crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DotterLine)

/*用法示例:
 UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 160, 200, 20)];
 [self.view addSubview:line3];
 [line3 drawTransverseDotterLineWithLength:3 lineSpacing:2 lineColor:[UIColor grayColor]];
 */
/**
 *  @author Ali
 *
 *  画出一条横向的虚线  注意:size.height 就是线条的高度
 *
 *  @param lineLength  单个线条长度
 *  @param lineSpacing 单个线条间距
 *  @param lineColor   单个线条颜色
 *
 *  将当前view画出一条横向的虚线  注意:view.size.height 就是线条的高度
 */
- (void)drawTransverseDotterLineWithLength:(CGFloat)lineLength lineSpacing:(CGFloat)lineSpacing lineColor:(UIColor *)lineColor;



@end
