//
//  FilteringTableViewCell.m
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/05.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "FilteringTableViewCell.h"
#import "Common.h"
#import "FilteringManager.h"

@interface FilteringTableViewCell ()

@property (nonatomic, retain, readwrite) NSIndexPath *indexPath;
@property (nonatomic, retain) NSMutableArray *deleteButtonArray;
@end

@implementation FilteringTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _deleteButtonArray = [NSMutableArray new];
        [_deleteButtonArray sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                   title:@"削除"];        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDeleteButtonWithIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.rightUtilityButtons = _deleteButtonArray;
}

- (void)removeDeleteButton
{
    self.rightUtilityButtons = @[];
}

@end
