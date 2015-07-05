//
//  FilteringManager.h
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventData.h"

@interface FilteringManager : NSObject

@property(nonatomic, retain) NSArray *performers;

+ (FilteringManager *) sharedManager;

- (void)setBOOL:(BOOL)flag forPrefecture:(NSString *)name;
- (void)setBOOL:(BOOL)flag forPerformer:(NSString *)name;
- (BOOL)isFilteredPrefecture:(NSString *)name;
- (BOOL)isFilteredPerformer:(NSString *)name;
- (BOOL)isFilteredEvent:(EventData *)event;
- (NSArray *)getFilteredPrefectures;
- (NSArray *)getFilteredPerformers;

@end
