//
//  NSDate+CalendarHandler.m
//  CalenarDemo
//
//  Created by 刘向晶 on 16/2/25.
//  Copyright © 2016年 测试. All rights reserved.
//

#import "NSDate+CalendarHandler.h"

@implementation NSDate (CalendarHandler)

/*计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth {
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}


//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1;
        days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}



/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}



//计算这个月最开始的一天
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
     [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
//    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}


- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

//上一个月
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//下一个月
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(NSInteger)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(NSInteger)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取年月日对象
- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekday fromDate:self];
}
- (NSDate *)dayInTheAcrossYears:(NSInteger)yearsAgo {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = yearsAgo;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//-----------------------------------------
//
//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}
+ (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: destDate];
    
    NSDate *localeDate = [destDate  dateByAddingTimeInterval: interval];
    
    return localeDate;
}
- (NSDate *)UTCDateToLocalDate {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: self];
    
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone =[NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}
- (NSString *)stringValue {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}
//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
//NSDate转NSString
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
- (NSString *)stringFromDate:(NSDate *)date WithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:format];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
- (NSString *)timeStringValue {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:self];
    
    return destDateString;
}

+ (NSString *)currentYearMonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSDate *date = [NSDate date];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    return currentTime;
}

+(NSString *)getDayFromDateString:(NSString *)dateString {
    return [[self dateFromString:dateString format:@"yyyy-MM-dd HH:mm:ss"] stringValue];
}
+ (NSString *)getTimeFromDateString:(NSString *)dateString {
    return [[self dateFromString:dateString format:@"yyyy-MM-dd HH:mm:ss"] timeStringValue];
}
+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//日历控件对象
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
    return day;
}


//周日是“1”，周一是“2”...
-(NSInteger)getWeekIntValueWithDate
{
    NSInteger weekIntValue;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps= [calendar components:(NSCalendarUnitYear |
                                                   NSCalendarUnitMonth |
                                                   NSCalendarUnitDay |
                                                   NSCalendarUnitWeekday) fromDate:self];
    return weekIntValue = [comps weekday];
}


//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate
{
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps_today= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:todate];
    
    
    NSDateComponents *comps_other= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:self];
    
    
    //获取星期对应的数字
    NSInteger weekIntValue = [self getWeekIntValueWithDate];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"今天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -1){
        return @"明天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -2){
        return @"后天";
        
    }else{
        //直接返回当时日期的字符串(这里让它返回空)
        return [NSDate getWeekStringFromInteger:weekIntValue];//周几
    }
}



//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(NSInteger)week
{
    NSString *str_week;
    
    switch (week) {
        case 1:
            str_week = @"周日";
            break;
        case 2:
            str_week = @"周一";
            break;
        case 3:
            str_week = @"周二";
            break;
        case 4:
            str_week = @"周三";
            break;
        case 5:
            str_week = @"周四";
            break;
        case 6:
            str_week = @"周五";
            break;
        case 7:
            str_week = @"周六";
            break;
    }
    return str_week;
}

- (NSInteger)year {
    return [self dataWithType:0];
}
- (NSInteger)month {
    return [self dataWithType:1];
}
- (NSInteger)day {
    return [self dataWithType:2];
}
- (NSInteger)hour {
    return [self dataWithType:3];
}
- (NSInteger)minute {
    return [self dataWithType:4];
}
- (NSInteger)dataWithType:(NSInteger)type {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    
    switch (type) {
        case 0:
        {
            return components.year;
            break;
        }
        case 1:
        {
            return components.month;
            break;
        }
        case 2:
        {
            return components.day;
            break;
        }
        case 3:
        {
            return components.hour;
            break;
        }
        case 4:
        {
            return components.minute;
            break;
        }
        default:
            return 0;
            break;
    }
    
}

@end
