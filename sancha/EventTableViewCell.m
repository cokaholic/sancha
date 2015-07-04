//
//  EventTableViewCell.m
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Common.h"

@interface EventTableViewCell ()
{
    UILabel *_yearLabel;
    UILabel *_monthAndDayLabel;
    UILabel *_timeLabel;
    UILabel *_titleLabel;
    UILabel *_locationLabel;
    UILabel *_actorsLabel;
}
@end

@implementation EventTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = BACKGROUND_COLOR;
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, [Common screenSize].width - 10, EVENT_CELL_HEIGHT - 10)];
    baseView.backgroundColor = ACCENT_COLOR;
    baseView.layer.cornerRadius = 3; // if you like rounded corners
    baseView.layer.shadowOffset = CGSizeMake(0, 0.5); // 上向きの影
    baseView.layer.shadowRadius = 3;
    baseView.layer.shadowOpacity = 0.1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(60, 5, 0.3, EVENT_CELL_HEIGHT - 20)];
    lineView.backgroundColor = LINE_VIEW_COLOR;
    [baseView addSubview:lineView];
    
    _yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 20)];
    _yearLabel.backgroundColor = CLEAR_COLOR;
    _yearLabel.font = DEFAULT_FONT(14);
    _yearLabel.textColor = DEFAULT_TEXT_COLOR;
    _yearLabel.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:_yearLabel];
    
    _monthAndDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_yearLabel.frame)-2, 60, 30)];
    _monthAndDayLabel.backgroundColor = CLEAR_COLOR;
    _monthAndDayLabel.font = DEFAULT_BOLD_FONT(15);
    _monthAndDayLabel.textColor = DEFAULT_TEXT_COLOR;
    _monthAndDayLabel.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:_monthAndDayLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_monthAndDayLabel.frame)-4, 60, 30)];
    _timeLabel.backgroundColor = CLEAR_COLOR;
    _timeLabel.font = DEFAULT_FONT(14);
    _timeLabel.textColor = DEFAULT_TEXT_COLOR;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65.5, 5, baseView.frame.size.width - 70.5, 45)];
    _titleLabel.backgroundColor = CLEAR_COLOR;
    _titleLabel.font = DEFAULT_BOLD_FONT(16);
    _titleLabel.textColor = DEFAULT_TEXT_COLOR;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    [baseView addSubview:_titleLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(baseView.frame) - 60 - 5, 0.5)];
    lineView.backgroundColor = LINE_VIEW_COLOR;
    [baseView addSubview:lineView];
    
    UIImageView *locationIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(62.5, CGRectGetMaxY(_titleLabel.frame) + 5, 20, 20)];
    locationIconImageView.backgroundColor = CLEAR_COLOR;
    locationIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    locationIconImageView.image = [UIImage imageNamed:@"icon_pin"];
    [baseView addSubview:locationIconImageView];
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationIconImageView.frame), CGRectGetMaxY(_titleLabel.frame), 60, 30)];
    _locationLabel.backgroundColor = CLEAR_COLOR;
    _locationLabel.font = DEFAULT_FONT(14);
    _locationLabel.textColor = DEFAULT_TEXT_COLOR;
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    [baseView addSubview:_locationLabel];
    
    UIImageView *actorIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65.5 + 80, CGRectGetMinY(locationIconImageView.frame), 20, 20)];
    actorIconImageView.backgroundColor = CLEAR_COLOR;
    actorIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    actorIconImageView.image = [UIImage imageNamed:@"icon_actor"];
    [baseView addSubview:actorIconImageView];
    
    _actorsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(actorIconImageView.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(baseView.frame) - CGRectGetMaxX(actorIconImageView.frame), 30)];
    _actorsLabel.backgroundColor = CLEAR_COLOR;
    _actorsLabel.font = DEFAULT_FONT(14);
    _actorsLabel.textColor = DEFAULT_TEXT_COLOR;
    _actorsLabel.textAlignment = NSTextAlignmentLeft;
    [baseView addSubview:_actorsLabel];
    
    //TEST
    _yearLabel.text = @"2015";
    _monthAndDayLabel.text = @"07/04";
    _timeLabel.text = @"14:00";
    _titleLabel.attributedText = [Common attributedTextWithString:@"とある科学の超電磁砲 -レールガン- 第３期 第１話先行上映会 at 秋葉原UDX"
                                                       lineHeight:5];
    _locationLabel.text = @"鹿児島県";
    _actorsLabel.text = @"豊崎愛生、小倉唯、浅倉杏美";
    
    [self addSubview:baseView];
}

- (void)initCellWithData:(NSDictionary *)data
{
    
}

@end
