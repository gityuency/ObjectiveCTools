//
//  YXRecorderManager.m
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/22.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//

#import "YXRecorderManager.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "YXAudioRecorder.h"
#import "YXFrameRecorder.h"
#import "YXFilePath.h"

@interface YXRecorderManager() <YXAudioRecorderDelegate, YXFrameRecorderDelegate>

/// 音频录制工具
@property (nonatomic, strong) YXAudioRecorder *yxAudioRecorder;

/// 视频录制工具
@property (nonatomic, strong) YXFrameRecorder *yxFrameRecorder;

/// 音频文件路径
@property (nonatomic, strong) NSString *filePathAudio;

/// 视频文件路径
@property (nonatomic, strong) NSString *filePathVideo;

/// 用来保存后台运行任务的标示符
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@end


@implementation YXRecorderManager

/// 单例对象
static YXRecorderManager *_instance;
static dispatch_once_t onceToken;

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
        
        [_instance demandForRight];
        
        _instance.yxAudioRecorder = [[YXAudioRecorder alloc] init];
        _instance.yxAudioRecorder.delegate = _instance;
        
        _instance.yxFrameRecorder = [[YXFrameRecorder alloc] init];
        _instance.yxFrameRecorder.delegate = _instance;
        
        _instance.filePathAudio = nil;
        _instance.filePathVideo = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(actionEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
        
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}


///进入后台的时候停止录制,防止崩溃  真机: 只能保存到沙盒,无法接连保存到相册  模拟器: 可以接连保存到相册
- (void)actionEnterBackGround {
    
    [_instance.yxFrameRecorder stopRecord];
    
    [_instance.yxAudioRecorder stopRecord];


//    UIApplication *application = [UIApplication sharedApplication];
//    //通知系统, 我们需要后台继续执行一些逻辑
//    __weak typeof (_instance) weakinstance = _instance;
//    _backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        //超过系统规定的后台运行时间, 则暂停后台逻辑
//        [application endBackgroundTask:weakinstance.backgroundTask];
//        weakinstance.backgroundTask = UIBackgroundTaskInvalid;
//    }];
    
}


/// 设置帧率
- (void)setFrameRate:(YXFrameRate)rate {
    
    if (rate == YXFrameRate10 || rate == YXFrameRate15 || rate == YXFrameRate20 || rate == YXFrameRate25 || rate == YXFrameRate30) {
        _instance.yxFrameRecorder.frameRate = rate;
    } else {
        _instance.yxFrameRecorder.frameRate = YXFrameRate10;
    }
}


- (void)demandForRight {
    
    // 相册权限
    PHAuthorizationStatus photoAuth = [PHPhotoLibrary authorizationStatus];
    if (photoAuth == PHAuthorizationStatusAuthorized) {
        NSLog(@"✅ 相册权限已经存在!");
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"✅ 相册已授权!");
                });
            } else {
                NSLog(@"❌ 没有相册权限");
            }
        }];
    }
    
    // 麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        AVAuthorizationStatus avAuth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (avAuth == AVAuthorizationStatusAuthorized) {
            NSLog(@"✅ 麦克风已授权!");
        } else {
            NSLog(@"❌ 没有麦克风权限");
        }
    }];
}


/// 开始录制
- (void)startRecord {
    [_instance.yxFrameRecorder startRecord];
    [_instance.yxAudioRecorder startRecord];
}

/// 暂停录制
- (void)pauseRecord {
    [_instance.yxFrameRecorder pauseRecord];
    [_instance.yxAudioRecorder pauseRecord];
}

/// 继续录制
- (void)resumeRecord {
    [_instance.yxFrameRecorder resumeRecord];
    [_instance.yxAudioRecorder resumeRecord];
}

/// 结束录制
- (void)stopRecord {
    [_instance.yxFrameRecorder stopRecord];
    [_instance.yxAudioRecorder stopRecord];
}



#pragma mark - 音频代理 YXAudioRecorderDelegate
- (void)audioRecorderDidComplete:(NSString *)recordFilePath {
    NSLog(@"✅ 音频回调");
    _instance.filePathAudio = recordFilePath;
    [self mergeAudioAndVideo];
}

#pragma mark - 视频代理 YXFrameRecorderDelegate
- (void)frameRecorderDidComplete:(NSString *)recordFilePath {
    NSLog(@"✅ 视频回调");
    _instance.filePathVideo = recordFilePath;
    [self mergeAudioAndVideo];
}


- (void)mergeAudioAndVideo {
    
    if (!_instance.filePathVideo || !_instance.filePathAudio) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"✅ 子线程 开始合并");
        [YXRecorderManager mergeVideo:_instance.filePathVideo withAudio:_instance.filePathAudio target:self action:@selector(mergedidFinish:WithError:)];
    });
}

#pragma mark - 音频视频合并
+ (void)mergeVideo:(NSString *)videoPath withAudio:(NSString *)audioPath target:(id)target action:(SEL)action {
    
    NSLog(@"〽️ 动作: 合并音频视频 线程 %@", [NSThread currentThread]);
    
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    //混合工具
    AVMutableComposition *mixCom = [AVMutableComposition composition];
    
    //音频
    AVMutableCompositionTrack *audioTrack = [mixCom addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //视频
    AVMutableCompositionTrack *videoTrack = [mixCom addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:mixCom presetName:AVAssetExportPresetPassthrough];
    
    //保存混合后的文件的过程
    NSString *videoName = @"export2.mov";
    NSString *exportPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:videoName];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    assetExport.outputFileType = @"com.apple.quicktime-movie";
    
    assetExport.outputURL = exportUrl;
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^(void) {
        
        NSLog(@"✅ 视频音频合并成功!");
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        if (target && [target respondsToSelector:action]) {
            [target performSelector:action withObject:exportPath];
        }
        
#pragma clang diagnostic pop
        
    }];
}



#pragma mark - 合并完成后的回调
- (void)mergedidFinish:(NSString *)videoPath WithError:(NSError *)error {
    
    NSString *path = [YXFilePath needFinalFilePath];
    
    // 移动合并后的文件到新文件夹里
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        NSError *err = nil;
        BOOL res = [[NSFileManager defaultManager] moveItemAtPath:videoPath toPath:path error:&err];
        res ? NSLog(@"✅ 移动合并后视频文件成功!") : NSLog(@"❌ 移动合并后视频文件失败! %@", err);
    }
    
    _filePathAudio = nil;
    
    _filePathVideo = nil;
    
    NSLog(@"〽️ 动作: 视频保存到相册 线程 %@", [NSThread currentThread]);
    
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo {
    
    if (error) {
        NSLog(@"❌ 保存到相册出错! %@",[error localizedDescription]);
    } else{
        NSLog(@"✅ 已经保存到相册! 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉");
        
        NSLog(@"✅ 路径 \n %@", videoPath);
    }
}


#pragma mark - 销毁对象
/// 销毁对象
+ (void)destoryManager {
    
    [[NSNotificationCenter defaultCenter] removeObserver:_instance];
    
    _instance.yxFrameRecorder = nil;
    _instance.yxAudioRecorder = nil;
    
    [YXFilePath removeAllFile];
    
    onceToken = 0;
    
    _instance = nil;
    
    NSLog(@"⭕️ 成功释放 %s", __func__);
}

@end
