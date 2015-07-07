//
//  Common.h
//  Advent_model
//
//  Created by Keisuke_Tatsumi on 2015/06/16.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADBannerView.h>

#define MY_BANNER_UNIT_ID @"ca-app-pub-1043692751731091/4144751164"
#define MY_BANNER_UNIT_ID2 @"ca-app-pub-1043692751731091/5342282762";

#define NAVBAR_HEIGHT 64
#define STATUSBAR_HEIGHT 20
#define DEFAULT_CELL_HEIGHT 50
#define DEFAULT_HEADER_HEIGHT 30
#define EVENT_CELL_HEIGHT 90
#define SEARCH_BAR_HEIGHT 44
#define DEFAULT_FONT(fontSize) [UIFont fontWithName:@"HiraKakuProN-W3" size:fontSize]
#define DEFAULT_BOLD_FONT(fontSize) [UIFont fontWithName:@"HiraKakuProN-W6" size:fontSize]
#define REFRESH_TEXT_FONT(fontSize) [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize]
#define DEFAULT_TEXT_COLOR [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0]
#define PALE_TEXT_COLOR [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0]
#define MAIN_COLOR [UIColor colorWithRed:119.0f/255.0f green:205.0f/255.0f blue:225.0f/255.0f alpha:1.0]
#define CANCEL_COLOR [UIColor colorWithRed:250.0f/255.0f green:49.0f/255.0f blue:76.0f/255.0f alpha:1.0]
#define UPDATE_COLOR [UIColor colorWithRed:211.0f/255.0f green:190.0f/255.0f blue:72.0f/255.0f alpha:1.0]
#define DETAIL_TITLE_COLOR [UIColor colorWithRed:253.0f/255.0f green:127.0f/255.0f blue:52.0f/255.0f alpha:1.0]
#define ACCENT_COLOR [UIColor whiteColor]
#define CLEAR_COLOR [UIColor clearColor]
#define BACKGROUND_COLOR [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.7]
#define LINE_VIEW_COLOR [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0]
#define SATURDAY_COLOR [UIColor colorWithRed:58.0f/255.0f green:109.0f/255.0f blue:238.0f/255.0f alpha:1.0]
#define SUNDAY_COLOR [UIColor colorWithRed:250.0f/255.0f green:49.0f/255.0f blue:76.0f/255.0f alpha:1.0]

@interface Common : NSObject

+ (CGSize)screenSize;
+ (int)iosVersion;
+ (CGSize)sizeOfString:(NSString *)string inFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
+ (NSDate *)dateFromString:(NSString *)strDate;
+ (int)weekNumberWithDate:(NSDate *)date;
+ (NSString *)formatDateString:(NSString *)string;
+ (NSString *)checkNullValue:(id)object;
+ (NSMutableAttributedString *)attributedTextWithString:(NSString *)string lineHeight:(CGFloat)height;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (NSArray *)getMonthDay: (NSString *)string;
+ (NSDictionary *)dateConvertToDateDictionary:(NSDate *)date;
+ (NSString *)checkMinute:(NSNumber *)minute;

@end
