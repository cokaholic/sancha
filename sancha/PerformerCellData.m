//
//  PerformerCellData.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "PerformerCellData.h"
#import "FilteringManager.h"

@interface PerformerCellData ()

@property(nonatomic, retain, readwrite) NSString *name;

@end

@implementation PerformerCellData

- (id)initWithPerformerName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        _checked = [[FilteringManager sharedManager] isFilteredPerformer:name];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    [[FilteringManager sharedManager] setBOOL:checked forPerformer:self.name];
}


@end
