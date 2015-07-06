//
//  PrefectureCellData.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "PrefectureCellData.h"
#import "FilteringManager.h"

@interface PrefectureCellData ()


@property(nonatomic, retain, readwrite) NSString *name;

@end

@implementation PrefectureCellData

- (id)initWithPrefectureString:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        _checked = [[FilteringManager sharedManager] isFilteredPrefecture:name];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    [[FilteringManager sharedManager] setBOOL:checked forPrefecture:self.name];
}

@end
