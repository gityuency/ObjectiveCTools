//
//  LetCenter_FixedWidth_UIScrollView.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/9/29.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LetCenter_FixedWidth_UIScrollView : UIScrollView

/// 初始化 子控件宽度固定
- (instancetype)initWithFrameFixedSubViewWidth:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
