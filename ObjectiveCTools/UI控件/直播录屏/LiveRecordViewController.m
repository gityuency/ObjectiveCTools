//
//  LiveRecordViewController.m
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/27.
//  Copyright © 2019 ChinaRapidFinance. All rights reserved.
//

#import "LiveRecordViewController.h"

#import "YXRecorderManager.h"

@interface LiveRecordViewController ()


/// 显示计时
@property (weak, nonatomic) IBOutlet UILabel *labelConter;


@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation LiveRecordViewController


- (void)dealloc {
    [YXRecorderManager destoryManager];
    NSLog(@"⭕️ 成功释放 %s", __func__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //预先初始化,防止卡顿
    [YXRecorderManager sharedManager];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.count = 0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actionCount) userInfo:nil repeats:YES];
    //加上这一句会导致触屏概率性失灵,屏幕按钮点击无反应. 有bug
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


- (void)actionCount {
    _count += 1;
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *s = [dateFormatter stringFromDate:date];
    self.labelConter.text = [NSString stringWithFormat:@"%@ \n计数: %ld", s, (long)_count];
}

- (IBAction)start:(id)sender {
    [[YXRecorderManager sharedManager] startRecord];
}

- (IBAction)pause:(id)sender {
    [[YXRecorderManager sharedManager] pauseRecord];
}

- (IBAction)resume:(id)sender {
    [[YXRecorderManager sharedManager] resumeRecord];
}

- (IBAction)stop:(id)sender {
    [[YXRecorderManager sharedManager] stopRecord];
}

@end

