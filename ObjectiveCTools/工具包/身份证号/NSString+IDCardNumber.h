//
//  NSString+IDCardNumber.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IDCardNumber)

/// 身份证号码校验 没有验证
- (BOOL)isValidIdNumber;

/// 身份证号掩码,只保留第一位和最后一位 (字符串长度大于15就满足格式)
- (NSString *)idNumberMask;

@end
