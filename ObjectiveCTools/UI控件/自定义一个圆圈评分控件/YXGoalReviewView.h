//
//  YXGoalReviewView.h
//  ObjectiveCTools
//
//  Created by EF on 2019/7/29.
//  Copyright © 2019 ChinaRapidFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface YXGoalReviewView : UIControl

@property (assign, nonatomic) NSInteger cellSection;

@property (nonatomic, assign) IBInspectable NSInteger value;

@property (nonatomic, assign) IBInspectable NSInteger totalCount;

@property (nonatomic, strong) NSArray <NSString *>* stringsArray;

@end



IB_DESIGNABLE
@interface InfoView : UIView

- (void)setInfo:(NSString *)index desc:(NSString *)description;
- (void)setInfoViewColor:(BOOL)defaultColor;

@end


@interface CircularLayer : CALayer

@property (nonatomic, strong) CALayer *highLightLayer;

@end



IB_DESIGNABLE
@interface LZGoalReviewDoneView : UIView

@property (nonatomic, assign) IBInspectable NSInteger value;

@property (nonatomic, assign) IBInspectable NSInteger totalCount;

@end

NS_ASSUME_NONNULL_END
