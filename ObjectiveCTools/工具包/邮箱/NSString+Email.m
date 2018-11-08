//
//  NSString+Email.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "NSString+Email.h"

@implementation NSString (Email)

#pragma mark 校验邮箱
- (BOOL) isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
