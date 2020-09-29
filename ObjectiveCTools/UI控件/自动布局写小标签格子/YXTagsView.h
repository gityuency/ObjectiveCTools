//
//  YXTagsView.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/9/29.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXTagsView : UIView

/// 初始化
- (instancetype)init;
/// 行间距
@property (nonatomic) CGFloat spacingRow;
/// 列间距
@property (nonatomic) CGFloat spacingColumn;
/// 内容缩进
@property (nonatomic) UIEdgeInsets contentInset;
/// 加载小格子
@property (nonatomic, strong) NSArray <NSString *> *arrayTags;

@end

NS_ASSUME_NONNULL_END
