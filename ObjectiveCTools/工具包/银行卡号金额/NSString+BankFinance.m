//
//  NSString+BankFinance.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "NSString+BankFinance.h"

@implementation NSString (BankFinance)


/// 格式化金额 分转元 保留两位小数
- (NSString *)formatToTwoDecimal {

    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *thr = [one decimalNumberByDividingBy:two];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.positiveFormat = @",###.##";
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[thr doubleValue]]];
    
    NSString *result = [NSString stringWithFormat:@"￥%@",money];
    
    if (![result containsString:@"."]) {  //被整除的情况
        result = [NSString stringWithFormat:@"%@.00",result];
    } else {                              //小数不足两位
        NSArray *array = [result componentsSeparatedByString:@"."];
        NSString *subNumber = array.lastObject;
        if (subNumber.length == 1) {
            result = [NSString stringWithFormat:@"%@.%@0",array.firstObject, array.lastObject];
        }
    }
    return result;
}




#pragma mark 前后留 4 位
- (NSString *)bankCardMask {
    if(self.length > 8){
        NSString *s1 = [self substringWithRange:NSMakeRange(0, 4)];
        NSString *s2 = [self substringFromIndex:self.length-4];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",s1,@"**********",s2];
        return str;
    }
    return self;
}

#pragma mark 检查银行卡是否合法
/*
 * 常用信用卡卡号规则
 * Issuer Identifier  Card Number                            Length
 * Diner's Club       300xxx-305xxx, 3095xx, 36xxxx, 38xxxx  14
 * American Express   34xxxx, 37xxxx                         15
 * VISA               4xxxxx                                 13, 16
 * MasterCard         51xxxx-55xxxx                          16
 * JCB                3528xx-358xxx                          16
 * Discover           6011xx                                 16
 * 银联                622126-622925                          16
 *
 * 信用卡号验证基本算法：
 * 偶数位卡号奇数位上数字*2，奇数位卡号偶数位上数字*2。
 * 大于10的位数减9。
 * 全部数字加起来。
 * 结果不是10的倍数的卡号非法。
 * prefrences link:http://www.truevue.org/licai/credit-card-no
 *
 */
- (BOOL)isValidBankCardNumber {
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (int i = (int)self.length - 1; i >= 0; i--) {
        digit = [self characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        } else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

#pragma mark 替换银行名
- (NSString *)getBankName {
    if([@"ICBC" isEqualToString:self]){
        return @"工商银行";
    }else if([@"ABC" isEqualToString:self]){
        return @"农业银行";
    }else if([@"BOC" isEqualToString:self]){
        return @"中国银行";
    }else if([@"CCB" isEqualToString:self]){
        return @"建设银行";
    }else if([@"PSBC" isEqualToString:self]){
        return @"邮政储蓄银行";
    }else if([@"CITIC" isEqualToString:self]){
        return @"中信银行";
    }else if([@"CEB" isEqualToString:self]){
        return @"光大银行";
    }else if([@"CMBC" isEqualToString:self]){
        return @"民生银行";
    }else if([@"PAYH" isEqualToString:self]){
        return @"平安银行";
    }else if([@"CIB" isEqualToString:self]){
        return @"兴业银行";
    }else if([@"CMB" isEqualToString:self]){
        return @"招商银行";
    }else if([@"CGB" isEqualToString:self]){
        return @"广发银行";
    }else if([@"HXB" isEqualToString:self]){
        return @"华夏银行";
    }else if([@"SPDB" isEqualToString:self]){
        return @"浦发银行";
    }else if([@"BCCB" isEqualToString:self]){
        return @"北京银行";
    }else if([@"SHBANK" isEqualToString:self]){
        return @"上海银行";
    }else if([@"BOCM" isEqualToString:self]){
        return @"交通银行";
    }
    return @"";
}

@end
