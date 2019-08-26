//
//  NSString+YXDateFormat.m
//  ObjectiveCTools
//
//  Created by EF on 2019/8/26.
//  Copyright © 2019 姬友大人. All rights reserved.
//

#import "NSString+YXDateFormat.h"
#import "NSDate+YXDateCategory.h"

@implementation NSString (YXDateFormat)


-(NSString *)dd_formatNianYueRi
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld年%02ld月%02ld日",date.year,date.month,date.day];
}
-(NSString *)dd_formatNianYue
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld年%02ld月",date.year,date.month];
}
-(NSString *)dd_formatYueRi
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%02ld月%02ld日",date.month,date.day];
}
-(NSString *)dd_formatNian
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld年",date.year];
}
-(NSString *)dd_formatShiFenMiao
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld时%02ld分%02ld秒",date.hour,date.minute,date.seconds];
}
-(NSString *)dd_formatShiFen
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld时%02ld分",date.hour,date.minute];
}
-(NSString *)dd_formatFenMiao
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%02ld分%02ld秒",date.minute,date.seconds];
}
-(NSString *)dd_format_yyyy_MM_dd
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld-%02ld-%02ld",date.year,date.month,date.day];
}
-(NSString *)dd_format_yyyy_MM
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld-%02ld",date.year,date.month];
}
-(NSString *)dd_format_MM_dd
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%02ld-%02ld",date.month,date.day];
}
-(NSString *)dd_format_yyyy
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%ld",date.year];
}
-(NSString *)dd_format_HH_mm_ss
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",date.hour,date.minute,date.seconds];
}
-(NSString *)dd_format_HH_mm
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%02ld:%02ld",date.hour,date.minute];
}
-(NSString *)dd_format_mm_ss
{
    NSDate *date = [NSDate dd_dateWithDateString:self];
    return [NSString stringWithFormat:@"%02ld:%02ld",date.minute,date.seconds];
}

-(NSString *)dd_formatWeekDay
{
    NSString *weekStr=nil;
    NSDate *date = [NSDate dd_dateWithDateString:self];
    switch (date.weekday) {
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
        case 1:
            weekStr = @"星期天";
            break;
        default:
            break;
    }
    return weekStr;
}
@end
