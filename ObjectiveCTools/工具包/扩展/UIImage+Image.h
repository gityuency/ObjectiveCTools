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

/// 根据颜色生成图片 参数nil 生成黑色图片
+ (UIImage *)imageWithColor:(nullable UIColor *)color;

/// 给图片添加文字水印
- (UIImage *)imageWithWaterMarkText:(nullable NSString *)text textPoint:(CGPoint)point attributedString:(nullable NSDictionary *)attributed;

/// 给图片添加图片水印 参数nil返回原图片
- (UIImage *)imageWithWaterMarkImage:(nullable UIImage *)markImage;


@end

NS_ASSUME_NONNULL_END

