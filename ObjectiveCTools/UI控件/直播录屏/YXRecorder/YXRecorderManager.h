//
//  YXRecorderManager.h
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/22.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//


/*
 
 重要:
 1. 在使用沙盒进行调试的时候,不要随意删除为这个录制而准备的文件夹, 为了保证音画同步尽量减少每次录制前的准备工作,
    这些文件夹是提前创建出来的,文件夹已经处于使用过程中.轻易删除会导致 YXFrameRecorder 这个类的崩溃.
 
 2. 本代码可以用于直播中的录屏.如果你录的时候黑屏了,请告知我修复,谢谢.
 
 2. 目前只能录制竖屏, 没有做横屏的处理.
 
 3. 代码还有些不够强悍的地方,但是我现在没时间去改了. 比如在运行的时候,请同时允许使用麦克风和相册权限.
 
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YXFrameRate) {
    /// 每秒 10 帧  (在模拟器上如果高于这个值,就会导致视频帧写入失败,因为mac跑起来很卡卡,真机可以运行.)
    YXFrameRate10 = 10,
    /// 每秒 15 帧
    YXFrameRate15 = 15,
    /// 每秒 20 帧
    YXFrameRate20 = 20,
    /// 每秒 25 帧
    YXFrameRate25 = 25,
    /// 每秒 30 帧
    YXFrameRate30 = 30,
};


/// 录制的类
@interface YXRecorderManager : NSObject

/// 单例对象
+ (instancetype)sharedManager;

/// 销毁对象
+ (void)destoryManager;

/// 开始录制
- (void)startRecord;

/// 暂停录制
- (void)pauseRecord;

/// 继续录制
- (void)resumeRecord;

/// 结束录制
- (void)stopRecord;

/// 设置帧率
- (void)setFrameRate:(YXFrameRate)rate;



@end

NS_ASSUME_NONNULL_END
