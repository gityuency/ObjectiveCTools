//
//  NSDate+YXDateCategory.m
//  ObjectiveCTools
//
//  Created by EF on 2019/8/26.
//  Copyright © 2019 姬友大人. All rights reserved.
//

#import "NSDate+YXDateCategory.h"
#import "NSDateComponents+YXDateComponentsCategory.h"

@implementation NSDate (YXDateCategory)

-(NSInteger)year
{
    NSDateComponents *components = [NSDateComponents dd_dateComponentsFromDate:self];
    return components.year;
}
- (NSInteger) month
{
    NSDateComponents *components =  [NSDateComponents dd_dateComponentsFromDate:self];
    return components.month;
}

- (NSInteger) day
{
    NSDateComponents *components =  [NSDateComponents dd_dateComponentsFromDate:self];
    return components.day;
}

- (NSInteger) hour
{
    NSDateComponents *components =  [NSDateComponents dd_dateComponentsFromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [NSDateComponents dd_dateComponentsFromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components =  [NSDateComponents dd_dateComponentsFromDate:self];
    return components.second;
}

- (NSInteger) weekday
{
    NSDateComponents *components =  [NSDateComponents dd_dateComponentsFromDate:self];
    return components.weekday;
}

+(NSDate *)dd_dateWithDateString:(NSString *)dateString
{
    NSDate *date = nil;
    date = [self dd_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:dateString];
    if(date) return date;
    date = [self dd_dateWithFormat_yyyy_MM_dd_HH_mm_string:dateString];
    if(date) return date;
    date = [self dd_dateWithFormat_yyyy_MM_dd_HH_string:dateString];
    if(date) return date;
    date = [self dd_dateWithFormat_yyyy_MM_dd_string:dateString];
    if(date) return date;
    date = [self dd_dateWithFormat_yyyy_MM_string:dateString];
    if(date) return date;
    return nil;
}

+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_HH_mm_ss_string:(NSString *)string
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_HH_mm_string:(NSString *)string
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_HH_string:(NSString *)string
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

+(NSDate *)dd_dateWithFormat_yyyy_MM_dd_string:(NSString *)string
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

+(NSDate *)dd_dateWithFormat_yyyy_MM_string:(NSString *)string
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}
@end
