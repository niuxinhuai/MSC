//
//  MSCVoiceRecordToastContentView.m
//  BCProject
//
//  Created by 牛新怀 on 2017/10/16.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "MSCVoiceRecordToastContentView.h"
#import "MSCVoiceRecodeAnimationView.h"
#import "Masonry.h"
#import "MSCHelper.h"
@interface MSCVoiceRecordToastContentView()
@property (nonatomic, strong) UIImageView *imgRecord;
@property (nonatomic, strong) MSCVoiceRecodeAnimationView * powerView;

@end
@implementation MSCVoiceRecordToastContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    if (_imgRecord == nil) {
        _imgRecord = [UIImageView new];
        _imgRecord.backgroundColor = [UIColor clearColor];
        _imgRecord.image = [UIImage imageNamed:@"ic_record"];
        [self addSubview:_imgRecord];
    }
    if (_powerView == nil) {
        _powerView = [MSCVoiceRecodeAnimationView new];
        _powerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_powerView];
    }
    if (_timeLabel == nil) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
    }
    
    [_imgRecord mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.leading.equalTo(self).offset(40);
        make.size.mas_equalTo(CGSizeMake(_imgRecord.image.size.width, _imgRecord.image.size.height));
    }];
    
    CGSize powerSize = CGSizeMake(18, 56);
    [_powerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imgRecord);
        make.leading.equalTo(_imgRecord.mas_trailing).offset(4);
        make.size.mas_equalTo(powerSize);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgRecord.mas_bottom).offset(5);
        make.left.right.equalTo(self).offset(0);
        make.height.equalTo(@20);
        
        
    }];

    
    //默认显示一格音量
    _powerView.originSize = powerSize;
    [_powerView updateWithPower:0];
    
}

- (void)updateWithPower:(int)power{
    [_powerView updateWithPower:power];

}



@end
