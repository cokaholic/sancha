//
//  SortedArray.h
//  sancha
//
//  Created by tamura on 2015/07/05.
//  Copyright © 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortedArray : NSObject

@property (nonatomic,retain,readwrite) NSMutableArray *array;

- (id)initWithCmp:(NSComparisonResult (^)(id id1, id id2))cmp;
- (void)insertObject:(NSObject *)obj;
- (void)removeObject:(NSObject *)obj;
- (BOOL)existObject:(NSObject *)obj;
@end
