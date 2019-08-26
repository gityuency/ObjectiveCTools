//
//  NSDateComponents+YXDateComponentsCategory.m
//  ObjectiveCTools
//
//  Created by EF on 2019/8/26.
//  Copyright © 2019 姬友大人. All rights reserved.
//

#import "NSDateComponents+YXDateComponentsCategory.h"

@implementation NSDateComponents (YXDateComponentsCategory)

+(NSDateComponents *)dd_dateComponentsFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal fromDate:date];
    return components;
    
}
@end
