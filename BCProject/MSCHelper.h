//
//  MSCHelper.h
//  BCProject
//
//  Created by 牛新怀 on 2017/10/16.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCHelper : NSObject

/**
 解析JSON数据
 ****/
+ (NSString *)stringFromJson:(NSString*)params;//

/*
 @parameter 几秒前，几分钟前，几小时前，几天前    时间间隔
 
 */

+(int)dateIntervalStr:(NSString *)startDateStr;

/*
 @parameter 获取当前时间
 
 */
+(NSString*)getCurrentTimeString;


/**
 通过秒数获取分钟时间戳

 @param totalSeconds 秒数
 @return 返回指定的分钟数
 */
+ (NSString *)timeFormatted:(int)totalSeconds;
@end
