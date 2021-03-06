//
//  EventDataManager.h
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDataManager : NSObject

@property(nonatomic, retain, readonly) NSArray *dataList;
@property(nonatomic, retain, readonly) NSArray *performers;

+ (EventDataManager *) sharedManager;
- (void) loadData:(void (^)(NSError *error))completionHandler;

- (NSArray *) getFilteredDataList;

@end
