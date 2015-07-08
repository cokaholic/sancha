//
//  PrefectureViewController.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//


#import "PrefectureViewController.h"
#import "Common.h"
#import "PrefectureCellData.h"
#import "FilteringManager.h"

@interface PrefectureViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *areaNames;
@property (nonatomic, retain) NSArray *areaPrefectures;
@property (nonatomic, retain) GADBannerView *banner;

@end

@implementation PrefectureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self setUI];
}

- (void)initData {
    self.areaNames = @[@"北海道／東北", @"関東", @"中部", @"近畿", @"中国", @"四国", @"九州／沖縄"];
    NSArray *areaPrefectureNames = @[
                                     @[@"北海道", @"青森", @"岩手", @"宮城", @"秋田", @"山形", @"福島"],
                                     @[@"茨城", @"栃木", @"群馬", @"埼玉", @"千葉", @"東京", @"神奈川"],
                                     @[@"新潟", @"富山", @"石川", @"福井", @"山梨", @"長野", @"岐阜", @"静岡", @"愛知"],
                                     @[@"三重", @"滋賀", @"京都", @"大阪", @"兵庫", @"奈良", @"和歌山"],
                                     @[@"鳥取", @"島根", @"岡山", @"広島", @"山口"],
                                     @[@"徳島", @"香川", @"愛媛", @"高知"],
                                     @[@"福岡", @"佐賀", @"長崎", @"熊本", @"大分", @"宮崎", @"鹿児島", @"沖縄"]
                                     ];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.areaNames.count; ++i) {
        NSArray *ps = areaPrefectureNames[i];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *prefectureName in ps) {
            PrefectureCellData *pcd = [[PrefectureCellData alloc] initWithPrefectureString:prefectureName];
            [arr addObject:pcd];
        }
        [tmp addObject:arr];
    }
    self.areaPrefectures = [NSArray arrayWithArray:tmp];
}

- (void)initUI {
    self.view.backgroundColor = BACKGROUND_COLOR;

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.backgroundColor = CLEAR_COLOR;
    titleLabel.textColor = DEFAULT_TEXT_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = DEFAULT_FONT(16);
    titleLabel.text = @"会場";
    self.navigationItem.titleView = titleLabel;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Common screenSize].width, [Common screenSize].height - GAD_SIZE_320x50.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:self.tableView];
    
    //広告
    _banner = [[GADBannerView alloc]initWithFrame:CGRectMake(0, [Common screenSize].height - GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    _banner.adUnitID = MY_BANNER_UNIT_ID2;
    _banner.rootViewController = self;
    _banner.backgroundColor = [UIColor clearColor];
    _banner.center = CGPointMake([Common screenSize].width/2, _banner.center.y);
    [self.view addSubview:_banner];
    [_banner loadRequest:[GADRequest request]];
    
    // navigation bar button item
    UIBarButtonItem* clearButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"クリア"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(didClearButtonPushed)];
    self.navigationItem.rightBarButtonItem = clearButton;
}

- (void)setUI {
    [self.tableView reloadData];
}

- (void)didClearButtonPushed {
    FilteringManager *mgr = [FilteringManager sharedManager];
    if (mgr.filteredPrefectures.count == 0) {
        return;
    }
    [mgr clearPrefecture];
    for (NSArray *arr in self.areaPrefectures) {
        for (PrefectureCellData *data in arr) {
            data.checked = NO;
        }
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PrefectureCellData *data = self.areaPrefectures[indexPath.section][indexPath.row];
    data.checked = !data.checked;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)self.areaPrefectures[section]).count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [Common screenSize].width, DEFAULT_HEADER_HEIGHT)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
    titleLabel.backgroundColor = CLEAR_COLOR;
    titleLabel.font = DEFAULT_BOLD_FONT(16);
    titleLabel.textColor = DEFAULT_TEXT_COLOR;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = self.areaNames[section];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return DEFAULT_HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PrefectureCellData *data = self.areaPrefectures[indexPath.section][indexPath.row];
    cell.textLabel.text = data.name;
    cell.textLabel.textColor = DEFAULT_TEXT_COLOR;
    if (data.checked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.areaNames.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
