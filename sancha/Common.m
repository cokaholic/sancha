//
//  Common.m
//  Advent_model
//
//  Created by Keisuke_Tatsumi on 2015/06/16.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "Common.h"

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
    size = CGSizeMake(frame.size.width, frame.size.height+1);
    
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

@end
