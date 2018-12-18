//
//  Tools.m
//  ObjectiveCTools
//
//  Created by yuency on 2018/12/18.
//  Copyright © 2018年 yuency. All rights reserved.
//

#import "Tools.h"

@implementation Tools

/// 单例 不要使用继承
static Tools *_instance;

//1.重写开辟内存方法 alloc -> allocWithZone
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    //GCD 线程安全 单利模式需要解决线程安全问题
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

//2.提供类方法
+ (instancetype)sharedTools {
    return [[self alloc] init];
}

//3.严谨
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}


#if __has_feature(objc_arc)
//ARC

#else
//MRC
- (oneway void)release {
    
}
- (instancetype)retain {
    
}
- (NSUInteger)retainCount {
    return MAXFLOAT;
}

#endif

@end
