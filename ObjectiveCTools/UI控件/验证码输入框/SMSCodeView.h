//
//  SMSCodeView.h
//  ObjectiveCTools
//
//  Created by aidong on 2020/10/13.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSCodeView : UIView

///文字
@property (nonatomic, strong) NSString *text;

///显示光标 默认关闭
@property (nonatomic) BOOL showCursor;

@end

NS_ASSUME_NONNULL_END
