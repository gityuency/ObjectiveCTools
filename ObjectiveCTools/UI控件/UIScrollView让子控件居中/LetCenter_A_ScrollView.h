//
//  LetCenter_A_ScrollView.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/7/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LetCenter_A_ScrollView : UIScrollView

/// 初始化 子控件宽度固定
- (instancetype)initWithFrameFixedSubViewWidth:(CGRect)frame;

/// 初始化 子控件宽度随机
- (instancetype)initWithFrameRandomSubViewWidth:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
