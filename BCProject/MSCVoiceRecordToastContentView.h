//
//  MSCVoiceRecordToastContentView.h
//  BCProject
//
//  Created by 牛新怀 on 2017/10/16.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCVoiceRecordToastContentView : UIView

- (void)updateWithPower:(int)power;
@property (nonatomic, strong) UILabel * timeLabel;
@end
