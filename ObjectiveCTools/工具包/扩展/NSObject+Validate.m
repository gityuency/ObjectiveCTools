//
//  NSObject+Validate.m
//  CrfLease
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 crfchina. All rights reserved.
//

#import "NSObject+Validate.h"

@implementation NSObject (Validate)

#pragma mark - 判断对象是否为 nil, NSNull, @"", 0, 这4种情况返回YES
- (BOOL)validate_isNullObject:(id)object {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

#pragma mark - 返回 NSInteger
+ (NSInteger)validate_Number:(id)object {
    if ([object isEqual:[NSNull null]]) {
        return 0;
    }
    return [object integerValue];
}

#pragma mark - 返回 BOOL 对象为 NUll 返回 NO
+ (BOOL)validate_Bool:(id)object {
    
    if ([object isEqual:[NSNull null]]) {
        return 0;
    }
    return [object boolValue];
    
}

#pragma mark - 对象为空 返回 @""
+ (nonnull NSString *)validate_String:(id)object {
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    NSString *s = [NSString stringWithFormat:@"%@",object];
    if (!s || [s isEqualToString:@"(null)"] || [s isEqualToString:@"<null>"]) {
        s = @"";
    }
    return s;
}

#pragma mark - 对象为空 返回 空数组
+ (nonnull NSDictionary *)validate_Dictionary:(id)object {
    if ([object isEqual:[NSNull null]]) {
        return @{};
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    } else {
        return @{};
    }
}

#pragma mark - 对象为空返回 空字典
+ (nonnull NSArray *)validate_Array:(id)object {
    if ([object isEqual:[NSNull null]]) {
        return @[];
    }
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    } else {
        return @[];
    }
}



@end
