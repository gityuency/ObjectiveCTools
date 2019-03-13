//
//  YXReplayManager.m
//  YX_ReplayKitDemo
//
//  Created by HPCL20190110 on 2019/3/13.
//  Copyright © 2019 qiu. All rights reserved.
//

#import "YXReplayManager.h"
#import <Photos/Photos.h>
#import <ReplayKit/ReplayKit.h>
#import <objc/runtime.h>

@implementation YXReplayManager

/// 单例对象
static YXReplayManager *_instance;

/// 录制对象
static RPScreenRecorder *recorder;


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        recorder = [RPScreenRecorder sharedRecorder];
        recorder.microphoneEnabled = YES;
    });
    return _instance;
}
+ (instancetype)sharedManager {
    return [[self alloc] init];
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}


/// 申请权限
+ (void)demandForAuthorization:(void(^)(void))authorizedResultBlock {
    // 先去 info.plit 开启相册权限,否则真机崩溃
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        if (authorizedResultBlock) {  //已经授权
            authorizedResultBlock();
        }
        NSLog(@"相册权限已经存在");
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (authorizedResultBlock) {  // 用户点击 "OK"
                        authorizedResultBlock();
                    }
                });
                NSLog(@"相册权限已经授权 用户授权");
            } else {
                NSLog(@"玩你妈嗨");  // 用户点击 不允许访问
            }
        }];
    }
}


#pragma mark - 开始录制
/// 开始记录
- (void)startRecording {
    
    [YXReplayManager demandForAuthorization:^{
        [_instance turnOnRecord];
    }];
}
/// 开始记录
- (void)turnOnRecord {
    
    if (recorder.isRecording) { //已经在录制,就返回
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        [recorder startRecordingWithHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"录制开始... 10.0 系统");
            }
        }];
    } else {
        if (@available(iOS 9.0, *)) {
            [recorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"录制开始... 9.0 系统");
                }
            }];
        }
    }
}


#pragma mark - 停止录制
/// 停止录制
- (void)stopRecording {
    [_instance turnOffRecord];
}

/// 停止录制
- (void)turnOffRecord {
    
    NSLog(@"结束录制");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            NSLog(@"结束回调");
            
            if (error) {  //出错
                NSLog(@"出错: %@", error);
            } else {  //成功回调
                
                // 在iOS9 里面取不到 movieURL 这个变量,程序会崩溃.
                NSURL *videoURL = [previewViewController valueForKey:@"movieURL"];
                
                if (videoURL) {
                    BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoURL path]);
                  
                    if (compatible) {
                        UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
                    }

                } else {
                    NSLog(@"没有找到 movieURL");
                }
            }
        }];
    });
}

/// 保存视频之后的回调,这个方法不能乱写
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    
    if (error) {
        NSLog(@"保存视频失败!!!");
    } else {
        NSLog(@"已经成功保存了视频!");
    }
}


@end
