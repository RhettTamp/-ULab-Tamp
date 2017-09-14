//
//  ViewController.m
//  AVTest
//
//  Created by 周维康 on 2017/6/27.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface ViewController ()
@property (nonatomic, strong) AVAudioPlayer *player;  /**< <#comment#> */
@end
// AVAudioSessionCategoryAmbient 打开其他音乐,再打开此应用不会中断，混合播放
// AVAudioSessionCategoryPlayback 两个播放软件不能同时播放,播放其中一个会中断另外一个 静音键无效
// AVAudioSessionCategorySoloAmbient 各种操作都会中断音频播放
// AVAudioSessionCategoryPlayAndRecord 听筒成为默认输出设备（上面的都是扬声器， AVAudioSessionCategoryOptionDefaultToSpeaker option设置之后变成扬声器）
//
//
//
//
//
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    NSLog(@"%@", [error localizedDescription]);
    // Do any additional setup after loading the view, typically from a nib.
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    NSLog(@"%@", [error localizedDescription]);
    [session setActive:YES error:nil]; //启动音频会话管理，此时会阻断后台音乐的播放;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blank" withExtension:@"mp3"] error:&error];
    [self.player play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
