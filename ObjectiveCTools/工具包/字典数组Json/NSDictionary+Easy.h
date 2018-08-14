//
//  NSDictionary+Easy.h
//  ObjectiveCTools
//
//  Created by ChinaRapidFinance on 2018/7/31.
//  Copyright © 2018年 ChinaRapidFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Easy)

/// Dic -> JsonString 字典 转 json 字符串
- (NSString *)easyToJsonString;

/// ???
- (NSString *)replaceUnicode:(NSString *)unicodeStr;

/// 对象 模型 转换 字典
+ (NSMutableDictionary *)easyObjectToDictionary:(id)obj;

@end
