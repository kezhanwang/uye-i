//
//  NSDate+CalendarHandler.h
//  CalenarDemo
//
//  Created by 刘向晶 on 16/2/25.
//  Copyright © 2016年 测试. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarHandler)
- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(NSInteger)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(NSInteger)day;//获取当前日期之后的几个天

- (NSDateComponents *)YMDComponents;
/*获取几年前（-n）或者几年后(n)的今天
 */
- (NSDate *)dayInTheAcrossYears:(NSInteger)yearsAgo;
- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)dateString;
- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date;
- (NSDate *)UTCDateToLocalDate;
- (NSString *)stringValue;
+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

+ (NSString *)getDayFromDateString:(NSString *)dateString;
+ (NSString *)getTimeFromDateString:(NSString *)dateString;
-(NSInteger)getWeekIntValueWithDate;

+ (NSString *)currentYearMonth;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;

//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(NSInteger)week;
@end
