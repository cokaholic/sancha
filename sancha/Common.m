//
//  Common.m
//  Advent_model
//
//  Created by Keisuke_Tatsumi on 2015/06/16.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "Common.h"

enum {
    SUNDAY = 0,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
};

@implementation Common

+ (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}

+ (int)iosVersion
{
    return [[[UIDevice currentDevice] systemVersion] intValue];
}

+ (CGSize)sizeOfString:(NSString *)string inFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CGSize size;
    CGRect frame;
    NSDictionary *attributeDic;
    attributeDic = @{NSFontAttributeName:font};
    frame = [string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                              attributes:attributeDic
                                 context:nil];
    size = CGSizeMake(frame.size.width, frame.size.height);
    
    return size;
}

+ (NSDate *)dateFromString:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    //Force GregorianCalendar To Fix DatePicker Bug
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.locale = [NSLocale currentLocale];
    dateFormatter.calendar = gregorian;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"EN"]];
    
    NSDate *returnDate = [dateFormatter dateFromString:strDate];
    return returnDate;
}

+ (int)weekNumberWithDate:(NSDate *)date
{    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [calendar components:NSWeekdayCalendarUnit
                                          fromDate:date];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja"];
    
    return (int)comps.weekday - 1;
}

+ (NSString *)formatDateString:(NSString *)string
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    //Force GregorianCalendar To Fix DatePicker Bug
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.locale = [NSLocale currentLocale];
    dateFormater.calendar = gregorian;
    
    dateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP@calendar=gregorian"];
    [dateFormater setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *dateString = [dateFormater stringFromDate:[self dateFromString:string]];
    
    return dateString;
}

+ (NSArray *)getMonthDay: (NSString *)string
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    //Force GregorianCalendar To Fix DatePicker Bug
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.locale = [NSLocale currentLocale];
    dateFormater.calendar = gregorian;
    
    dateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP@calendar=gregorian"];
    [dateFormater setDateFormat:@"M/d"];
    NSString *dateString = [dateFormater stringFromDate:[self dateFromString:string]];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"/"];
    return dateArray;
}

+ (NSDictionary *)dateConvertToDateDictionary:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMinute | NSCalendarUnitHour |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSMutableDictionary *dateDictionary = [[NSMutableDictionary alloc]init];
    [dateDictionary setObject:[NSNumber numberWithInteger:[components minute]] forKey:@"minute"];
    [dateDictionary setObject:[NSNumber numberWithInteger:[components hour]] forKey:@"hour"];
    [dateDictionary setObject:[NSNumber numberWithInteger:[components day]] forKey:@"day"];
    [dateDictionary setObject:[NSNumber numberWithInteger:[components month]] forKey:@"month"];
    [dateDictionary setObject:[NSNumber numberWithInteger:[components year]] forKey:@"year"];
    
    return [dateDictionary mutableCopy];
}

+ (NSString *)checkNullValue:(id)object
{
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return (NSString *)object;
}

+ (NSMutableAttributedString *)attributedTextWithString:(NSString *)string lineHeight:(CGFloat)height
{
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:height];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, attributedText.length)];
    return attributedText;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title
                               message:message
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil] show];
}

+ (NSString *)checkMinute:(NSNumber *)minute
{
    if ([minute intValue]==0) {
        return @"00";
    }
    else if ([minute stringValue].length == 1) {
        return [NSString stringWithFormat:@"0%@",minute];
    }
    else{
        return [minute stringValue];
    }
}

@end
