//
//  PrefectureCellData.h
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrefectureCellData : NSObject

@property(nonatomic, retain, readonly) NSString *name;
@property(nonatomic, assign) BOOL checked;

- (id)initWithPrefectureString:(NSString *)name;

@end
