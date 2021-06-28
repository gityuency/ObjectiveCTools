//
//  AboutTimeViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2021/6/28.
//  Copyright © 2021 姬友大人. All rights reserved.
//

#import "AboutTimeViewController.h"

@interface AboutTimeViewController ()

@end

@implementation AboutTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    NSString *timestring = @"2020-06-28 10:30";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateServer = [formatter dateFromString:timestring];
    NSLog(@"服务器时间(转东八): %@", dateServer);
 
    
    NSDate *datePhone = [NSDate date];
    NSTimeZone *GMT8Zone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSInteger interval = [GMT8Zone secondsFromGMTForDate:datePhone];
    NSDate *localGTM8Date = [datePhone dateByAddingTimeInterval: interval];
    NSLog(@"手机当前时间(转东八): %@",localGTM8Date);

    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *com1 = [calendar components:unitFlags fromDate:dateServer];
    NSString *calendarServertime = [NSString stringWithFormat:@"今日%ld月%ld日 %ld时%ld分",(long)com1.month,(long)com1.day,(long)com1.hour,(long)com1.minute];
    NSLog(@"服务器日历时间(转东八): %@", calendarServertime);
    
    
    //NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    //NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *com2 = [calendar components:unitFlags fromDate:datePhone];
    NSString *calendarPhonetime = [NSString stringWithFormat:@"今日%ld月%ld日 %ld时%ld分",(long)com2.month,(long)com2.day,(long)com2.hour,(long)com2.minute];
    NSLog(@"手机当前日历时间(转东八): %@", calendarPhonetime);
}
    
@end
