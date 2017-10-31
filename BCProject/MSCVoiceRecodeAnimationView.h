//
//  MSCVoiceRecodeAnimationView.h
//  BCProject
//
//  Created by 牛新怀 on 2017/10/16.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCVoiceRecodeAnimationView : UIView

@property (nonatomic, assign) CGSize originSize;
- (void)updateWithPower:(int)power;
@end
