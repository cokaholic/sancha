//
//  FilteringViewController.m
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/05.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "FilteringViewController.h"
#import "Common.h"
#import "FilteringTableViewCell.h"
#import "FilteringManager.h"
#import "PerformerViewController.h"
#import "PrefectureViewController.h"

@interface FilteringViewController () <UITableViewDelegate, UITableViewDataSource, FilteringTableViewCellDelegate>
{
    UITableView *_filteringTableView;
    UIButton *_filteringButton;
    
    NSArray *_sectionIconList;
    NSArray *_sectionTitleList;
    
    FilteringManager *_manager;
}
@end

@implementation FilteringViewController


static NSString * const kCellIdentifier = @"FilteringCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)initData
{
    _manager = [FilteringManager sharedManager];
    
    _sectionIconList = @[@"icon_actor", @"icon_pin"];
    _sectionTitleList = @[@"出演者", @"会場"];
}

- (void)initUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _filteringTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [Common screenSize].width, [Common screenSize].height - 60)];
    _filteringTableView.backgroundColor = ACCENT_COLOR;
    _filteringTableView.dataSource = self;
    _filteringTableView.delegate = self;
    [self.view addSubview:_filteringTableView];
    
    _filteringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _filteringButton.frame = CGRectMake(10, [Common screenSize].height - 50, [Common screenSize].width - 20, 40);
    _filteringButton.backgroundColor = MAIN_COLOR;
    _filteringButton.layer.masksToBounds = YES;
    _filteringButton.layer.cornerRadius = _filteringButton.frame.size.height/2;
    [_filteringButton setTitle:@"この条件で絞り込む" forState:UIControlStateNormal];
    _filteringButton.titleLabel.font = DEFAULT_BOLD_FONT(16);
    [_filteringButton addTarget:self
                      action:@selector(doFiltering)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_filteringButton];
    
}

- (void)setUI
{
    [_filteringTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUI];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) return [_manager getFilteredPerformers].count + 1;
    else            return [_manager getFilteredPrefectures].count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [Common screenSize].width, DEFAULT_HEADER_HEIGHT)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    iconImageView.backgroundColor = CLEAR_COLOR;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = [UIImage imageNamed:_sectionIconList[section]];
    [headerView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    titleLabel.backgroundColor = CLEAR_COLOR;
    titleLabel.font = DEFAULT_BOLD_FONT(14);
    titleLabel.textColor = DEFAULT_TEXT_COLOR;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = _sectionTitleList[section];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULT_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DEFAULT_HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilteringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[FilteringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@を選ぶ",_sectionTitleList[indexPath.section]];
        cell.textLabel.textColor = PALE_TEXT_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        if (indexPath.section==0) {
            cell.textLabel.text = [_manager getFilteredPerformers][indexPath.row-1];
        }
        else {
            cell.textLabel.text = [_manager getFilteredPrefectures][indexPath.row-1];
        }
        
        cell.textLabel.textColor = DEFAULT_TEXT_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    cell.textLabel.font = DEFAULT_FONT(16);
    
    [cell addDeleteButtonWithIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0 && indexPath.row==0) {
        [self.navigationController pushViewController:[[PerformerViewController alloc]init] animated:YES];
    }
    else if (indexPath.section==1 && indexPath.row==0) {
        [self.navigationController pushViewController:[[PrefectureViewController alloc]init] animated:YES];
    }
}

#pragma mark - FilteringTableViewCell Delegate

- (void)didSelectDeleteButton
{
    [_filteringTableView reloadData];
}

#pragma mark - Button Action

- (void)doFiltering
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end