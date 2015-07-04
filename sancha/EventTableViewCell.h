//
//  EventTableViewCell.h
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventData.h"

@interface EventTableViewCell : UITableViewCell

- (void)initCellWithData:(EventData *)data;

@end
