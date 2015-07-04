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


+ (EventDataManager *) sharedManager;


@end
