//
//  HandleImageView.h
//  涂鸦
//
//  Created by 姬友大人 on 2018/11/2.
//  Copyright © 2018年 comming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HandleImageView;

NS_ASSUME_NONNULL_BEGIN

@protocol HandleImageViewDelegate <NSObject>

- (void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)newImage;

@end


@interface HandleImageView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) id<HandleImageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
