
/// 单例宏

#ifndef SingleInstance_h

#define SingleInstance_h

/// H文件包含
#define SingleInstanceH(name) + (instancetype)shared##name;  //使用 ##name 作为宏参数替换/拼接字符串
/// M文件包含
#define SingleInstanceM(name) static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
+ (instancetype)shared##name { return [[self alloc] init]; }\
- (id)copyWithZone:(NSZone *)zone { return _instance; }\
- (id)mutableCopyWithZone:(NSZone *)zone { return _instance; }



/*
 #if __has_feature(objc_arc)
 //ARC
 #else
 //MRC
 - (oneway void)release { }
 - (instancetype)retain { }
 - (NSUInteger)retainCount { return MAXFLOAT; }
 #endif
 */


#endif /* SingleInstance_h */







