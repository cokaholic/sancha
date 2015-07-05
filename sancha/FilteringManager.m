//
//  FilteringManager.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "FilteringManager.h"
#import "EventDataManager.h"

@interface FilteringManager ()

@property(nonatomic, retain) NSUserDefaults *userDefaults;
@property(nonatomic, retain) NSArray *prefectures;

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
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        self.prefectures = @[@"北海道", @"青森県", @"岩手県", @"宮城県", @"秋田県", @"山形県", @"福島県",
                             @"茨城県", @"栃木県", @"群馬県", @"埼玉県", @"千葉県", @"東京都", @"神奈川県",
                             @"新潟県", @"富山県", @"石川県", @"福井県", @"山梨県", @"長野県", @"岐阜県", @"静岡県", @"愛知県",
                             @"三重県", @"滋賀県", @"京都府", @"大阪府", @"兵庫県", @"奈良県", @"和歌山県",
                             @"鳥取県", @"島根県", @"岡山県", @"広島県", @"山口県",
                             @"徳島県", @"香川県", @"愛媛県", @"高知県",
                             @"福岡県", @"佐賀県", @"長崎県", @"熊本県", @"大分県", @"宮崎県", @"鹿児島県", @"沖縄県"];
    }
    return self;
}

- (NSString *)getKeyPrefecture:(NSString *)name {
    return [@"r:" stringByAppendingString:name];
}

- (NSString *)getKeyPerformer:(NSString *)name {
    return [@"e:" stringByAppendingString:name];
}


- (void)setBOOL:(BOOL)flag forPrefecture:(NSString *)name {
    [self.userDefaults setBool:flag forKey:[self getKeyPrefecture:name]];
}

- (void)setBOOL:(BOOL)flag forPerformer:(NSString *)name {
    [self.userDefaults setBool:flag forKey:[self getKeyPerformer:name]];
}

- (BOOL)isFilteredPrefecture:(NSString *)name {
    return [self.userDefaults boolForKey:[self getKeyPrefecture:name]];
}

- (BOOL)isFilteredPerformer:(NSString *)name {
    return [self.userDefaults boolForKey:[self getKeyPerformer:name]];
}

- (NSArray *)getFilteredPrefectures {
    NSMutableArray *res = [NSMutableArray array];
    for (NSString *name in self.prefectures) {
        if ([self isFilteredPrefecture:name]) {
            [res addObject:name];
        }
    }
    return [NSArray arrayWithArray:res];
}

- (NSArray *)getFilteredPerformers {
    NSArray *performers = [EventDataManager sharedManager].performers;
    
    NSMutableArray *res = [NSMutableArray array];
    for (NSString *name in performers) {
        if ([self isFilteredPerformer:name]) {
            [res addObject:name];
        }
    }
    return [NSArray arrayWithArray:res];
}


@end
