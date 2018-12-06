//
//  RebateTradingKeyBoardView.m
//  
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 yuency. All rights reserved.
//

#import "RebateTradingKeyBoardView.h"

@interface RebateTradingKeyBoardView()

/// 输入框背景
@property (weak, nonatomic) IBOutlet UIView *viewInput;
/// 标题
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
/// 副标题
@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;
/// 关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;
/// 密文黑点
@property (weak, nonatomic) IBOutlet UIView *viewPoint1;
@property (weak, nonatomic) IBOutlet UIView *viewPoint2;
@property (weak, nonatomic) IBOutlet UIView *viewPoint3;
@property (weak, nonatomic) IBOutlet UIView *viewPoint4;
@property (weak, nonatomic) IBOutlet UIView *viewPoint5;
@property (weak, nonatomic) IBOutlet UIView *viewPoint6;
/// 密码
@property (nonatomic, strong) NSMutableString *password;
/// 密文黑点数组
@property (nonatomic, strong) NSArray *arrayPointView;

@end

@implementation RebateTradingKeyBoardView

static PasswordBlock actionPasswordBlock = nil;
static KeyBodrdHidenBlock actionKeyBodrdHidenBlock = nil;
static ForgetPassWordBlock actionForgetPassWordBlock = nil;
static RebateTradingKeyBoardView *keyBoardView = nil;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    _password = [NSMutableString string];
    _arrayPointView = @[_viewPoint1, _viewPoint2, _viewPoint3, _viewPoint4, _viewPoint5, _viewPoint6];
    for (UIView *v in _arrayPointView) {
        v.hidden = YES;
    }
    self.frame =  [UIScreen mainScreen].bounds;
    _viewInput.layer.borderColor = [UIColor colorWithRed:74/255.0 green:162/255.0 blue:255/255.0 alpha:1].CGColor;
}

+ (void)showWith:(NSString *)title sub:(NSString *)subTitle password:(PasswordBlock)actionPwd hiden:(KeyBodrdHidenBlock)actionHiden forget:(ForgetPassWordBlock)actionForget {
    keyBoardView = [[NSBundle mainBundle] loadNibNamed:@"RebateTradingKeyBoardView" owner:nil options:nil].firstObject;
    keyBoardView.labelTitle.text = title;
    keyBoardView.labelSubTitle.text = subTitle;
    actionPasswordBlock = actionPwd;
    actionKeyBodrdHidenBlock = actionHiden;
    actionForgetPassWordBlock = actionForget;
    [[[UIApplication sharedApplication].delegate window] addSubview:keyBoardView];
}

- (void)disMiss{
    [self removeFromSuperview];
    actionPasswordBlock = nil;
    actionForgetPassWordBlock = nil;
    actionKeyBodrdHidenBlock = nil;
    keyBoardView = nil;
}

/// 关闭 x
- (IBAction)buttonActionClose:(UIButton *)sender {
    actionKeyBodrdHidenBlock();
    [self disMiss];
}

/// 隐藏键盘
- (IBAction)buttonActionHide:(UIButton *)sender {
    actionKeyBodrdHidenBlock();
    [self disMiss];
}

/// 忘记密码
- (IBAction)buttonActionForget:(UIButton *)sender {
    actionForgetPassWordBlock();
    [self disMiss];
}

/// 确定
- (IBAction)buttonActionSure:(UIButton *)sender {
    if (self.password.length == 6) {
        actionPasswordBlock(self.password);
    } else  {
        actionKeyBodrdHidenBlock();
    }
    [self disMiss];
}

/// 删除
- (IBAction)buttonActionDelete:(UIButton *)sender {
    if (self.password.length == 0) {
        return;
    }
    [self.password deleteCharactersInRange:NSMakeRange(self.password.length - 1, 1)];
    [self updatePasswordUI];
}

/// 数字 0-9 小数点
- (IBAction)buttonActionNumber:(UIButton *)sender {
    if (self.password.length == 6) { //已经满了6位
        return;
    }
    if (sender.tag == 10) {
        [self.password appendString:@"."];
    } else {
        [self.password appendString:[NSString stringWithFormat:@"%ld",sender.tag]];
    }
    [self updatePasswordUI];
}

/// 更新 UI
- (void)updatePasswordUI {
    for (int i = 0; i < self.arrayPointView.count; i++) {
        UIView *v = self.arrayPointView[i];
        if (i < self.password.length) {
            v.hidden = NO;
        } else {
            v.hidden = YES;
        }
    }
}

@end
