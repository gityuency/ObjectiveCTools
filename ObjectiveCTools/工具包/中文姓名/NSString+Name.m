//
//  NSString+Name.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "NSString+Name.h"

@implementation NSString (Name)

#pragma mark - 校验用户姓名
- (BOOL)isValidName {
    if(!self || [@"" isEqualToString:self]) { return NO;}
    NSString *pattern = @"([\u4e00-\u9fa5.·]{2,20})";
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF matches %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end
