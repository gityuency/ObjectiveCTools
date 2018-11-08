//
//  NSString+PhoneNumber.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "NSString+PhoneNumber.h"

@implementation NSString (PhoneNumber)

#pragma mark 校验手机号
- (BOOL)isValidPhoneNumber {
    if(!self || [@"" isEqualToString:self] || self.length < 11) {return NO;}
    NSString *pattern = @"^((13[0-9])|(15[^4,\\D])|(19[0-9])|(16[0-9])|(14[0-9])|(18[0-9])|(17[0-9])|(12[0-9]))\\d{8}$";
    //NSPredicate*pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@", pattern];
    BOOL isMatch=[pred evaluateWithObject:self];
    return isMatch;
}

#pragma mark 手机、座机识别
- (BOOL)isValidTel {
    
    if(!self || [@"" isEqualToString:self] || self.length < 11) {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^(0[0-9]{2})[- ]\\d{8}$|^(0[0-9]{3}[- ](\\d{7,8}))$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:self] == YES) || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES) || ([regextestcu evaluateWithObject:self] == YES)
        || ([regextestphs evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark 座机只包含“-”和数字
- (BOOL)isValidUnitTel {
    
    if(!self || [@"" isEqualToString:self] || self.length < 5 || self.length>20){
        return NO;
    }
    NSString *pattern=@"^-?[0-9|-]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

#pragma mark 电话有效密码鉴别
- (BOOL)isValidPhonePassword {
    if(!self || [@"" isEqualToString:self] || self.length<6 || self.length>12)
        return NO;
    NSString *pattern=@"(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{2,})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@", pattern];
    
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}


#pragma mark 手机号处理 中间 6 位掩码
- (NSString *)phoneNoMask6 {
    if(self.length == 11){
        NSString *s1 = [self substringWithRange:NSMakeRange(0, 3)];
        NSString *s2 = [self substringFromIndex:self.length-2];
        NSString *result = [NSString stringWithFormat:@"%@%@%@",s1,@"******",s2];
        return result;        
    } else {
        return self;
    }
}

#pragma mark 手机号处理 中间 4 位掩码
- (NSString *)phoneNoMask4 {
    if(self.length==11){
        NSString *s1 = [self substringWithRange:NSMakeRange(0, 3)];
        NSString *s2 = [self substringFromIndex:self.length-4];
        NSString *result = [NSString stringWithFormat:@"%@%@%@",s1,@"****",s2];
        return result;
    } else {
        return self;
    }
}

@end
