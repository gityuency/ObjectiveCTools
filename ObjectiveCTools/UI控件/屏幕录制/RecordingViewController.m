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


- (IBAction)start:(id)sender {

    [[YXReplayManager sharedManager] startRecording];

}

- (IBAction)stop:(id)sender {

    [[YXReplayManager sharedManager] stopRecording];
}


@end
