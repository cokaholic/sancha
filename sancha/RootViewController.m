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
#import "EventDataManager.h"
#import "EventData.h"
#import "EventDetailViewController.h"
#import <UIScrollView+PullToRefreshCoreText.h>

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) EventDataManager *manager;
@property (nonatomic, retain) UITableView *eventTableView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self setUI];
}

- (void)initData
{
    _manager = [EventDataManager sharedManager];
}

- (void)initUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _eventTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, [Common screenSize].width, [Common screenSize].height - STATUSBAR_HEIGHT)];
    _eventTableView.dataSource = self;
    _eventTableView.delegate = self;
    _eventTableView.separatorStyle = NO;
    _eventTableView.backgroundColor = CLEAR_COLOR;
    _eventTableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self.view addSubview:_eventTableView];
    
    __weak typeof(self) weakSelf = self;
    [_eventTableView addPullToRefreshWithPullText:@"Pull To Refresh"
                                    pullTextColor:[UIColor blackColor]
                                     pullTextFont:REFRESH_TEXT_FONT(30)
                                   refreshingText:@"Refreshing"
                              refreshingTextColor:MAIN_COLOR
                               refreshingTextFont:REFRESH_TEXT_FONT(30)
                                           action:^{
                                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
                                                   
                                                   [weakSelf.manager loadData];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [weakSelf.eventTableView reloadData];
                                                       [weakSelf.eventTableView finishLoading];
                                                   });
                                               });
                                           }];
}

- (void)setUI
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _manager.dataList.count;
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
    
    EventData *eventData = (EventData *)_manager.dataList[indexPath.row];
    
    [cell initCellWithData:eventData];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EventData *eventData = (EventData *)_manager.dataList[indexPath.row];
    EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc]init];
    eventDetailViewController.detailURL = eventData.detailURL;
    [self .navigationController pushViewController:eventDetailViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
