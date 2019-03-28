//
//  YXFrameRecorder.h
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/26.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 视频帧录制代理
@protocol YXFrameRecorderDelegate<NSObject>

@optional

/**
 视频录制完成
 
 @param recordFilePath 视频所在的沙盒路径
 */
- (void)frameRecorderDidComplete:(NSString *)recordFilePath;

@end


@interface YXFrameRecorder : NSObject

/// 初始化
- (instancetype)init;

/// 帧率(每秒录制多少帧)
@property (nonatomic, assign) NSInteger frameRate;

/// 代理
@property (nonatomic, weak) id<YXFrameRecorderDelegate> delegate;

///开始录制
- (BOOL)startRecord;

///结束录制
- (void)stopRecord;

///暂停录制
- (void)pauseRecord;

///继续录制
- (void)resumeRecord;

@end

NS_ASSUME_NONNULL_END
