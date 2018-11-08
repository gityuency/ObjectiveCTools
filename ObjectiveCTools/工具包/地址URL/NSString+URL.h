//
//  NSString+URL.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/// 是否合法的 URL 地址 (只能校验开头和长度) 没有验证
- (BOOL)isValidHttpUrl;

/// 截取 URL 中参数  放入字典 没有验证
- (NSMutableDictionary *)getURLParameters;

@end
