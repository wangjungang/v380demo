

/**
 
 日期转字符串
 
 */

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

// 日期字符串
- (NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return [formatter stringFromDate:self];
}

// 时间字符串
- (NSString *)timeString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"HH:mm:ss";
    
    return [formatter stringFromDate:self];
}

// 日期和时间字符串
- (NSString *)dateAndTimeString {
    
    return [NSString stringWithFormat:@"%@ %@", [self dateString], [self timeString]];
}

// 设置为当前日期的零时零分零秒
- (NSDate *)beginOfTheDay {

    if (self == nil) {

        return nil;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:self];
    NSString *string = [dateString stringByAppendingString:@" 00:00:00"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    return [formatter dateFromString:string];
}

// 设置为当前日期的最后一秒
- (NSDate *)endOfTheDay {

    if (self == nil) {

        return nil;
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:self];
    NSString *string = [dateString stringByAppendingString:@" 23:59:59"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    return [formatter dateFromString:string];
}

// 设置为当前日期的最后一分 0秒
- (NSDate *)endOfTheDayZeroSecond{
    
    if (self == nil) {
        
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:self];
    NSString *string = [dateString stringByAppendingString:@" 23:59:00"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [formatter dateFromString:string];
}

// 从字符串创建指定时区的时间
+ (instancetype)dateFromTimeString:(NSString *)string timeZone:(NSTimeZone *)zone {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.timeZone = zone;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [formatter dateFromString:string];
}

// 从字符串创建本地时区的时间
+ (instancetype)dateFromLocalTimeString:(NSString *)string {
    
    return [self dateFromTimeString:string timeZone:[NSTimeZone localTimeZone]];
}

// 从字符串创建北京时间
+ (instancetype)dateFromBeijingTimeString:(NSString *)string {
    
    return [self dateFromTimeString:string timeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
}

@end
