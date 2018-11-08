//
//  NSString+IDCardNumber.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "NSString+IDCardNumber.h"

@implementation NSString (IDCardNumber)

#pragma mark 身份证识别
- (BOOL)isValidIdNumber {
    
    if (!self || self.length != 18) {
        return  NO;
    }
    NSArray *codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary *checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner *scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue += [[self substringWithRange:NSMakeRange(i , 1) ] intValue] * [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[self substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}


#pragma mark 身份证号掩码,只保留第一位和最后一位
- (NSString *)idNumberMask {
    if(self.length > 15){
        NSString *s1 = [self substringWithRange:NSMakeRange(0, 1)];
        NSString *s2 = [self substringFromIndex:self.length-1];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",s1,@"*************",s2];
        return str;
    }
    return self;
}

@end
