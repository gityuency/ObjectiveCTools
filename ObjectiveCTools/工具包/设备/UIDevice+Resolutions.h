//
//  UIDevice+Resolutions.h
//  
//
//  Created by crf on 15/10/16.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 分辨率枚举
typedef NS_ENUM(NSUInteger, UIDeviceResolution) {
    UIDevice_iPad1_2             = 1,  // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPad3               = 2,  // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPhone4_4s          = 4,  // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhone5_5s_5c_se    = 5,  // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhone6_6s_7_8      = 6,  // iPhone 6,6s,7,8 高清分辨率(750x1334px)
    UIDevice_iPhone6_6s_7_8_Plus = 10, // iPhone 6P,6sP,7P,8P plus高清分辨率(1242x2208px)
    UIDevice_iPhoneX             = 14  // iPhone X 高清分辨率(1125x2436px)
};

@interface UIDevice (Resolutions)

/// 获取当前分辨率
+ (UIDeviceResolution) currentResolution;

/// 判断各种机型
+ (BOOL)isIPhoneX;
+ (BOOL)isIPhone6_6s_7_8;
+ (BOOL)isIPhone6_6s_7_8_Plus;
+ (BOOL)isIPhone5_5s_5c_se;
+ (BOOL)isIPhone4_4s;

/// 获取键盘高度
+(NSInteger)getKeywordHeight;

//比较系统版本号大小
+(BOOL)isGreaterThanIOS8;

// 获取设备型号\手动转化为对应名称
+(NSString *)getDeviceName;

/// 判断是否运行在模拟器
+(BOOL)isRunSimulator;

@end
