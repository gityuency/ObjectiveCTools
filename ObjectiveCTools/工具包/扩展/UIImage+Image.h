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

/// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
