//
//  SkillDevice.m
//  ObjectiveCTools
//
//  Created by Yuency on 2018/7/31.
//  Copyright © 2018年 Yuency. All rights reserved.
//

#import "SkillDevice.h"
#import <UIKit/UIKit.h>

@implementation SkillDevice

#pragma mark 判断当前设备 型号 类型
+ (void)skill_1 {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    }else{
    }
}


#pragma mark 获取设备朝向 状态栏
+ (void)skill_2 {
    
    UIInterfaceOrientation currentOrient = [UIApplication sharedApplication].statusBarOrientation;
    NSLog(@"%ld", (long)currentOrient);
    
}



#pragma mark 屏幕中的 window 个数
+ (void)skill_3 {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    NSLog(@"%@", window);
}



@end
