//
//  AsyncDemoView.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/7/6.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncDemoView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

///名字
@property (nonatomic, strong) NSString *string;
///头像
@property (nonatomic, strong) UIImage *image;


@end

NS_ASSUME_NONNULL_END
