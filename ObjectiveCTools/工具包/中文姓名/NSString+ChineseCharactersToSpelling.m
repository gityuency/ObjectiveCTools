//
//  NSString+ChineseCharactersToSpelling.m
//
//
//  Created by crf on 16/7/28.
//  Copyright © 2016年 crfchina. All rights reserved.
//

#import "NSString+ChineseCharactersToSpelling.h"

@implementation NSString (ChineseCharactersToSpelling)

- (NSString *)lowercaseSpellingWithChineseCharacters {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //返回小写拼音
    return [str lowercaseString];
}
@end
