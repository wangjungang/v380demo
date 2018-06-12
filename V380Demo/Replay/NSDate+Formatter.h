

/**
 
 日期转字符串
 
 */

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)

/** 日期字符串 格式: 1970-01-01 */
- (NSString *)dateString;

/** 时间字符串 格式: 08:08:08 */
- (NSString *)timeString;

/** 日期和时间字符串 格式: 1970-01-01 08:08:08 */
- (NSString *)dateAndTimeString;

/** 设置为当前日期的零时零分零秒 */
- (NSDate *)beginOfTheDay;

/** 设置为当前日期的最后一秒 */
- (NSDate *)endOfTheDay;

/** 设置为当前日期的最后一分 0秒*/
- (NSDate *)endOfTheDayZeroSecond;

/** 从字符串创建指定时区的时间 格式: 1970-01-01 08:08:08 */
+ (instancetype)dateFromTimeString:(NSString *)string timeZone:(NSTimeZone *)zone;

/** 从字符串创建本地时区的时间 格式: 1970-01-01 08:08:08 */
+ (instancetype)dateFromLocalTimeString:(NSString *)string;

/** 从字符串创建北京时间 格式: 1970-01-01 08:08:08 */
+ (instancetype)dateFromBeijingTimeString:(NSString *)string;

@end
