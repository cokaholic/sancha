//
//  FilteringManager.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "FilteringManager.h"
#import "EventDataManager.h"
#import "SortedArray.h"

@interface FilteringManager ()

@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSMutableDictionary *prefectureToIndex;
@property (nonatomic, retain) NSMutableArray *filteredPrefectures;
@property (nonatomic, retain) NSMutableArray *filteredPerformers;
@property (nonatomic, retain) SortedArray *sortedPerformers;
@property (nonatomic, retain) SortedArray *sortedPrefectures;
@property (nonatomic, retain) SortedArray *sortedPerformersTmp;
@property (nonatomic, retain) SortedArray *sortedPrefecturesTmp;


@end

@implementation FilteringManager

static FilteringManager *shared;

+ (FilteringManager *)sharedManager {
    if (!shared) {
        shared = [[FilteringManager alloc] init];
    }
    return shared;
}

- (id) init {
    self = [super init];
    if (self) {
        _saved = NO;
        _userDefaults = [NSUserDefaults standardUserDefaults];

        NSArray *prefectures = @[@"北海道", @"青森", @"岩手", @"宮城", @"秋田", @"山形", @"福島",
                                 @"茨城", @"栃木", @"群馬", @"埼玉", @"千葉", @"東京", @"神奈川",
                                 @"新潟", @"富山", @"石川", @"福井", @"山梨", @"長野", @"岐阜", @"静岡", @"愛知",
                                 @"三重", @"滋賀", @"京都", @"大阪", @"兵庫", @"奈良", @"和歌山",
                                 @"鳥取", @"島根", @"岡山", @"広島", @"山口",
                                 @"徳島", @"香川", @"愛媛", @"高知",
                                 @"福岡", @"佐賀", @"長崎", @"熊本", @"大分", @"宮崎", @"鹿児島", @"沖縄"];
        _prefectureToIndex = [NSMutableDictionary dictionary];

        for (int i = 0; i < prefectures.count; ++i) {
            _prefectureToIndex[prefectures[i]] = [NSNumber numberWithInt:i];
        }
        
        id prefectureCmp = ^(id id1, id id2) {
            NSNumber *n1 = _prefectureToIndex[id1];
            NSNumber *n2 = _prefectureToIndex[id2];
            if (n1 == nil || n2 == nil) return [id1 compare:id2];
            return [_prefectureToIndex[id1] compare:_prefectureToIndex[id2]];
        };
        _sortedPrefectures = [[SortedArray alloc] initWithCmp:prefectureCmp];
        _sortedPrefecturesTmp = [[SortedArray alloc] initWithCmp:prefectureCmp];
        
        id performerCmp = ^(id id1, id id2) {
            return [id1 compare:id2];
        };
        
        _sortedPerformers = [[SortedArray alloc] initWithCmp:performerCmp];
        _sortedPerformersTmp = [[SortedArray alloc] initWithCmp:performerCmp];

        [self reset];
    }
    return self;
}

- (void)reset {
    NSMutableArray *tmp;
    tmp = [_userDefaults objectForKey:@"filteredPerformers"];
    if (tmp != nil) {
        _sortedPerformers.array = [tmp mutableCopy];
        _sortedPerformersTmp.array = [tmp mutableCopy];
        _filteredPerformers = _sortedPerformers.array;
    }
    tmp = [_userDefaults objectForKey:@"filteredPrefectures"];
    if (tmp != nil) {
        _sortedPrefectures.array = [tmp mutableCopy];
        _filteredPrefectures = _sortedPrefectures.array;
    }
}

- (void)save {
    _saved = YES;
    [_userDefaults setObject:_sortedPrefectures.array forKey:@"filteredPrefectures"];
    [_userDefaults setObject:_sortedPerformers.array forKey:@"filteredPerformers"];
}

- (void)resetPrefecturesTmp {
    _sortedPrefecturesTmp.array = [_sortedPrefectures.array mutableCopy];
}

- (void)savePrefectures {
    _sortedPrefectures.array = [_sortedPrefecturesTmp.array mutableCopy];
    _filteredPrefectures = _sortedPrefectures.array;
}

- (void)resetPerformersTmp {
    _sortedPerformersTmp.array = [_sortedPerformers.array mutableCopy];
}

- (void)savePerformers {
    _sortedPerformers.array = [_sortedPerformersTmp.array mutableCopy];
    _filteredPerformers = _sortedPerformers.array;
}


- (void)setTmpBOOL:(BOOL)flag forPrefecture:(NSString *)name {
    if (flag) {
        [_sortedPrefecturesTmp insertObject:name];
    } else {
        [_sortedPrefecturesTmp removeObject:name];
    }
}

- (void)setTmpBOOL:(BOOL)flag forPerformer:(NSString *)name {
    if (flag) {
        [_sortedPerformersTmp insertObject:name];
    } else {
        [_sortedPerformersTmp removeObject:name];
    }
}

- (void)setBOOL:(BOOL)flag forPrefecture:(NSString *)name {    
    if (flag) {
        [_sortedPrefectures insertObject:name];
    } else {
        [_sortedPrefectures removeObject:name];
    }
    _filteredPrefectures = _sortedPrefectures.array;
}

- (void)setBOOL:(BOOL)flag forPerformer:(NSString *)name {
    if (flag) {
        [_sortedPerformers insertObject:name];
    } else {
        [_sortedPerformers removeObject:name];
    }
    _filteredPerformers = _sortedPerformers.array;
}


- (BOOL)isFilteredPrefecture:(NSString *)name {
    return [_sortedPrefectures existObject:name];
}

- (BOOL)isFilteredPerformer:(NSString *)name {
    return [_sortedPerformers existObject:name];
}

- (BOOL)isFilteredEvent:(EventData *)event {
    if (_filteredPrefectures.count > 0 && ![self isFilteredPrefecture:event.prefecture]) return NO;
    if (_filteredPerformers.count == 0) return YES;
    for (NSString *performer in event.performers) {
        if ([self isFilteredPerformer:performer]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isFiltering {
    return _filteredPerformers.count > 0 || _filteredPrefectures.count > 0;
}

@end
