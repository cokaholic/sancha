//
//  FilteringTableViewCell.h
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/05.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilteringTableViewCellDelegate;

@interface FilteringTableViewCell : UITableViewCell

@property (nonatomic, weak) id<FilteringTableViewCellDelegate>delegate;

- (void)addDeleteButtonWithIndexPath:(NSIndexPath *)indexPath;

- (void)removeDeleteButton;

@end

@protocol FilteringTableViewCellDelegate <NSObject>

@required

- (void)didSelectDeleteButton;

@end
