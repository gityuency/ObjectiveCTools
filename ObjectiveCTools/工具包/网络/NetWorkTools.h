//
//  NetWorkTools.h
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <ifaddrs.h>//获取ip地址
#import <arpa/inet.h>//获取ip地址
#import <UIKit/UIKit.h>

@interface NetWorkTools : NSObject

/// 网络状态
+ (NSString *)getNetWorkStates;

/// 网络IP地址
+ (NSString *)getIPAddress;

/// 获取运营商
- (NSString *)getEquipmentCarrier;

/// 获取状态栏上的网络状况
- (NSString *)getStatusBarNetWork;

@end
