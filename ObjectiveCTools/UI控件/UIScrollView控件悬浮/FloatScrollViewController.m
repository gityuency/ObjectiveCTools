//
//  FloatScrollViewController.m
//  ObjectiveCTools
//
//  Created by aidong on 2020/9/28.
//  Copyright © 2020 姬友大人. All rights reserved.
//

#import "FloatScrollViewController.h"
#import "Masonry.h"

@interface FloatScrollViewController ()
///假的导航栏
@property (nonatomic, strong) UILabel *fakeNaviBar;
///滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation FloatScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //把系统的导航栏隐藏
    self.navigationController.navigationBar.hidden = YES;
    
    //用自己的做的导航栏冒充,方便调试
    self.fakeNaviBar = [[UILabel alloc] init];
    self.fakeNaviBar.textColor = [UIColor whiteColor];
    self.fakeNaviBar.backgroundColor = [UIColor redColor];
    self.fakeNaviBar.text = @"这个是假的导航栏";
    self.fakeNaviBar.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.fakeNaviBar];
    [self.fakeNaviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(120);
        make.height.equalTo(@40);
    }];
    
    //滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        //
    }
    //self.scrollView.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.fakeNaviBar.mas_bottom);  //滚动视图的顶部贴着假的导航栏的底部
        make.bottom.equalTo(self.view).offset(-40);
    }];
    //这个作为基准线
    UIView *viewContent_A = [[UIView alloc] init];
    viewContent_A.backgroundColor = [UIColor magentaColor];
    [self.scrollView addSubview:viewContent_A];
    [viewContent_A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@(400));
    }];
    //悬浮视图A
    CGFloat Float_A_Height = 40;
    UILabel *labelFloat_A = [[UILabel alloc] init];
    labelFloat_A.backgroundColor = UIColor.greenColor;
    labelFloat_A.text = @"我是悬浮视图 A";
    [self.scrollView addSubview:labelFloat_A];
    [labelFloat_A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(viewContent_A.mas_bottom);    //距离上一个视图的底部 可以拉到很大很大
        make.top.greaterThanOrEqualTo(self.fakeNaviBar.mas_bottom); //距离假导航栏的底部 可以拉到很大很大
        make.left.right.equalTo(self.scrollView);
        make.height.equalTo(@(Float_A_Height));
    }];
    
    
    //内容B
    UIView *viewContent_B = [[UIView alloc] init];
    viewContent_B.backgroundColor = UIColor.orangeColor;
    [self.scrollView addSubview:viewContent_B];
    [viewContent_B mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewContent_A.mas_bottom).offset(Float_A_Height); //这里的偏移量,就是上一个悬浮视图的高度
        make.left.right.equalTo(self.scrollView);
        make.height.equalTo(@(450));
    }];
    //悬浮视图B
    UILabel *labelFloat_B = [[UILabel alloc] init];
    labelFloat_B.backgroundColor = [UIColor greenColor];
    labelFloat_B.text = @"我是悬浮视图 B";
    [self.scrollView addSubview:labelFloat_B];
    [labelFloat_B mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(viewContent_B.mas_bottom).offset(0);  //距离上一个视图的底部 可以拉到很大很大
        make.top.greaterThanOrEqualTo(self.fakeNaviBar.mas_bottom);         //距离假导航栏的底部 可以拉到很大很大
        make.left.right.equalTo(self.scrollView);
        make.height.equalTo(@40);
    }];
    
    //内容C
    UIView *viewContent_C = [[UIView alloc] init];
    viewContent_C.backgroundColor = UIColor.brownColor;
    [self.scrollView addSubview:viewContent_C];
    [viewContent_C mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewContent_B.mas_bottom).offset(40); //这里的偏移量,就是上一个悬浮视图的高度
        make.left.right.equalTo(self.scrollView);
        make.height.equalTo(@(450));
    }];
    //悬浮视图C
    UILabel *labelFloat_C = [[UILabel alloc] init];
    labelFloat_C.backgroundColor = [UIColor greenColor];
    labelFloat_C.text = @"我是悬浮视图 C";
    [self.scrollView addSubview:labelFloat_C];
    [labelFloat_C mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(viewContent_C.mas_bottom).offset(0);  //距离上一个视图的底部 可以拉到很大很大
        make.top.greaterThanOrEqualTo(self.fakeNaviBar.mas_bottom);         //距离假导航栏的底部 可以拉到很大很大
        make.left.right.equalTo(self.scrollView);
        make.height.equalTo(@40);
    }];
    
    //最后一个填充视图
    UIView *viewBottom = [[UIView alloc] init];
    viewBottom.backgroundColor = UIColor.cyanColor;
    [self.scrollView addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewContent_C.mas_bottom).offset(0);
        make.left.right.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
        make.height.equalTo(@800);
    }];
    
    //在最后,需要把漂浮的视图,都弄出来
    [self.scrollView bringSubviewToFront:labelFloat_A];
    [self.scrollView bringSubviewToFront:labelFloat_B];
    [self.scrollView bringSubviewToFront:labelFloat_C];
}

@end
