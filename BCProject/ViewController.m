//
//  ViewController.m
//  BCProject
//
//  Created by 牛新怀 on 2017/10/16.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#import <iflyMSC/iflyMSC.h>
#import "ViewController.h"
#import "MSCHelper.h"
#import "MSCVoiceRecordToastContentView.h"
@interface ViewController ()<IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, strong) MSCVoiceRecordToastContentView * speechView;
@property (nonatomic, strong) UITextView * textViewed;
@property (nonatomic, strong) UIButton * speechButton;
@property (nonatomic, strong) UIButton * audioStreamButton;
@property (nonatomic, strong) UILabel * speechLabel;
@property (nonatomic, strong) NSTimer * myTimer;
@property (nonatomic, strong) NSString * currentTimeStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpUI];
    
}
- (void)setUpUI{
    self.navigationController.navigationBar.backgroundColor = [UIColor cyanColor];
    self.title = @"辈出语音识别";
    self.view.backgroundColor = [UIColor whiteColor];
    [self MSCSpeech];
}

- (UIButton *)speechButton{
    if (!_speechButton) {
        _speechButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _speechButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-45);
        _speechButton.bounds = CGRectMake(0, 0, 200, 40);
        _speechButton.backgroundColor = [UIColor blackColor];
        [_speechButton setTitle:@"开始录音" forState:UIControlStateNormal];
        [_speechButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_speechButton addTarget:self action:@selector(didSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _speechButton.selected = NO;
    }
    return _speechButton;
}

- (UIButton *)audioStreamButton{
    if (!_audioStreamButton) {
        _audioStreamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioStreamButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2+100);
        _audioStreamButton.bounds = CGRectMake(0, 0, 150, 30);
        [_audioStreamButton setTitle:@"音频流识别" forState:UIControlStateNormal];
        [_audioStreamButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_audioStreamButton addTarget:self action:@selector(didSelectAudioStreamButtonClick) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _audioStreamButton;
}
// 音频识别
- (void)didSelectAudioStreamButtonClick{
//    [_iFlySpeechRecognizer stopListening];
}

- (void)didSelectButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSString * buttonText;
    UIColor * colors;
    if (sender.selected) {
        buttonText = @"正在录音";
        colors = [UIColor redColor];
        self.speechView.hidden = NO;
        [self beginTimer];
    }else{
        buttonText = @"开始录音";
        colors = [UIColor whiteColor];
        self.speechLabel.text =@"";
        self.speechView.hidden = YES;
        self.speechView.timeLabel.text = @"00:00";
        _currentTimeStr = nil;
        [self invalidateTimer];
//        resultString = nil;
    }
    [sender setTitle:buttonText forState:UIControlStateNormal];
    [sender setTitleColor:colors forState:UIControlStateNormal];
    sender.selected ? [_iFlySpeechRecognizer startListening] : [_iFlySpeechRecognizer cancel];
}
- (void)MSCSpeech{
    //创建语音识别对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    //设置识别参数
    //设置为听写模式
    [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
    [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //去掉逗号
    [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];

    [_iFlySpeechRecognizer setDelegate: self];
    [self.view addSubview:self.speechButton];
    [self.view addSubview:self.speechLabel];
    //[self.view addSubview:self.audioStreamButton];
    //启动识别服务
   // [_iFlySpeechRecognizer startListening];
    if (_speechView == nil) {
        _speechView = [MSCVoiceRecordToastContentView new];
        _speechView.center = CGPointMake(self.view.frame.size.width/2, self.speechButton.frame.origin.y-100);
        _speechView.bounds = CGRectMake(0, 0, 120, 120);
        _speechView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _speechView.layer.cornerRadius = 6;
        _speechView.hidden = YES;
        [self.view addSubview:_speechView];
    }
    
    
}

//IFlySpeechRecognizerDelegate协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [MSCHelper stringFromJson:resultString];
    
    self.speechLabel.text = [NSString stringWithFormat:@"%@%@", self.speechLabel.text,resultFromJson];
   // NSLog(@"当前获取的数据 :  %@",resultFromJson);
    if ([_iFlySpeechRecognizer isListening]) {
        NSLog(@"正在识别");
    }
 
    
}
//识别会话结束返回代理
- (void)onError: (IFlySpeechError *) error{
    NSLog(@"错误原因 : %@",error.errorDesc);
    if (self.speechButton.selected) {
        [_iFlySpeechRecognizer startListening];
    }else{
        [_iFlySpeechRecognizer cancel];
    }
}
//停止录音回调
- (void) onEndOfSpeech{
    NSLog(@"结束录音");
}
//开始录音回调
- (void) onBeginOfSpeech{
    NSLog(@"开始录音");
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
    [self.speechView updateWithPower:volume];
}
//会话取消回调
- (void) onCancel{
    NSLog(@"取消了当前会话");
}

- (UILabel *)speechLabel{
    if (!_speechLabel) {
        _speechLabel = [[UILabel alloc]init];
//        _speechLabel.center = CGPointMake(self.view.frame.size.width/2, 100);
//        _speechLabel.bounds = CGRectMake(0, 0, self.view.frame.size.width-80, 100);
        _speechLabel.frame = CGRectMake(40, 40, self.view.frame.size.width-80, 150);
        _speechLabel.text = @"";
        _speechLabel.textColor = [UIColor blackColor];
        _speechLabel.font = [UIFont systemFontOfSize:15];
        _speechLabel.numberOfLines = 6;
        _speechLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _speechLabel;
}

- (void)beginTimer{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _myTimer = timer;
}

- (void)invalidateTimer{
    [_myTimer invalidate];
    _myTimer = nil;
}
- (void)actionTimer{
    if (_currentTimeStr) {
        NSString * timerStr = [MSCHelper timeFormatted:[MSCHelper dateIntervalStr:_currentTimeStr]];
      //  NSLog(@"当前获取的时间为 : %@",timerStr);
        self.speechView.timeLabel.text = timerStr;
    }else{
        _currentTimeStr =[MSCHelper getCurrentTimeString];// 首次进入获取当前时间戳
        
    }
}
@end
