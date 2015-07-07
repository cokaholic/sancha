//
//  FilteringTableViewCell.h
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/05.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface FilteringTableViewCell : SWTableViewCell

@property (nonatomic, retain, readonly) NSIndexPath *indexPath;

- (void)addDeleteButtonWithIndexPath:(NSIndexPath *)indexPath;
- (void)removeDeleteButton;

@end