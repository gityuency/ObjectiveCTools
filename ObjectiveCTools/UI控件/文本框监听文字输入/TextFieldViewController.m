//
//  TextFieldViewController.m
//  ObjectiveCTools
//
//  Created by 姬友大人 on 2018/8/27.
//  Copyright © 2018年 姬友大人. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()

#pragma mark - 第一种方案,属性
@property (weak, nonatomic) IBOutlet UITextField *t;

@property (weak, nonatomic) IBOutlet UILabel *l;

@property (weak, nonatomic) IBOutlet UILabel *lc;

#pragma mark - 第二种方案,属性

@property (weak, nonatomic) IBOutlet UITextField *t_2;
@property (weak, nonatomic) IBOutlet UILabel *l_2;



@end

@implementation TextFieldViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"监听输入框里输入的文本";
    
    [self planA];
    
    [self planB];
    
}

#pragma mark - 第一种方案
- (void)planA {
    //第一种  需要移除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self.t];
}

- (void)textFieldDidChangeValue:(NSNotification *)notification {
    UITextField *sender = (UITextField *)[notification object];
    self.l.text = sender.text;
    self.lc.text = [NSString stringWithFormat:@"方案1 个数: %lu",sender.text.length];
}


#pragma mark - 第二种方案
- (void)planB {
    
    [_t_2 addTarget:self action:@selector(t_2_DidChangeValue:) forControlEvents:UIControlEventEditingChanged];
}

- (void)t_2_DidChangeValue:(id)sender {
    UITextField *t = (UITextField *)sender;
    self.l_2.text = t.text;
    self.lc.text = [NSString stringWithFormat:@"方案2 个数: %lu",t.text.length];
}


@end

/*
 
 这里记录键盘通知
 
 
 #import "ViewController.h"
 @interface ViewController ()
 @property(nonatomic ,strong) UITextField * firstResponderTextF;//记录将要编辑的输入框
 @end
 @implementation ViewController
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 //监听键盘展示和隐藏的通知
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
 }
 - (void)dealloc{
 //移除键盘通知监听者
 [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
 [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
 }
 
 -(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 if ([self.firstResponderTextF isFirstResponder])[self.firstResponderTextF resignFirstResponder];
 }
 #pragma maek UITextFieldDelegate
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 self.firstResponderTextF = textField;//当将要开始编辑的时候，获取当前的textField
 return YES;
 }
 - (BOOL)textFieldShouldReturn:(UITextField *)textField{
 [textField resignFirstResponder];
 return YES;
 }
 #pragma mark : UIKeyboardWillShowNotification/UIKeyboardWillHideNotification
 - (void)keyboardWillShow:(NSNotification *)notification{
 CGRect rect = [self.firstResponderTextF.superview convertRect:self.firstResponderTextF.frame toView:self.view];//获取相对于self.view的位置
 NSDictionary *userInfo = [notification userInfo];
 NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];//获取弹出键盘的fame的value值
 CGRect keyboardRect = [aValue CGRectValue];
 keyboardRect = [self.view convertRect:keyboardRect fromView:self.view.window];//获取键盘相对于self.view的frame ，传window和传nil是一样的
 CGFloat keyboardTop = keyboardRect.origin.y;
 NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//获取键盘弹出动画时间值
 NSTimeInterval animationDuration = [animationDurationValue doubleValue];
 if (keyboardTop < CGRectGetMaxY(rect)) {//如果键盘盖住了输入框
 CGFloat gap = keyboardTop - CGRectGetMaxY(rect) - 10;//计算需要网上移动的偏移量（输入框底部离键盘顶部为10的间距）
 __weak typeof(self)weakSelf = self;
 [UIView animateWithDuration:animationDuration animations:^{
 weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, gap, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
 }];
 }
 }
 - (void)keyboardWillHide:(NSNotification *)notification{
 NSDictionary *userInfo = [notification userInfo];
 NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//获取键盘隐藏动画时间值
 NSTimeInterval animationDuration = [animationDurationValue doubleValue];
 if (self.view.frame.origin.y < 0) {//如果有偏移，当影藏键盘的时候就复原
 __weak typeof(self)weakSelf = self;
 [UIView animateWithDuration:animationDuration animations:^{
 weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);//注意如果带有导航则view的y值就不说0了而是状态栏高度加导航栏的高度
 }];
 }
 }
 @end
 

 */
