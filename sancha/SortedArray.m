//
//  SortedArray.m
//  sancha
//
//  Created by tamura on 2015/07/05.
//  Copyright © 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "SortedArray.h"

@interface SortedArray ()

@property (nonatomic, retain) id cmp;
@end

@implementation SortedArray

- (id)initWithCmp:(NSComparisonResult (^)(id id1, id id2))cmp {
    self = [super init];
    
    if (self) {
        _cmp = cmp;
        _array = [NSMutableArray array];
    }
    return self;
}

- (void)insertObject:(NSObject *)obj {
    NSUInteger idx = [_array indexOfObject:obj
                             inSortedRange:NSMakeRange(0, _array.count)
                                   options:NSBinarySearchingInsertionIndex
                                     usingComparator:_cmp];
    [_array insertObject:obj atIndex:idx];
}

- (void)removeObject:(NSObject *)obj {
    NSUInteger idx = [_array indexOfObject:obj
                             inSortedRange:NSMakeRange(0, _array.count)
                                   options:NSBinarySearchingFirstEqual
                           usingComparator:_cmp];
    if (idx < _array.count) {
        [_array removeObjectAtIndex:idx];
    }    
}

- (BOOL)existObject:(NSObject *)obj {
    if (obj == nil) return NO;
    NSUInteger idx = [_array indexOfObject:obj
                             inSortedRange:NSMakeRange(0, _array.count)
                                   options:NSBinarySearchingFirstEqual
                           usingComparator:_cmp];
    return (idx < _array.count);
}

@end
