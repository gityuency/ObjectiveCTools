//
//  YXAudioRecorder.m
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/22.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//

#import "YXAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "YXFilePath.h"

@interface YXAudioRecorder()

/// 系统音频录制工具
@property (nonatomic, strong) AVAudioRecorder *avAudioRecorder;

/// 录音文件路径
@property (nonatomic, strong, readonly) NSString *recordFilePath;

/// 录音参数设置
@property (nonatomic, strong) NSDictionary *recordSetting;

/// 是否正在录制
@property (nonatomic, assign) BOOL isRecording;

@end


@implementation YXAudioRecorder

- (void)dealloc {
    
    [self cleanAVAudio];
    
    NSLog(@"⭕️ 成功释放 %s", __func__);
}


/// 初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        // 在录制的时候,可以同时录制 扬声器里的声音 和 麦克风里的声音
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        // 设置参数
        [self prepareRecordSettings];
        
        // 在初始化的时候,直接初始化系统工具类
        [self prepareRecorder];
        
    }
    return self;
}


/// 清理
- (void)cleanAVAudio {
    
    _avAudioRecorder = nil;
}

/// 参数设置
- (void)prepareRecordSettings {
    
    _recordSetting = @{
                       //设置录音采样率(Hz) 8000/44100/96000（影响音频的质量）
                       AVSampleRateKey: @(96000),
                       //设置录音格式 kAudioFormatLinearPCM
                       AVFormatIDKey: @(kAudioFormatLinearPCM),
                       //线性采样位数  8、16、24、32
                       AVLinearPCMBitDepthKey: @(32),
                       //录音通道数 1:单声道 2:双声道
                       AVNumberOfChannelsKey: @(2),
                       //录音的质量
                       AVEncoderAudioQualityKey: @(AVAudioQualityMax),
                       };
}

#pragma mark - 开始录音
- (void)prepareRecorder {
    
    _isRecording = NO;
    
    //给定路径
    _recordFilePath = [YXFilePath createAudioPath];
    
    NSString *s = [_recordFilePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //初始化录音
    _avAudioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:s] settings:_recordSetting error:nil];
    
    _avAudioRecorder.meteringEnabled = YES;
    
    BOOL res = [_avAudioRecorder prepareToRecord];
    res ? NSLog(@"✅ 录音准备完毕!") : NSLog(@"❌ 录音准备失败!");
    
}


#pragma mark - 录音开始
- (BOOL)startRecord {
    
    if (_isRecording) {
        NSLog(@"⭕️ 音频 正在录制中");
        return NO;

    } else {
        
        _isRecording = [_avAudioRecorder record];
        
        _isRecording ? NSLog(@"✅ 音频 已开始录制") : NSLog(@"❌ 录音开始出错");
        
        return _isRecording;

    }
}


#pragma mark - 录音暂停
- (void)pauseRecord {
    
    if (_isRecording) {
        
        [_avAudioRecorder pause];
        _isRecording = NO;
        
        NSLog(@"⭕️ 音频 录制暂停");
    } else {
        NSLog(@"⭕️ 音频录制 已经 处于暂停");
    }
}


#pragma mark - 录音继续
- (void)resumeRecord {
    
    if (_isRecording) {
        NSLog(@"⭕️ 音频 正在录制中");
    } else {
        NSLog(@"♓️ 音频 录制继续");
        _isRecording = [_avAudioRecorder record];
        _isRecording ? NSLog(@"♓️ 音频 已开始录制") : NSLog(@"❌ 录音开始出错");
    }
}


#pragma mark - 录音结束
- (void)stopRecord {
    
    if (_isRecording) {
        
        [_avAudioRecorder stop];
        
        NSLog(@"✅ 音频录制结束");
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecorderDidComplete:)]) {
            [self.delegate audioRecorderDidComplete:_recordFilePath];
        }
        
        //清掉之前的对象
        [self cleanAVAudio];
        
        //在录制结束的时候重新准备
        [self  prepareRecorder];
        
    } else {
        NSLog(@"⭕️ 录音 已经 处于结束");
    }
}


@end
