//
//  MSCHelper.m
//  BCProject
//
//  Created by 牛新怀 on 2017/10/16.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#define TimeInterval 3000
#import "MSCHelper.h"

@implementation MSCHelper

/**
 解析听写json格式的数据
 params例如：
 {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
 ****/
+ (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

+(int )dateIntervalStr:(NSString *)startDateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:startDateStr];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    // NSLog(@"当前间隔为 ： %@",[NSString stringWithFormat:@"%.0f",aTimer]);
    NSString *intervalDateStr = @"";
    if (aTimer < 60) {
        intervalDateStr = [NSString stringWithFormat:@"%.0f 秒前",aTimer];
    }else if (aTimer >= 60 && aTimer < 3600){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 分钟前",aTimer/60];
    }else if (aTimer >= 3600 && aTimer < 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 小时前",aTimer/3600];
    }else if (aTimer >= 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 天前",aTimer/(3600*24)];
    }
    NSString * intervalTimer = [NSString stringWithFormat:@"%.0f",aTimer];// 获取间隔时间
//    NSString * maxIntervalTime = [NSString stringWithFormat:@"%d",TimeInterval];// 允许的最大间隔
//    if ([intervalTimer integerValue] >= [maxIntervalTime integerValue]) {
//        return YES;
//    }
//    return NO;
    return [intervalTimer intValue];

}

+(NSString*)getCurrentTimeString
{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    return currentDateString;
}

+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;

    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
} 
@end
