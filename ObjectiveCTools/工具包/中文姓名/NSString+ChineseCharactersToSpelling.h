//
//  NSString+ChineseCharactersToSpelling.h
//  
//
//  Created by crf on 16/7/28.
//  Copyright © 2016年 crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ChineseCharactersToSpelling)

/// 汉字转拼音
- (NSString *)lowercaseSpellingWithChineseCharacters;

@end
