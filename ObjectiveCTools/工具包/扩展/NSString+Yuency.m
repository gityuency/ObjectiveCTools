//
//  NSString+Yuency.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/3.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "NSString+Yuency.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Yuency)


#pragma mark - 对字符串编码
- (NSString *)yx_encodedString {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // 暂时没有找到好的方法替代  消除过期警告
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&;=+$,/?%#[]", kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    
    return encodedString;
}

#pragma mark - 字符串加密 SHA-256
- (NSString *)yx_encryptedSHA256 {
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}


@end
