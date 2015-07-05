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
#import "FilteringViewController.h"
#import <UIScrollView+PullToRefreshCoreText.h>

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, retain) EventDataManager *manager;
@property (nonatomic, retain) UITableView *eventTableView;
@property (nonatomic, retain) NSMutableArray *searchData;
@property (nonatomic, retain) UISearchDisplayController *searchController;

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
    _searchData = [NSMutableArray arrayWithCapacity: _manager.dataList.count];
}

- (void)initUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_filter"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goFilteringViewController)];
    
    _eventTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, [Common screenSize].width, [Common screenSize].height - NAVBAR_HEIGHT)];
    _eventTableView.dataSource = self;
    _eventTableView.delegate = self;
    _eventTableView.separatorStyle = NO;
    _eventTableView.backgroundColor = CLEAR_COLOR;
    _eventTableView.contentInset = UIEdgeInsetsMake(-NAVBAR_HEIGHT, 0, 0, 0);
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

    // search
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SEARCH_BAR_HEIGHT)];
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButton setTitle:@"Close"];
    barButton.tintColor = MAIN_COLOR;
    searchBar.tintColor = MAIN_COLOR;
    [self.view addSubview: searchBar];
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsDelegate = self;
    _searchController.searchResultsDataSource = self;
    
    _searchController.searchResultsTableView.frame = CGRectMake(0, 0, [Common screenSize].width, [Common screenSize].height - NAVBAR_HEIGHT);

    _eventTableView.tableHeaderView = searchBar;
    
    
}

- (void)setUI
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:MAIN_COLOR];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _searchController.searchResultsTableView) {
        return _searchData.count;
    }    
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
    
    if(tableView == self.searchController.searchResultsTableView) {
        eventData = (EventData *)_searchData[indexPath.row];
    } else {
        eventData = (EventData *)_manager.dataList[indexPath.row];
    }

    
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


- (void)filterContentForSearchText:(NSString*)searchString {
    [self.searchData removeAllObjects];
    for(EventData *data in _manager.dataList) {
        NSString *str = data.title;
        NSRange range = [str rangeOfString:searchString
                                   options:NSCaseInsensitiveSearch];
        if(range.length > 0) {
            [self.searchData addObject:data];
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString {
    [self filterContentForSearchText: searchString];
    return YES;
}

- (void)searchDisplayController:(nonnull UISearchDisplayController *)controller didLoadSearchResultsTableView:(nonnull UITableView *)tableView {
    [controller.searchResultsTableView setContentOffset:CGPointZero animated:NO]; // scroll to top
}

- (void)goFilteringViewController
{
    [self.navigationController pushViewController:[[FilteringViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
