//
//  LZGoalReviewViewOC.h
//  滑动
//
//  Created by EF on 2019/7/12.
//  Copyright © 2019 EF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 这是第二个版本...  没有写完, 暂时就这样吧

IB_DESIGNABLE
@interface LZGoalReviewViewOC : UIControl

@property (nonatomic, assign) IBInspectable NSInteger value;

@property (nonatomic, assign) IBInspectable NSInteger totalCount;

@end


IB_DESIGNABLE
@interface LZInfoView : UIView

- (void)setInfo:(NSString *)index desc:(NSString *)description;
- (void)setInfoViewColor:(BOOL)defaultColor;

@end


@interface LZCircularLayer : CALayer

@property (nonatomic, strong) CALayer *highLightLayer;

@end


NS_ASSUME_NONNULL_END
