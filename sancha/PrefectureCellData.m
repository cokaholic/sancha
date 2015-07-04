//
//  PrefectureCellData.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "PrefectureCellData.h"

@interface PrefectureCellData ()


@property(nonatomic, retain, readwrite) NSString *name;

@end

@implementation PrefectureCellData

- (id)initWithPrefectureString:(NSString *)string {
    self = [super init];
    if (self) {
        self.name = string;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [@"p:" stringByAppendingString:self.name];
        self.checked = [userDefaults boolForKey:key];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [@"p:" stringByAppendingString:self.name];
    [userDefaults setBool:checked forKey:key];
}

@end
