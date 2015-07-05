//
//  EventDetailData.h
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDetailData : NSObject

@property(nonatomic, retain, readonly) NSString *title;
@property(nonatomic, retain, readonly) NSString *datetime;
@property(nonatomic, retain, readonly) NSString *location;
@property(nonatomic, retain, readonly) NSString *performers;
@property(nonatomic, retain, readonly) NSString *howTo;
@property(nonatomic, retain, readonly) NSString *officialPageTitle;
@property(nonatomic, retain, readonly) NSURL *officialPageURL;

- (id)initWithURL:(NSURL *)url completionHandler:(void (^)(NSError *error))completionHandler;
- (void)reloadData;

@end
