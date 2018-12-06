//
//  RebateTradingKeyBoardView.h
//
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 yuency. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PasswordBlock)(NSString *password);
typedef void(^KeyBodrdHidenBlock)(void);
typedef void(^ForgetPassWordBlock)(void);

/// 租赁返 交易密码键盘
@interface RebateTradingKeyBoardView : UIView

+ (void)showWith:(NSString *)title sub:(NSString *)subTitle password:(PasswordBlock)actionPwd hiden:(KeyBodrdHidenBlock)actionHiden forget:(ForgetPassWordBlock)actionForget;

@end

