//
//  YXReplayManager.h
//  YX_ReplayKitDemo
//
//  Created by HPCL20190110 on 2019/3/13.
//  Copyright © 2019 qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXReplayManager : NSObject

/// 单例对象
+ (instancetype)sharedManager;

/// 用于查看相册和麦克风权限是否已经获取;
+ (void)demandForAuthorization:(void(^)(void))authorizedResultBlock;

/// 开始记录
- (void)startRecording;

/// 停止记录
- (void)stopRecording;

@end

NS_ASSUME_NONNULL_END
