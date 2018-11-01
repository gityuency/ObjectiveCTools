//
//  UIImage+Image.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/10/25.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Image)

/**
 根据颜色生成图片
 
 @param color 颜色
 @return 图片
 */
+ (UIImage *)image_WithColor:(nullable UIColor *)color;



/**
 给图片添加文字水印
 
 @param text 水印文字
 @param point 添加位置
 @param attributed 文字的富文本属性
 @return 图片
 */
- (UIImage *)image_WithWaterMarkText:(nullable NSString *)text textPoint:(CGPoint)point attributedString:(nullable NSDictionary *)attributed;



/**
 给图片添加图片水印
 
 @param markImage 水印图片
 @return 图片
 */
- (UIImage *)image_WithWaterMarkImage:(nullable UIImage *)markImage;



/**
 获得裁剪后的圆形图片 如果图片是长方形,则获得椭圆形图片
 
 @return 图片
 */
- (UIImage *)image_Circular;



/**
 获得裁剪后的圆形图片 带边框
 
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return 图片
 */
- (UIImage *)image_CircularBorder:(CGFloat)borderWidth color:(nonnull UIColor *)borderColor;


@end

NS_ASSUME_NONNULL_END

