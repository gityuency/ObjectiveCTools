//
//  RecordingViewController.m
//  ObjectiveCTools
//
//  Created by HPCL20190110 on 2019/3/13.
//  Copyright © 2019 ChinaRapidFinance. All rights reserved.
//

#import "RecordingViewController.h"
#import "YXReplayManager.h"

@interface RecordingViewController ()

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)start:(UIButton *)sender {

    sender.backgroundColor = [UIColor redColor];
    [[YXReplayManager sharedManager] startRecording];

}

- (IBAction)stop:(UIButton *)sender {

    sender.backgroundColor = [UIColor greenColor];
    [[YXReplayManager sharedManager] stopRecording];
}


@end
