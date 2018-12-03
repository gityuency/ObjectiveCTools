//
//  NSObject+Validate.h
//  CrfLease
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 对象处理
@interface NSObject (Validate)

/// 判断对象是否为 nil, NSNull, @"", 0, 这4种情况返回YES
- (BOOL)validate_isNullObject:(id)object;

/// 返回 NSInteger
+ (NSInteger)validate_Number:(id)object;

/// 返回 BOOL 对象为 NUll 返回 NO
+ (BOOL)validate_Bool:(id)object;

/// 对象为空 返回 @""
+ (nonnull NSString *)validate_String:(id)object;

/// 对象为空 返回 空数组
+ (nonnull NSDictionary *)validate_Dictionary:(id)object;

/// 对象为空返回 空字典
+ (nonnull NSArray *)validate_Array:(id)object;

@end
