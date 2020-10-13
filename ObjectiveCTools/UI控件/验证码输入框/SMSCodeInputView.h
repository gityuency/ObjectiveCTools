//
//  SMSCodeInputView.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/10/13.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSCodeInputView : UIView

///验证码文字
@property (strong, nonatomic) NSString *codeText;

///设置验证码位数 默认 4 位
@property (nonatomic) NSInteger codeCount;

///验证码数字之间的间距 默认 35
@property (nonatomic) CGFloat codeSpace;

@end

NS_ASSUME_NONNULL_END
