//
//  SMSCodeInputView.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/10/13.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "SMSCodeInputView.h"
#import "SMSCodeView.h"

@interface SMSCodeInputView () <UITextFieldDelegate>
///输入框
@property (strong, nonatomic) UITextField *textField;
///格子数组
@property (nonatomic,strong) NSMutableArray <SMSCodeView *> *arrayTextFidld;
///记录上一次的字符串
@property (strong, nonatomic) NSString *lastString;
///放置小格子
@property (strong, nonatomic) UIView *contentView;

@end

@implementation SMSCodeInputView

- (instancetype)init {
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    
    _codeCount = 4;  //在初始化函数里面, 如果重写了某个属性的setter方法, 那么使用 self.codeCount 会直接调用重写的 setter 方法, 会造成惊喜!
    _codeSpace = 35;
    
    //初始化数组
    _arrayTextFidld = [NSMutableArray array];
    
    _lastString = @"";
    
    self.backgroundColor = UIColor.blackColor;
    
    //输入框
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor purpleColor];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.delegate = self;
    [self addSubview:_textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:_textField];
    
    //放置View
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = UIColor.whiteColor;
    _contentView.userInteractionEnabled = NO;
    [self addSubview:_contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSubViews];
}

- (void)updateSubViews {
    
    self.textField.frame = self.bounds;
    self.contentView.frame = self.bounds;
    
    /*
     方案1: 直接把原来的都删掉, 重新创建
     for (SMSCodeView *v in [self.arrayTextFidld reverseObjectEnumerator]) {
     [v removeFromSuperview];
     [self.arrayTextFidld removeObject:v];
     }
     */
    
    //方案2:能用就用,少了再建
    if (_arrayTextFidld.count < _codeCount) { //已经存在的子控件比新来的数要小, 那么就创建
        NSUInteger c = _codeCount - _arrayTextFidld.count;
        for (NSInteger i = 0; i < c; i ++) {
            SMSCodeView *v = [[SMSCodeView alloc] init];
            [_arrayTextFidld addObject:v];
        }
    } else if (_arrayTextFidld.count == _codeCount) { //个数相等
        
        return; //如果return,那么就是什么都不做, 如果不return, 那么后续可以更新颜色之类, 或者在转屏的时候重新布局
        
    } else if (_arrayTextFidld.count > _codeCount) { //个数有多余, 那么不用创建新的, 为了尽可能释放内存, 把不用的移除掉,
        NSUInteger c = _arrayTextFidld.count - _codeCount;
        for (NSInteger i = 0; i < c; i ++) {
            [_arrayTextFidld.lastObject removeFromSuperview];
            [_arrayTextFidld removeLastObject];
        }
    }
    
    //可用宽度 / 格子总数
    CGFloat w = (self.bounds.size.width - _codeSpace * (_codeCount - 1)) / (_codeCount * 1.0);
    
    //重新布局小格子
    for (NSInteger i = 0; i < _arrayTextFidld.count; i ++) {
        SMSCodeView *t = _arrayTextFidld[i];
        [self.contentView addSubview:t];
        t.frame = CGRectMake(i * (w + _codeSpace), 0, w, self.bounds.size.height);
    }
}

//已经编辑
- (void)textFieldDidChangeValue:(NSNotification *)notification {
    
    UITextField *sender = (UITextField *)[notification object];
    
    /*
     bug: NSUInteger.
     sender.text.length 返回值是 NSUInteger,无符号整型, 当两个无符号整型做减法, 如果 6 - 9, 那么不会得到 -3, 而是一串很长的整型数, 也就是计算失误
     */
    
    BOOL a = sender.text.length >= self.lastString.length;
    BOOL b = sender.text.length - self.lastString.length >= _codeCount;
    if (a && b) { //判断为一连串验证码输入, 那么,最后N个,就是来自键盘上的短信验证码,取最后N个
        NSLog(@"一连串的输入");
        sender.text = [sender.text substringFromIndex:sender.text.length - _codeCount];
    }
    
    if (sender.text.length >= _codeCount + 1) { //对于持续输入,只要前面N个就行
        NSLog(@"持续输入");
        sender.text = [sender.text substringToIndex:_codeCount - 1];
    }
    
    //字符串转数组
    NSMutableArray <NSString *> *stringArray = [NSMutableArray array];
    NSString *temp = nil;
    for(int i = 0; i < [sender.text length]; i++) {
        temp = [sender.text substringWithRange:NSMakeRange(i,1)];
        [stringArray addObject:temp];
    }
    
    //设置文字
    for(int i = 0; i < self.arrayTextFidld.count; i++) {
        SMSCodeView *SMSCodeView = self.arrayTextFidld[i];
        if (i < stringArray.count) {
            SMSCodeView.text = stringArray[i];
        } else {
            SMSCodeView.text = @"";
        }
    }
    
    //设置光标
    if (stringArray.count == 0) {
        for(int i = 0; i < self.arrayTextFidld.count; i++) {
            BOOL hide = (i == 0 ? YES : NO);
            SMSCodeView *SMSCodeView = self.arrayTextFidld[i];
            SMSCodeView.showCursor = hide;
        }
    } else if (stringArray.count == self.arrayTextFidld.count) {
        for(int i = 0; i < self.arrayTextFidld.count; i++) {
            SMSCodeView *SMSCodeView = self.arrayTextFidld[i];
            SMSCodeView.showCursor = NO;
        }
    } else {
        for(int i = 0; i < self.arrayTextFidld.count; i++) {
            SMSCodeView *SMSCodeView = self.arrayTextFidld[i];
            if (i == stringArray.count - 1) {
                SMSCodeView.showCursor = YES;
            } else {
                SMSCodeView.showCursor = NO;
            }
        }
    }
    
    if (stringArray.count == self.arrayTextFidld.count) {
        [self.textField resignFirstResponder];
    }
    
    self.lastString = sender.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //检查上一次的字符串
    if (self.lastString.length == 0 || self.lastString.length == 1) {
        self.arrayTextFidld.firstObject.showCursor = YES;
    } else if (self.lastString.length == self.arrayTextFidld.count) {
        self.arrayTextFidld.lastObject.showCursor = YES;
    } else {
        self.arrayTextFidld[self.lastString.length - 1].showCursor = YES;
    }
}

- (NSString *)codeText {
    return self.textField.text;
}

- (BOOL)resignFirstResponder {
    for(int i = 0; i < self.arrayTextFidld.count; i++) {
        SMSCodeView *SMSCodeView = self.arrayTextFidld[i];
        SMSCodeView.showCursor = NO;
    }
    [self.textField resignFirstResponder];
    return YES;
}

- (BOOL)becomeFirstResponder {
    [self.textField becomeFirstResponder];
    return YES;
}

///如果要求可以随时更改输入位数, 那么,
- (void)setCodeCount:(NSInteger)codeCount {
    _codeCount = codeCount;
    
    //因为个数改变,清空之前输入的内容
    self.lastString = @"";
    self.textField.text = @"";
    
    for (NSInteger i = 0; i < _arrayTextFidld.count; i ++) {
        SMSCodeView *t = _arrayTextFidld[i];
        t.text = @"";
        if (i == 0) {
            t.showCursor = YES;
        } else {
            t.showCursor = NO;
        }
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


@end
