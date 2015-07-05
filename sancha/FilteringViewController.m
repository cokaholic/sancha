//
//  FilteringViewController.m
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/05.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "FilteringViewController.h"
#import "Common.h"

@interface FilteringViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_filteringTableView;
    UIButton *_filteringButton;
    
    NSArray *_sectionIconList;
    NSArray *_sectionTitleList;
    
    NSArray *_testPerformerList;
    NSArray *_testLocationList;
}
@end

@implementation FilteringViewController


static NSString * const kCellIdentifier = @"FilteringCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self setUI];
}

- (void)initData
{
    _sectionIconList = @[@"icon_actor", @"icon_pin"];
    _sectionTitleList = @[@"出演者", @"会場"];
    
    _testPerformerList = @[@"小倉唯", @"竹達彩奈", @"茅原実里", @"水樹奈々"];
    _testLocationList = @[@"東京",];
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
    
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@を選ぶ",_sectionTitleList[indexPath.section]];
        cell.textLabel.textColor = PALE_TEXT_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Action

- (void)dismissPresentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doFiltering
{
    //TODO: フィルタリング内容決定時の処理
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
