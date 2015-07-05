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
        _userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *prefectures = @[@"北海道", @"青森県", @"岩手県", @"宮城県", @"秋田県", @"山形県", @"福島県",
                             @"茨城県", @"栃木県", @"群馬県", @"埼玉県", @"千葉県", @"東京都", @"神奈川県",
                             @"新潟県", @"富山県", @"石川県", @"福井県", @"山梨県", @"長野県", @"岐阜県", @"静岡県", @"愛知県",
                             @"三重県", @"滋賀県", @"京都府", @"大阪府", @"兵庫県", @"奈良県", @"和歌山県",
                             @"鳥取県", @"島根県", @"岡山県", @"広島県", @"山口県",
                             @"徳島県", @"香川県", @"愛媛県", @"高知県",
                             @"福岡県", @"佐賀県", @"長崎県", @"熊本県", @"大分県", @"宮崎県", @"鹿児島県", @"沖縄県"];
        _prefectureToIndex = [NSMutableDictionary dictionary];

        for (int i = 0; i < prefectures.count; ++i) {
            _prefectureToIndex[prefectures[i]] = [NSNumber numberWithInt:i];
        }

        _sortedPrefectures = [[SortedArray alloc] initWithCmp:^(id id1, id id2) {
            return [_prefectureToIndex[id1] compare:_prefectureToIndex[id2]];
        }];
        _sortedPerformers = [[SortedArray alloc] initWithCmp:^(id id1, id id2) {
            return [id1 compare:id2];
        }];

        NSMutableArray *tmp;
        tmp = [_userDefaults objectForKey:@"filteredPerformers"];
        if (tmp != nil) {
            _sortedPerformers.array = [tmp mutableCopy];
            _filteredPerformers = _sortedPerformers.array;
        }
        tmp = [_userDefaults objectForKey:@"filteredPrefectures"];
        if (tmp != nil) {
            _sortedPrefectures.array = [tmp mutableCopy];
            _filteredPrefectures = _sortedPrefectures.array;
        }
    }
    return self;
}

- (void)setBOOL:(BOOL)flag forPrefecture:(NSString *)name {
    if (flag) {
        [_sortedPrefectures insertObject:name];
    } else {
        [_sortedPrefectures removeObject:name];
    }
    _filteredPrefectures = _sortedPrefectures.array;
    [_userDefaults setObject:_sortedPrefectures.array forKey:@"filteredPrefectures"];
}

- (void)setBOOL:(BOOL)flag forPerformer:(NSString *)name {
    if (flag) {
        [_sortedPerformers insertObject:name];
    } else {
        [_sortedPerformers removeObject:name];
    }
    _filteredPerformers = _sortedPerformers.array;
    [_userDefaults setObject:_sortedPerformers.array forKey:@"filteredPerformers"];
}


- (BOOL)isFilteredPrefecture:(NSString *)name {
    return [_sortedPrefectures existObject:name];
}

- (BOOL)isFilteredPerformer:(NSString *)name {
    return [_sortedPerformers existObject:name];
}

- (BOOL)isFilteredEvent:(EventData *)event {
    if ([self isFilteredPrefecture:event.prefecture]) return YES;
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
