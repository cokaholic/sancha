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
#import "FilteringManager.h"
#import <SVProgressHUD.h>

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
    }
    return self;
}

- (void) loadData:(void (^)(NSError *error))completionHandler {
    NSString *url = @"http://www.koepota.jp/eventschedule/";
    NSURL *urlRequest = [NSURL URLWithString:url];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:urlRequest];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completionHandler(error);
            return;
        }
        NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if (statusCode >= 400) {
            completionHandler([NSError errorWithDomain:[NSString stringWithFormat:@"error code %ld", statusCode] code:0 userInfo:nil]);
        }
        
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (![self parseHTML:html]) {
            completionHandler([NSError errorWithDomain:@"html structure error" code:0 userInfo:nil]);
            return;
        }
        
        // set performeœrs
        NSMutableSet *ngStrings = [NSMutableSet setWithArray:@[@"他", @"主演キャスト", @"未定"]];
        NSMutableSet *set = [NSMutableSet set];
        for (EventData *event in self.dataList) {
            for (NSString *performer in event.performers) {
                if ([ngStrings containsObject:performer]) {
                    continue;
                }
                [set addObject:performer];
            }
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
        NSArray *sortedPerformers = [set.allObjects sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        self.performers = [NSArray arrayWithArray:sortedPerformers];
        
        completionHandler(error);
    }];
}

- (BOOL) parseHTML:(NSString*)html {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return NO;
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
    return YES;
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
