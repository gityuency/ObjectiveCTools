//
//  UIDevice+Resolutions.m
//
//
//  Created by crf on 15/10/16.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import "UIDevice+Resolutions.h"
#import "sys/utsname.h"

@implementation UIDevice (Resolutions)


+ (UIDeviceResolution) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize size = [[UIScreen mainScreen] bounds].size;
            size = CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale);
            
            if (size.width==640.0f && size.height==1136.0f)
                return UIDevice_iPhone5_5s_5c_se;
            
            else if (size.width==750.0f && size.height==1334.0f)
                return UIDevice_iPhone6_6s_7_8;
            
            else if (size.width==1242.0f && size.height==2208.0f)
                return UIDevice_iPhone6_6s_7_8_Plus;
            
            else if (size.width==1125.0f && size.height==2436.0f)
                return UIDevice_iPhoneX;
            
            else if (size.width==640.0f && size.height<=960.0f)
                return UIDevice_iPhone4_4s;
            
            else
                return UIDevice_iPhone6_6s_7_8_Plus;
            
        } else
            return UIDevice_iPhone6_6s_7_8_Plus;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPad3 : UIDevice_iPad1_2);
}

+ (BOOL)isIPhoneX{
    if ([self currentResolution] == UIDevice_iPhoneX) {
        return YES;
    }
    return NO;
}
+ (BOOL)isIPhone6_6s_7_8{
    if ([self currentResolution] == UIDevice_iPhone6_6s_7_8) {
        return YES;
    }
    return NO;
}
+ (BOOL)isIPhone6_6s_7_8_Plus{
    if ([self currentResolution] == UIDevice_iPhone6_6s_7_8_Plus) {
        return YES;
    }
    return NO;
}
+ (BOOL)isIPhone5_5s_5c_se{
    if ([self currentResolution] == UIDevice_iPhone5_5s_5c_se) {
        return YES;
    }
    return NO;
}
+ (BOOL)isIPhone4_4s{
    if ([self currentResolution] == UIDevice_iPhone4_4s) {
        return YES;
    }
    return NO;
}
+ (BOOL)isIPad1_2{
    if ([self currentResolution] == UIDevice_iPad1_2) {
        return YES;
    }
    return NO;
}
+ (BOOL)isIPad3{
    if ([self currentResolution] == UIDevice_iPad3) {
        return YES;
    }
    return NO;
}

+(NSInteger)getKeywordHeight{
    //获取键盘的高度
    /*
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375
     
     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414
     
     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320
     
     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768
     
     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */
    if([self isIPhone4_4s])
        return 216;
    else if([self isIPhone5_5s_5c_se])
        return 216;
    else if([self isIPhone6_6s_7_8])
        return 216;
    else if([self isIPhone6_6s_7_8_Plus])
        return 216;
    else if([self isIPhoneX])
        return 216;
    else if([self isIPad1_2])
        return 216;
    else if([self isIPad3])
        return 264;
    return 216;
}
//比较系统版本号大小
+(BOOL)isGreaterThanIOS8{
    float versionCode = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (versionCode>=8) {
        return YES;
    }else{
        return  NO;
    }
}
/*
 *判断是否运行在模拟器
 */
+(BOOL)isRunSimulator{
#if TARGET_IPHONE_SIMULATOR //模拟器
    return YES;
#elif TARGET_OS_IPHONE //真机
    return NO;
#endif
    
}
// 获取设备型号然后手动转化为对应名称
+(NSString *)getDeviceName
{
    //iphoneX
    if ([self isIPhoneX]) {
        return @"iPhoneX";
    }
    
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone7 国行、日版、港行";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone7 Plus 港行、国行";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone7 美版、台版";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone7 Plus 美版、台版";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone8 国行(A1863)、日行(A1906)";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone8 美版(Global/A1905)";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone8 Plus  国行(A1864)、日行(A1898)";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone8 Plus 美版(Global/A1897)";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhoneX 国行(A1865)、日行(A1902)";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhoneX 美版(Global/A1901)";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

@end
