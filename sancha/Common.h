//
//  Common.h
//  Advent_model
//
//  Created by Keisuke_Tatsumi on 2015/06/16.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NAVBAR_HEIGHT 64
#define STATUSBAR_HEIGHT 20
#define EVENT_CELL_HEIGHT 90
#define SEARCH_BAR_HEIGHT 44
#define DEFAULT_FONT(fontSize) [UIFont fontWithName:@"HiraKakuProN-W3" size:fontSize]
#define DEFAULT_BOLD_FONT(fontSize) [UIFont fontWithName:@"HiraKakuProN-W6" size:fontSize]
#define REFRESH_TEXT_FONT(fontSize) [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize]
#define DEFAULT_TEXT_COLOR [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0]
#define MAIN_COLOR [UIColor colorWithRed:72.0f/255.0f green:211.0f/255.0f blue:178.0f/255.0f alpha:1.0]
#define CANCEL_COLOR [UIColor colorWithRed:247.0/255.0 green:93/255.0 blue:72/255.0 alpha:1]
#define UPDATE_COLOR [UIColor colorWithRed:211.0f/255.0f green:190.0f/255.0f blue:72.0f/255.0f alpha:1.0]
#define ACCENT_COLOR [UIColor whiteColor]
#define CLEAR_COLOR [UIColor clearColor]
#define BACKGROUND_COLOR [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.7]
#define LINE_VIEW_COLOR [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0]

@interface Common : NSObject

+ (CGSize)screenSize;
+ (int)iosVersion;
+ (CGSize)sizeOfString:(NSString *)string inFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
+ (NSDate *)dateFromString:(NSString *)strDate;
+ (NSString *)formatDateString:(NSString *)string;
+ (NSString *)checkNullValue:(id)object;
+ (NSMutableAttributedString *)attributedTextWithString:(NSString *)string lineHeight:(CGFloat)height;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (NSArray *)getMonthDay: (NSString *)string;
+ (NSDictionary *)dateConvertToDateDictionary:(NSDate *)date;
+ (NSString *)checkMinute:(NSNumber *)minute;

@end
