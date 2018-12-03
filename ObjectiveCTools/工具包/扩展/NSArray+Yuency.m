//
//  NSArray+Yuency.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/3.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "NSArray+Yuency.h"

@implementation NSArray (Yuency)

#pragma mark - 字符串排序 字符串数组排序
- (NSArray *)yx_sortedArrayFromString {
    for (NSObject *obj in self) {
        if (![obj isKindOfClass:[NSString class]]) {
            NSLog(@"数组含有非字符串对象!");
            return @[];
        }
    }
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1, NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray = [self sortedArrayUsingComparator:sort];
    return resultArray;
}

@end
