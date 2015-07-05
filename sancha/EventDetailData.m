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

- (id)initWithURL:(NSURL *)url completionHandler:(void (^)(NSError *error))completionHandler {
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
        [self reloadData:completionHandler];
    }
    return self;
}

- (void)reloadData:(void (^)(NSError *error))completionHandler {
    NSURLRequest *req = [NSURLRequest requestWithURL:self.url];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completionHandler(error);
            return;
        }
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (![self parseHTML:html]) {
            completionHandler([NSError errorWithDomain:@"html structure error" code:0 userInfo:nil]);
            return;
        }

        completionHandler(error);
    }];
}

- (BOOL)parseHTML:(NSString *)html {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return NO;
    }
    HTMLNode *articleNode = [parser.body findChildWithAttribute:@"id" matchingName:@"article" allowPartial:NO];
    self.title = [articleNode findChildTag:@"h2"].contents;
    HTMLNode *detailNode = [articleNode findChildOfClass:@"eventschedule"];
    NSArray *ps = [detailNode findChildTags:@"p"];
    for (HTMLNode *p in ps) {
        [self parseDateTime:p];
        [self parseLocation:p];
        [self parsePerformers:p];
        [self parseHowTo:p];
        [self parseOfficialPage:p];
    }
    return YES;
}

- (BOOL)checkString:(NSString *) str withPrefix:(NSString *) prefix {
    if (str.length < prefix.length) return NO;
    return ([[str substringToIndex:prefix.length] isEqualToString:prefix]);
}

- (NSString *)getsuffixOfNodeContent:(HTMLNode *)node from:(NSInteger)from {
    NSString *suffix = [node.allContents substringFromIndex:from];
    NSString *trimmed = [suffix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmed;
}

- (void)parseDateTime:(HTMLNode *)node {
    if ([self checkString:node.allContents withPrefix:@"■開催日時"]) {
        self.datetime = [self getsuffixOfNodeContent:node from:5];
    } else if ([self checkString:node.allContents withPrefix:@"■開催日"]) {
        self.datetime = [self getsuffixOfNodeContent:node from:4];
    } else if ([self checkString:node.allContents withPrefix:@"■開催時間"]) {
        if (![self.datetime isEqualToString:@""]) {
            NSString *str = [self getsuffixOfNodeContent:node from:5];
            self.datetime = [NSString stringWithFormat:@"%@\n%@", self.datetime, str];
        }
    }
}

- (void)parseLocation:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■会場"]) return;
    self.location = [self getsuffixOfNodeContent:node from:3];
}

- (void)parsePerformers:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■出演者"]) return;
    self.performers = [self getsuffixOfNodeContent:node from:4];
}

- (void)parseHowTo:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■参加方法"]) return;
    self.howTo = [self getsuffixOfNodeContent:node from:5];
}

- (void)parseOfficialPage:(HTMLNode *)node {
    if (![self checkString:node.allContents withPrefix:@"■公式HP"]) return;
    HTMLNode *aNode = [node findChildTag:@"a"];
    if (!aNode) return;
    self.officialPageTitle = [self getsuffixOfNodeContent:aNode from:0];
    self.officialPageURL = [NSURL URLWithString:[aNode getAttributeNamed:@"href"]];
}


@end
