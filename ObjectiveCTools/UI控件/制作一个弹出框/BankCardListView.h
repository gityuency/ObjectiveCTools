//
//  BankCardListView.h
//  CrfLease
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 yuency. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 银行卡列表弹框
@interface BankCardListView : UIView

typedef void(^BCLVBlockSelection)(NSInteger selectedIndex);
typedef void(^BCLVBlockAdd)(void);

+ (void)showWith:(NSString *)title list:(NSArray<NSString *> *)listArray selectIndex:(BCLVBlockSelection)blockSelect addNew:(BCLVBlockAdd)blockAdd;

@end

