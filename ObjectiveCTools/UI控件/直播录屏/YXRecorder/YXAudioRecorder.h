//
//  YXAudioRecorder.h
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/22.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 音频录制代理
@protocol YXAudioRecorderDelegate<NSObject>

@optional

/**
 录音结束

 @param recordFilePath 录音所在的沙盒路径
 */
- (void)audioRecorderDidComplete:(NSString *)recordFilePath;

@end

/// 音频录制工具
@interface YXAudioRecorder : NSObject

/// 初始化
- (instancetype)init;

/// 代理
@property (nonatomic, weak) id<YXAudioRecorderDelegate>delegate;

/// 开始录音
- (BOOL)startRecord;

/// 结束录音
- (void)stopRecord;

/// 暂停录音
-(void)pauseRecord;

/// 继续录音
-(void)resumeRecord;

@end

NS_ASSUME_NONNULL_END
