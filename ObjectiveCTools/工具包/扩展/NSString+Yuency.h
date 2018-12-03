//
//  NSString+Yuency.h
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/3.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Yuency)

/// 对字符串编码 这个对于特殊字符也做了编码
- (NSString *)yx_encodedString;

/// 字符串加密 SHA-256
- (NSString *)yx_encryptedSHA256;

@end

