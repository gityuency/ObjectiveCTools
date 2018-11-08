//
//  NSString+Name.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Name)

/// 校验用户姓名 判断是否包含除中文以外的字符（目的：纯中文） 没有验证
- (BOOL)isValidName;

@end
