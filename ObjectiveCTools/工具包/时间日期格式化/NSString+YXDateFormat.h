//
//  NSString+YXDateFormat.h
//  ObjectiveCTools
//
//  Created by EF on 2019/8/26.
//  Copyright © 2019 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YXDateFormat)

//时间字符串2017-04-16 13:08:06 ->转换

#pragma mark -年月日

///x年x月x日
@property(nonatomic,copy,readonly)NSString *dd_formatNianYueRi;

///x年x月
@property(nonatomic,copy,readonly)NSString *dd_formatNianYue;

///x月x日
@property(nonatomic,copy,readonly)NSString *dd_formatYueRi;

///x年
@property(nonatomic,copy,readonly)NSString *dd_formatNian;

///x时x分x秒
@property(nonatomic,copy,readonly)NSString *dd_formatShiFenMiao;

///x时x分
@property(nonatomic,copy,readonly)NSString *dd_formatShiFen;

///x分x秒
@property(nonatomic,copy,readonly)NSString *dd_formatFenMiao;

///yyyy-MM-dd
@property(nonatomic,copy,readonly)NSString *dd_format_yyyy_MM_dd;

///yyyy-MM
@property(nonatomic,copy,readonly)NSString *dd_format_yyyy_MM;

///MM-dd
@property(nonatomic,copy,readonly)NSString *dd_format_MM_dd;

///yyyy
@property(nonatomic,copy,readonly)NSString *dd_format_yyyy;

///HH:mm:ss
@property(nonatomic,copy,readonly)NSString *dd_format_HH_mm_ss;

///HH:mm
@property(nonatomic,copy,readonly)NSString *dd_format_HH_mm;

///mm:ss
@property(nonatomic,copy,readonly)NSString *dd_format_mm_ss;

/// 星期几: 星期一
@property(nonatomic,copy,readonly)NSString *dd_formatWeekDay;

@end

NS_ASSUME_NONNULL_END
