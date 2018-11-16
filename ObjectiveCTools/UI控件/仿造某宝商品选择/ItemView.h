//
//  ItemView.h
//  姬友大人
//
//  Created by 姬友大人 on 2019/7/19.
//  Copyright © 2019年 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemView;

/// 视图的协议
@protocol ItemViewDelegate <NSObject>

@optional
-(void)didSelected:(ItemView *)itemView;

@end

/// 格子
@interface ItemView : UIView
/// 按钮事件代理
@property (nonatomic, weak) id<ItemViewDelegate> delegate;
/// 是否是多行
@property (nonatomic, assign) BOOL isMultiLines;
/// 位置
@property (nonatomic, strong) NSIndexPath *indexPath;
/// 设置选中状态
@property (nonatomic, assign) BOOL itemSelected;
/// 设置不可选
@property (nonatomic, assign) BOOL itemDisable;
/// 设置 文本框的文字 文字的最小宽度 最大宽度 文字的字体
- (void)setText:(NSString *)text minWith:(CGFloat)minWith maxWith:(CGFloat)maxWith font:(UIFont *)font;

@end
