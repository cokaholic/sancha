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
{
    UIButton *_deleteButton;
    NSIndexPath *_cellIndexPath;
}
@end

@implementation FilteringTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addDeleteButtonWithIndexPath:(NSIndexPath *)indexPath
{
    _cellIndexPath = indexPath;
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake([Common screenSize].width - 34, 10, DEFAULT_CELL_HEIGHT - 20, DEFAULT_CELL_HEIGHT - 20);
    _deleteButton.backgroundColor = CANCEL_COLOR;
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    _deleteButton.layer.masksToBounds = YES;
    _deleteButton.layer.cornerRadius = CGRectGetHeight(_deleteButton.frame)/2;
    [_deleteButton addTarget:self
                      action:@selector(selectDeleteButton)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];
}

- (void)removeDeleteButton
{
    for (id view in self.subviews) {
        if ([[view class] isEqual:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)selectDeleteButton
{
    if (_cellIndexPath.section==0) {
        [[FilteringManager sharedManager] setBOOL:NO forPerformer:self.textLabel.text];
    }
    else if (_cellIndexPath.section==1) {
        [[FilteringManager sharedManager] setBOOL:NO forPrefecture:self.textLabel.text];
    }
    
    [_delegate didSelectDeleteButton];
}

@end
