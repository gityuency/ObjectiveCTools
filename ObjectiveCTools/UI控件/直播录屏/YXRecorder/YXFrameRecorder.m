//
//  YXFrameRecorder.m
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/26.
//  Copyright © 2019 HPCL20190110. All rights reserved.
//

#import "YXFrameRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "YXFilePath.h"

@interface YXFrameRecorder()

@property (nonatomic, strong) AVAssetWriter *videoWriter;

@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;

@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *avAdaptor;

/// 每一帧间隔的时间
@property (nonatomic, assign) NSInteger frameSpace;

/// 视频帧间隔时间累加
@property (nonatomic, assign) NSInteger indexOfFrameTimePoint;

/// 定时器,截屏
@property (nonatomic, strong) dispatch_source_t timer;

/// 是否正在录制
@property (nonatomic, assign) BOOL isRecording;

/// 标记是否重复点击开始
@property (nonatomic, assign) BOOL isRestart;

/// 当前屏幕
@property (nonatomic, strong) UIWindow *window;
/// 屏幕尺寸
@property (nonatomic, assign) CGSize screenSize;

/// 屏幕缩放比例
@property (nonatomic, assign) CGFloat screenScale;

/// 视频文件路径
@property (nonatomic, strong, readonly) NSString *recordFilePath;

@end


@implementation YXFrameRecorder

- (instancetype)init {
    
    if (self = [super init]) {
        
        _isRecording = NO;
        
        _isRestart = NO;
        
        //默认帧率为10 一秒钟 10 帧, 定时器 每隔 0.1 秒执行以下
        _frameRate = 10;
        
        //100毫秒执行一次, 1 秒 定时器执行 10次
        _frameSpace = 1000 / _frameRate;
        
        _window = [UIApplication sharedApplication].keyWindow;
        
        _screenSize = _window.bounds.size;
        
        _screenScale = [UIScreen mainScreen].scale;
        
        //在创建这个类的对象的时候初始化视频写入类, 为开始录制的时候节省时间
        [self initAVAsserts];
        
    }
    
    return self;
}

/// 重写set方法, 设置帧率 和 间隔
- (void)setFrameRate:(NSInteger)frameRate {
    _frameRate = frameRate;
    _frameSpace = 1000 / _frameRate;
}


- (void)dealloc {
    
    [self cleanAVAsserts];
    
    NSLog(@"⭕️ 成功释放 %s", __func__);
}

#pragma mark - 开始录制
/// 开始录制
- (BOOL)startRecord {
    
    if (_isRestart) { //不允许重复点击开始
        NSAssert(NO, @"不能重复点击开始!");
        return NO;
    }
    
    if (_isRecording) {
        
        NSLog(@"⭕️ 视频 正在录制中");
        return NO;
        
    } else {
        
        _isRecording = YES;
        
        _isRestart = YES;
        
        _indexOfFrameTimePoint = 0;
        
        // 开始录制
        [_videoWriter startWriting];
        [_videoWriter startSessionAtSourceTime:CMTimeMake(0, 1000)];
        
        NSLog(@"✅ 视频 已开始录制");
        
        __weak typeof(self) weakself = self;
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, NSEC_PER_MSEC * _frameSpace, 0);
        dispatch_source_set_event_handler(_timer, ^{
            
            [weakself drawFrame];
            
        });
        dispatch_resume(_timer);
        
        return YES;
    }
}


#pragma mark - 暂停录制
/// 暂停录制
- (void)pauseRecord {
    
    if (_isRecording) { //处于正在录制
        
        _isRecording = NO;
        
        NSLog(@"⭕️ 视频 录制暂停");
        
    } else {  //处于暂停
        NSLog(@"⭕️ 视频录制 已经 处于暂停");
    }
}


#pragma mark - 继续录制
/// 继续录制
- (void)resumeRecord {
    
    if (_isRecording) { //处于正在录制
        NSLog(@"⭕️ 视频 正在录制中");
    } else {
        _isRecording = YES;
        NSLog(@"♓️ 视频 录制继续");
    }
}


#pragma mark - 结束录制
/// 结束录制
- (void)stopRecord {
    
    if (_isRestart == NO) {  //表示还没有开始录制, 点击结束不做操作
        NSLog(@"⭕️ 录屏 已经 处于结束");
        return;
    }
    
    NSLog(@"✅ 视频录制结束");
    
    _isRecording = NO;
    
    dispatch_source_cancel(_timer);
    
    [_videoWriterInput markAsFinished];
    
    __weak typeof(self) weakself = self;
    [_videoWriter finishWritingWithCompletionHandler:^{
        
        NSLog(@"✅ 视频录制成功回调");
        
        weakself.isRestart = NO;
        
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(frameRecorderDidComplete:)]) {
            [weakself.delegate frameRecorderDidComplete:weakself.recordFilePath];
        }
        
        [weakself cleanAVAsserts];
        
        // 在录制结束的时候 重新初始化新的视频写入对象 在下一次录制的时候就不用在开始录制的时候初始化这些对象, 节省掉初始化这些对象的时间
        [weakself initAVAsserts];
        
    }];
}

#pragma mark - 写入视频帧
///写入视频帧
- (void)writeVideoFrameAtTime:(CMTime)time addImage:(CGImageRef)newImage {
    
    
    //视频输入是否准备接受更多的媒体数据
    if (![_videoWriterInput isReadyForMoreMediaData]) {
        NSLog(@"❌ 视频写入器没有准备好,终止");
        return;
    }
    
    CVPixelBufferRef pixelBuffer = NULL;
    
    CFDataRef imgData = CGDataProviderCopyData(CGImageGetDataProvider(newImage));
    
    
    /*
     原作者的话: 
     1、进入后台就结束录制，唤醒了继续录制，然后录制的视频融合成一个视频
     2、解决进入后台之后 avAdaptor.pixelBufferPool 会被自动释放的问题，但是avAdaptor.pixelBufferPool 是只读的，欢迎大牛帮忙 fix it.
     3、在进入后台的时候结束录制, 保存第一段视频, 在回到前台的时候自动录制, 等待操作结束后, 把两段视频拼接起来.
     */
    
    int status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, _avAdaptor.pixelBufferPool, &pixelBuffer);
    if(status != 0){
        NSLog(@"❌  创建缓存池错误 pixel buffer:  status = %d", status);
    }
    
    // 把图片添加到池子
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    uint8_t* destPixels = CVPixelBufferGetBaseAddress(pixelBuffer);
    //XXX:  will work if the pixel buffer is contiguous and has the same bytesPerRow as the input data
    CFDataGetBytes(imgData, CFRangeMake(0, CFDataGetLength(imgData)), destPixels);
    
    if(status == 0) {
        
        BOOL success = [_avAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:time];
        if (!success)
            NSLog(@"警告:  Unable to write buffer to video");
    }
    
    // 清理掉数据,内存暴涨
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    CVPixelBufferRelease(pixelBuffer);
    CGImageRelease(newImage);
    CFRelease(imgData);
    
}


- (void)drawFrame {
    
    if (!_isRecording) {  //已处于暂停的时候就停止视频的写入
        return;
    }
    
    UIGraphicsBeginImageContextWithOptions(_screenSize, NO, _screenScale);
    
    [_window drawViewHierarchyInRect:_window.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef cgImage = CGImageCreateCopy(image.CGImage);
    
    image = nil;
    
    [self writeVideoFrameAtTime:CMTimeMake(_indexOfFrameTimePoint, 1000) addImage:cgImage];
    
    _indexOfFrameTimePoint += _frameSpace;
}



#pragma mark - 初始化视频写入工具类
/// 初始化视频写入工具类
- (void)initAVAsserts {
    
    CGSize size = CGSizeMake(_screenSize.width * _screenScale, _screenSize.height * _screenScale);
    
    _recordFilePath = [YXFilePath createVideoPath];
    
    //configure videoWriter
    NSURL *fileUrl = [NSURL fileURLWithPath:_recordFilePath];
    
    NSError *error = nil;
    
    _videoWriter = [[AVAssetWriter alloc] initWithURL:fileUrl fileType:AVFileTypeQuickTimeMovie error:&error];
    
    NSAssert1(_videoWriter, @"❌ AVAssetWriter 初始化失败 %@", error);
    
    NSDictionary *videoCompression = @{
                                       AVVideoAverageBitRateKey: @(size.width * size.height)
                                       };
    
    
    NSDictionary *videoSettings = @{
                                    AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: @(size.width),
                                    AVVideoHeightKey: @(size.height),
                                    AVVideoCompressionPropertiesKey: videoCompression
                                    };
    
    
    _videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSAssert(_videoWriter, @"❌ AVAssetWriterInput 初始化失败");
    
    _videoWriterInput.expectsMediaDataInRealTime = YES;
    
    
    /*
     原作者的话:
     
     kCVPixelBufferPixelFormatTypeKey:
     之前配置的下边注释掉的context使用的是kCVPixelFormatType_32ARGB，用起来颜色没有问题。
     但是用UIGraphicsBeginImageContextWithOptions([[UIApplication sharedApplication].delegate window].bounds.size, YES, 0);
     配置的context使用kCVPixelFormatType_32ARGB的话颜色会变成粉色，替换成kCVPixelFormatType_32BGRA之后，颜色正常。。。
     
     kCVPixelBufferWidthKey:
     这个位置包括下面的两个，必须写成(int)size.width/16*16,因为这个的大小必须是16的倍数，否则图像会发生拉扯、挤压、旋转。。。。不知道为啥
     
     */
    
    NSDictionary *attribute = @{
                                (NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA),
                                (NSString *)kCVPixelBufferWidthKey: @(size.width),
                                (NSString *)kCVPixelBufferHeightKey: @(size.height),
                                (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @(YES),
                                
                                };
    
    _avAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_videoWriterInput sourcePixelBufferAttributes:attribute];
    
    NSAssert(_videoWriter, @"❌ AVAssetWriterInputPixelBufferAdaptor 初始化失败");
    
    [_videoWriter addInput:_videoWriterInput];
    
    NSLog(@"✅ 视频工具准备完毕!");
    
}

#pragma mark - 清除本次视频录制对象
/// 清除本次视频录制对象
- (void) cleanAVAsserts {
    _avAdaptor = nil;
    _videoWriterInput = nil;
    _videoWriter = nil;
}


@end
