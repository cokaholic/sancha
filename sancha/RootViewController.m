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
#import "FilteringManager.h"
#import <UIScrollView+PullToRefreshCoreText.h>
#import <AutoScrollLabel/CBAutoScrollLabel.h>
#import <SVProgressHUD.h>

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) EventDataManager *manager;
@property (nonatomic, retain) UITableView *eventTableView;
@property (nonatomic, retain) NSMutableArray *searchData;
@property (nonatomic, retain) UIView *titleLogoView;
@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) GADBannerView *banner;
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) CBAutoScrollLabel *navBarTitleLabel;

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
    
    // load data
    [SVProgressHUD show];
    [_manager loadData:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [self showErrorAlert];
            return;
        }
        [self setUI];
    }];
    _searchData = [NSMutableArray arrayWithCapacity:_manager.dataList.count];
    _dataList = @[];
}

- (void)initUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _titleLogoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [Common screenSize].width - 100, 44)];
    _titleLogoView.backgroundColor = ACCENT_COLOR;
    
    UIImageView *titleLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, [Common screenSize].width - 100, 34)];
    titleLogoImageView.backgroundColor = ACCENT_COLOR;
    titleLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleLogoImageView.image = [UIImage imageNamed:@"image_title_logo"];
    [_titleLogoView addSubview:titleLogoImageView];
    
    self.navigationItem.titleView = _titleLogoView;
    
    _navBarTitleLabel = [[CBAutoScrollLabel alloc]initWithFrame:CGRectMake(0, 0, [Common screenSize].width-80, 44)];
    _navBarTitleLabel.textColor = DEFAULT_TEXT_COLOR;
    _navBarTitleLabel.font = DEFAULT_FONT(16);
    _navBarTitleLabel.scrollSpeed = 35;
    _navBarTitleLabel.labelSpacing = 30;
    _navBarTitleLabel.pauseInterval = 2.0;
    _navBarTitleLabel.scrollDirection = CBAutoScrollDirectionLeft;
    
    _eventTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, [Common screenSize].width, [Common screenSize].height - NAVBAR_HEIGHT - GAD_SIZE_320x50.height)];

    _eventTableView.dataSource = self;
    _eventTableView.delegate = self;
    _eventTableView.separatorStyle = NO;
    _eventTableView.backgroundColor = CLEAR_COLOR;
    _eventTableView.contentInset = UIEdgeInsetsMake(-NAVBAR_HEIGHT, 0, 0, 0);
    [self.view addSubview:_eventTableView];
    
    __weak typeof(self) weakSelf = self;
    [_eventTableView addPullToRefreshWithPullText:@"Pull To Refresh"
                                    pullTextColor:CANCEL_COLOR
                                     pullTextFont:REFRESH_TEXT_FONT(30)
                                   refreshingText:@"Refreshing"
                              refreshingTextColor:CANCEL_COLOR
                               refreshingTextFont:REFRESH_TEXT_FONT(30)
                                           action:^{
                                               [weakSelf.manager loadData:^(NSError *error) {
                                                   [weakSelf.eventTableView finishLoading];
                                                   if (error) {
                                                       [weakSelf showErrorAlert];
                                                       return;
                                                   }
                                                   [weakSelf setUI];
                                                   [weakSelf.eventTableView reloadData];
                                               }];
                                           }];

    // search
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SEARCH_BAR_HEIGHT)];
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButton setTitle:@"Close"];
    barButton.tintColor = CANCEL_COLOR;
    searchBar.tintColor = CANCEL_COLOR;
    searchBar.barTintColor = BACKGROUND_COLOR;
    [self.view addSubview: searchBar];
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsDelegate = self;
    _searchController.searchResultsDataSource = self;
    
    _searchController.searchResultsTableView.frame = CGRectMake(0, 0, [Common screenSize].width, [Common screenSize].height - NAVBAR_HEIGHT);
    _searchController.searchResultsTableView.backgroundColor = BACKGROUND_COLOR;
    _eventTableView.tableHeaderView = searchBar;
    
    //広告
    _banner = [[GADBannerView alloc]initWithFrame:CGRectMake(0, [Common screenSize].height - GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    _banner.adUnitID = MY_BANNER_UNIT_ID;
    _banner.rootViewController = self;
    _banner.backgroundColor = [UIColor clearColor];
    _banner.center = CGPointMake([Common screenSize].width/2, _banner.center.y);
    [self.view addSubview:_banner];
    [_banner loadRequest:[GADRequest request]];
}

- (void)setUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_filter"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goFilteringViewController)];
    
    FilteringManager *fmgr = [FilteringManager sharedManager];
    if ([fmgr isFiltering]) {
        NSString *title = nil;
        if (fmgr.filteredPerformers.count > 0) {
            title = [@"出演者：" stringByAppendingString:[fmgr.filteredPerformers componentsJoinedByString:@", "]];
        }
        if (fmgr.filteredPrefectures.count > 0) {
            NSString *preStr = [@"会場：" stringByAppendingString:[fmgr.filteredPrefectures componentsJoinedByString:@", "]];
            if (title != nil) {
                title = [NSString stringWithFormat:@"%@　%@", title, preStr];
            } else {
                title = preStr;
            }
        }
        _navBarTitleLabel.text = title;
        self.navigationItem.titleView = _navBarTitleLabel;
    } else {
        self.navigationItem.titleView = _titleLogoView;
    }
    

    // load filtered data
    if (!fmgr.saved) {
        [fmgr reset];
    }
    fmgr.saved = NO;
    _dataList = [_manager getFilteredDataList];
    [_eventTableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUI];
    
    [self.navigationController.navigationBar setTintColor:CANCEL_COLOR];
    [self.navigationController.navigationBar setBarTintColor:ACCENT_COLOR];
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
    return _dataList.count;
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

    EventData *eventData;
    
    if(tableView == self.searchController.searchResultsTableView) {
        eventData = (EventData *)_searchData[indexPath.row];
    } else {
        eventData = (EventData *)_dataList[indexPath.row];
    }

    
    [cell initCellWithData:eventData];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EventData *eventData;
    
    if(tableView == self.searchController.searchResultsTableView) {
        eventData = (EventData *)_searchData[indexPath.row];
    } else {
        eventData = (EventData *)_dataList[indexPath.row];
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;

    EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc]init];
    eventDetailViewController.detailURL = eventData.detailURL;
    [self .navigationController pushViewController:eventDetailViewController animated:YES];
}


- (void)filterContentForSearchText:(NSString*)searchString {
    [self.searchData removeAllObjects];
    for(EventData *data in _dataList) {
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"キャンセル";
    self.navigationItem.backBarButtonItem = backButton;
    
    [self.navigationController pushViewController:[[FilteringViewController alloc]init] animated:YES];
}

- (void)showErrorAlert {
    [[[UIAlertView alloc]initWithTitle:@"読み込みエラー"
                               message:@"情報を取得できませんでした。"
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil] show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(nonnull UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    return;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
