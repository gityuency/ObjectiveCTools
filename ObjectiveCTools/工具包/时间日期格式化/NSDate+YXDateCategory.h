//
//  NSDate+YXDateCategory.h
//  ObjectiveCTools
//
//  Created by EF on 2019/8/26.
//  Copyright © 2019 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (YXDateCategory)


@property(nonatomic,assign,readonly)NSInteger year;
@property(nonatomic,assign,readonly)NSInteger month;
@property(nonatomic,assign,readonly)NSInteger day;
@property(nonatomic,assign,readonly)NSInteger hour;
@property(nonatomic,assign,readonly)NSInteger minute;
@property(nonatomic,assign,readonly)NSInteger seconds;
@property (nonatomic,assign,readonly)NSInteger weekday;

+(NSDate *)dd_dateWithDateString:(NSString *)dateString;

+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:(NSString *)string;
+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_HH_mm_string:(NSString *)string;
+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_HH_string:(NSString *)string;
+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_string:(NSString *)string;
+(NSDate *)dd_dateWithFormat_yyyy_MM_string:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
