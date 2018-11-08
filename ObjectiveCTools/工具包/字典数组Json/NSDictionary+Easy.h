//
//  NSDictionary+Easy.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
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
