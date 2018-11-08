//
//  NSString+BankFinance.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BankFinance)

/// 银行卡号处理 前后留 4 位
- (NSString *)bankCardMask;

/// 银行卡号校验
- (BOOL)isValidBankCardNumber;

/// 替换银行名
- (NSString *)getBankName;

/// 格式化金额 分转元 保留两位小数
- (NSString *)formatToTwoDecimal;

@end
