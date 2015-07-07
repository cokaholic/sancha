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

@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain, readwrite) NSIndexPath *indexPath;
@property (nonatomic, retain) NSMutableArray *deleteButtonArray;

@end

@implementation FilteringTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _deleteButtonArray = [NSMutableArray new];
        [_deleteButtonArray sw_addUtilityButtonWithColor:CANCEL_COLOR
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
    if (_deleteButton) {
        [_deleteButton removeFromSuperview];
    }
    
    _indexPath = indexPath;
    self.rightUtilityButtons = _deleteButtonArray;
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake([Common screenSize].width - DEFAULT_CELL_HEIGHT, 0, DEFAULT_CELL_HEIGHT, DEFAULT_CELL_HEIGHT);
    _deleteButton.backgroundColor = CLEAR_COLOR;
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
    self.rightUtilityButtons = @[];
    
    for (id view in self.subviews) {
        if ([[view class] isEqual:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)setDeleteButtonHidden:(BOOL)isHidden
{
    _deleteButton.hidden = isHidden;
}

- (void)selectDeleteButton
{
    if (_indexPath.section==0) {
        [[FilteringManager sharedManager] setBOOL:NO forPerformer:self.textLabel.text];
    }
    else if (_indexPath.section==1) {
        [[FilteringManager sharedManager] setBOOL:NO forPrefecture:self.textLabel.text];
    }
    
    [_deleteButtonDelegate didSelectDeleteButton];
}

@end
