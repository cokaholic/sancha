//
//  EventData.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "EventData.h"

@interface EventData()

@property (nonatomic, retain, readwrite) NSDate *date;
@property (nonatomic, assign, readwrite) BOOL timeUndefined;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSString *prefecture;
@property (nonatomic, retain, readwrite) NSString *city;
@property (nonatomic, retain, readwrite) NSString *spot;
@property (nonatomic, retain, readwrite) NSArray *performers;
@property (nonatomic, retain, readwrite) NSURL *detailURL;

@end

@implementation EventData

- (id)initWithHTMLNode:(HTMLNode *)node {
    self = [super init];
    if (self) {
        NSArray *tds = [node findChildTags:@"td"];
        // date
        [self parseDate:tds[0]];
        // title
        [self parseTitle:tds[1]];
        // location
        [self parseLocation:tds[2]];
        // performer
        [self parsePerformers:tds[3]];
    }
    return self;
}

- (void)parseDate:(HTMLNode *)node {
    NSString *contents = node.allContents;
    NSString *yearStr = [contents substringToIndex:4];
    NSString *dateStr = [contents substringWithRange:NSMakeRange(4, 5)];
    NSString *timeStr = [contents substringFromIndex:9];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //Force GregorianCalendar To Fix DatePicker Bug
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.locale = [NSLocale currentLocale];
    dateFormatter.calendar = gregorian;
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"JST"];
    
    if ([timeStr isEqualToString:@"-:-"]) {
        [dateFormatter setDateFormat:@"yyyy MM/dd -:-"];
        self.timeUndefined = YES;
    } else {
        [dateFormatter setDateFormat:@"yyyy MM/dd HH:mm"];
    }
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", yearStr, dateStr, timeStr];
    self.date = [dateFormatter dateFromString:str];
}

- (void)parseTitle:(HTMLNode *)node {
    HTMLNode *aNode = [node findChildTag:@"a"];
    self.title = aNode.contents;
    self.detailURL = [NSURL URLWithString:[aNode getAttributeNamed:@"href"]];
}

- (void)parseLocation:(HTMLNode *)node {
    NSString *location = node.contents;
    NSArray *array = [location componentsSeparatedByString:@"／"];
    self.prefecture = array[0];
    if (array.count <= 1) {
        self.city = @"";
    } else {
        self.city = array[1];
    }
    self.spot = [node findChildTag:@"span"].contents;
}

- (void)parsePerformers:(HTMLNode *)node {
    NSString *str = node.contents;
    int pre = -1;
    unichar open = [@"(" characterAtIndex:0];
    unichar close = [@")" characterAtIndex:0];
    unichar delim = [@"、" characterAtIndex:0];
    int stack = 0;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < str.length; ++i) {
        unichar c = [str characterAtIndex:i];
        if (c == open) {
            stack++;
        } else if (c == close) {
            stack--;
        } else if (c == delim && stack == 0) {
            NSString *performer = [str substringWithRange:NSMakeRange(pre+1, i-pre-1)];
            NSString *trimmed = [performer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [array addObject:trimmed];
            pre = i;
        }
    }
    NSString *performer = [str substringWithRange:NSMakeRange(pre+1, str.length - pre - 1)];
    NSString *trimmed = [performer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [array addObject:trimmed];
    self.performers = [NSArray arrayWithArray:array];
}

@end
