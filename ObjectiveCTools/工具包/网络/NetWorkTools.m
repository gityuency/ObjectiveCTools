//
//  NetWorkTools.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/7/31.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "NetWorkTools.h"

@implementation NetWorkTools

#pragma mark 网络状态
+ (NSString *)getNetWorkStates{

    NSString *state = @"NULL";
    
        CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus = telephonyInfo.currentRadioAccessTechnology;
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
            //GPRS网络
            state = @"2G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
            //2.75G的EDGE网络
            state = @"2G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
            //3G WCDMA网络
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
            //3.5G网络
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
            //3.5G网络
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
            //CDMA2G网络
            state = @"2G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
            //CDMA的EVDORev0(应该算3G吧?)
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
            //CDMA的EVDORevA(应该也算3G吧?)
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
            //CDMA的EVDORev0(应该是算3G吧?)
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
            //HRPD网络
            state = @"HRPD";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
            //LTE4G网络
            state = @"4G";
        }

    return state;
}

#pragma mark 获取IP地址
+ (NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark 获取运营商
- (NSString *)getEquipmentCarrier {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *carrierName = [NSString stringWithFormat:@"%@",carrier.carrierName];
    return carrierName;
}


#pragma mark 获取状态栏上的网络状况
- (NSString *)getStatusBarNetWork {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                default:
                    break;
            }
        }
    }
    return state;
}

@end
