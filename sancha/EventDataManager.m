//
//  EventDataManager.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "EventDataManager.h"
#import "EventData.h"
#import "HTMLParser.h"

@interface EventDataManager ()
@property(nonatomic, retain, readwrite) NSArray* dataList;
@property(nonatomic, retain, readwrite) NSArray* performers;
@end

@implementation EventDataManager

static EventDataManager *shared;

+ (EventDataManager *)sharedManager {
    if (!shared) {
        shared = [[EventDataManager alloc] init];
    }
    return shared;
}

- (id) init {
    self = [super init];
    if (self) {
        self.dataList = [NSArray array];
        self.performers = [NSArray array];
        [self loadData];
    }
    return self;
}

- (void) loadData {
    NSString *url = @"http://www.koepota.jp/eventschedule/";
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *error = nil;
    NSString *html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        // error!!!!
        NSLog(@"Error: %@", error);
        return;
    }
    [self parseHTML:html];
    
    // set performeœrs
    NSMutableSet *set = [NSMutableSet set];
    for (EventData *event in self.dataList) {
        for (NSString *performer in event.performers) {
            [set addObject:performer];
        }
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    NSArray *sortedPerformers = [set.allObjects sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    self.performers = [NSArray arrayWithArray:sortedPerformers];
}

- (void) parseHTML:(NSString*)html {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *scheduleTableNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"eventschedule" allowPartial:NO];

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *rowNodes = [scheduleTableNode findChildTags:@"tr"];
    BOOL firstRow = YES;
    
    for (HTMLNode *rowNode in rowNodes) {
        if (firstRow) {
            firstRow = NO;
            continue;
        }
        [array addObject:[[EventData alloc] initWithHTMLNode:rowNode]];
    }
    self.dataList = [NSArray arrayWithArray:array];
}

- (NSArray *)getFilteredDataList {
    NSMutableArray *array = [NSMutableArray array];
    FilteringManager *filteringManager = [FilteringManager sharedManager];
    
    for (EventData *event in self.dataList) {
        if ([filteringManager isFilteredEvent:event]) {
            [array addObject:event];
        }
    }
    
    return [NSArray arrayWithArray:array];
}


@end
