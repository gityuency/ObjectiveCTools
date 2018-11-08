//
//  NSString+PhoneNumber.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PhoneNumber)

/// 校验手机号 没有验证
- (BOOL)isValidPhoneNumber;

/// 手机、座机识别 没有验证
- (BOOL)isValidTel;

/// 座机只包含“-”和数字 没有验证
- (BOOL)isValidUnitTel;

/// 电话有效密码鉴别 没有验证
- (BOOL)isValidPhonePassword;

/// 11位 手机号处理 中间 6 位掩码 (其实能处理11位的字符串)
- (NSString *)phoneNoMask6;

/// 11位 手机号处理 中间 4 位掩码 (其实能处理11位的字符串)
- (NSString *)phoneNoMask4;

@end
