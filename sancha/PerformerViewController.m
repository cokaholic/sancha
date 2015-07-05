//
//  PerformerViewController.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "PerformerViewController.h"
#import "EventDataManager.h"
#import "PerformerCellData.h"
#import "Common.h"

@interface PerformerViewController () <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray *searchData;
@property(nonatomic, retain) NSArray *performers;
@property(nonatomic, retain) UISearchDisplayController *seachController;
@property(nonatomic, retain) UITableView *tableView;

@end

@implementation PerformerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self initUI];
    [self setUI];
}

- (void)initData {
    NSArray *performerNames = [EventDataManager sharedManager].performers;
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *performerName in performerNames) {
        PerformerCellData *data = [[PerformerCellData alloc] initWithPerformerName:performerName];
        [array addObject:data];
    }
    self.performers = [NSArray arrayWithArray:array];
    self.searchData = [NSMutableArray arrayWithCapacity: self.performers.count];
}

- (void)initUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButton setTitle:@"Close"];
    barButton.tintColor = MAIN_COLOR;
    searchBar.tintColor = MAIN_COLOR;
    
    self.seachController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.seachController.delegate = self;
    self.seachController.searchResultsDelegate = self;
    self.seachController.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = searchBar;
}

- (void)setUI {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.seachController.searchResultsTableView) {
        return self.searchData.count;
    }
    return self.performers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PerformerCellData *data;
    if(tableView == self.seachController.searchResultsTableView) {
        data = self.searchData[indexPath.row];
    } else {
        data = self.performers[indexPath.row];
    }
    
    if (data.checked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = data.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PerformerCellData *data;
    if(tableView == self.seachController.searchResultsTableView) {
        data = self.searchData[indexPath.row];
    } else {
        data = self.performers[indexPath.row];
    }
    data.checked = !data.checked;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)filterContentForSearchText:(NSString*)searchString {
    [self.searchData removeAllObjects];
    for(PerformerCellData *data in self.performers) {
        NSString *str = data.name;
        NSRange range = [str rangeOfString:searchString
                                     options:NSCaseInsensitiveSearch];
        if(range.length > 0)
            [self.searchData addObject:data];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString {
    [self filterContentForSearchText: searchString];
    [controller.searchResultsTableView setContentOffset:CGPointZero animated:NO]; // scroll to top
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
