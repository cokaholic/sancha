//
//  EventDetailData.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "EventDetailData.h"
#import "HTMLParser.h"

@interface EventDetailData()

@property(nonatomic, retain, readwrite) NSString *title;
@property(nonatomic, retain, readwrite) NSString *datetime;
@property(nonatomic, retain, readwrite) NSString *location;
@property(nonatomic, retain, readwrite) NSString *performers;
@property(nonatomic, retain, readwrite) NSString *howTo;
@property(nonatomic, retain, readwrite) NSString *officialPageTitle;
@property(nonatomic, retain, readwrite) NSURL *officialPageURL;
@property(nonatomic, retain) NSURL *url;

@end

@implementation EventDetailData

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
        self.title = @"";
        self.datetime = @"";
        self.location = @"";
        self.performers = @"";
        self.howTo = @"";
        self.officialPageTitle = @"";
        self.officialPageURL = nil;
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    NSError *error = nil;
    NSString *html = [NSString stringWithContentsOfURL:self.url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        // error!!!!
        NSLog(@"Error: %@", error);
        return;
    }
    [self parseHTML:html];
}

- (void)parseHTML:(NSString *)html {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    HTMLNode *articleNode = [parser.body findChildWithAttribute:@"id" matchingName:@"article" allowPartial:NO];
    self.title = [articleNode findChildTag:@"h2"].contents;
    HTMLNode *detailNode = [articleNode findChildOfClass:@"eventschedule"];
    NSArray *ps = [detailNode findChildTags:@"p"];
    if (ps.count != 5) {
        NSLog(@"html format is wrong... : %@", self.url);
        return;
    }
    [self parseDateTime:ps[0]];
    [self parseLocation:ps[1]];
    [self parsePerformers:ps[2]];
    [self parseHowTo:ps[3]];
    [self parseOfficialPage:ps[4]];
}

- (BOOL)checkString:(NSString *) str withPrefix:(NSString *) prefix {
    if (str.length < prefix.length) return NO;
    return ([[str substringToIndex:prefix.length] isEqualToString:prefix]);
}

- (void)parseDateTime:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■開催日時"]) return;
    self.datetime = [node.allContents substringFromIndex:5];
}

- (void)parseLocation:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■会場"]) return;
    self.location = [node.allContents substringFromIndex:3];
}

- (void)parsePerformers:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■出演者"]) return;
    self.performers = [node.allContents substringFromIndex:4];
}

- (void)parseHowTo:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■参加方法"]) return;
    self.howTo = [node.allContents substringFromIndex:5];
}

- (void)parseOfficialPage:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■公式HP"]) return;
    HTMLNode *aNode = [node findChildTag:@"a"];
    if (!aNode) return;
    self.officialPageTitle = aNode.contents;
    self.officialPageURL = [NSURL URLWithString:[aNode getAttributeNamed:@"href"]];
}


@end
