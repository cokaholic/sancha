//
//  RootViewController.m
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "RootViewController.h"
#import "Common.h"
#import "EventTableViewCell.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_eventTableView;
    NSMutableArray *_eventItemArray;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self setUI];
}

- (void)initData
{
    _eventItemArray = [[NSMutableArray alloc]init];
    
    //TEST
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
    [_eventItemArray addObject:@"test"];
}

- (void)initUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _eventTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, [Common screenSize].width, [Common screenSize].height - STATUSBAR_HEIGHT)];
    _eventTableView.dataSource = self;
    _eventTableView.delegate = self;
    _eventTableView.separatorStyle = NO;
    _eventTableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:_eventTableView];
}

- (void)setUI
{
    
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _eventItemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EVENT_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [cell initCellWithData:[[NSDictionary alloc]init]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end