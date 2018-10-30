//
//  UIImage+Image.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/10/25.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

/// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    // 矩形描述
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    //开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    
    //获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //使用 color 演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    //渲染上下文
    CGContextFillRect(context, rect);
    
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
