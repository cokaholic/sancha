//
//  EventData.h
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"

@interface EventData : NSObject

// 日時
@property (nonatomic, retain, readonly) NSDate *date;
@property (nonatomic, assign, readonly) BOOL timeUndefined;
// タイトル
@property (nonatomic, retain, readonly) NSString *title;
// 会場
@property (nonatomic, retain, readonly) NSString *prefecture;
@property (nonatomic, retain, readonly) NSString *city;
@property (nonatomic, retain, readonly) NSString *spot;
// 出演者
@property (nonatomic, retain, readonly) NSArray *performers;
// 詳細ページ
@property (nonatomic, retain, readonly) NSURL *detailURL;


- (id) initWithHTMLNode:(HTMLNode *) node;

@end
