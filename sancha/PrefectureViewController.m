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

@property (nonatomic, retain) UIButton *doneButton;
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
    [[FilteringManager sharedManager] resetPrefecturesTmp];
}

- (void)initUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Common screenSize].width, [Common screenSize].height - 60 - GAD_SIZE_320x50.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:tableView];
    [tableView reloadData];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(10, [Common screenSize].height - 50 - GAD_SIZE_320x50.height, [Common screenSize].width - 20, 40);
    _doneButton.backgroundColor = MAIN_COLOR;
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = _doneButton.frame.size.height/2;
    [_doneButton setTitle:@"決定" forState:UIControlStateNormal];
    _doneButton.titleLabel.font = DEFAULT_BOLD_FONT(16);
    [_doneButton addTarget:self
                         action:@selector(didSelectFiltering)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_doneButton];
    
    //広告
    _banner = [[GADBannerView alloc]initWithFrame:CGRectMake(0, [Common screenSize].height - GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    _banner.adUnitID = MY_BANNER_UNIT_ID2;
    _banner.rootViewController = self;
    _banner.backgroundColor = [UIColor clearColor];
    _banner.center = CGPointMake([Common screenSize].width/2, _banner.center.y);
    [self.view addSubview:_banner];
    [_banner loadRequest:[GADRequest request]];
}

- (void)setUI {
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PrefectureCellData *data = self.areaPrefectures[indexPath.section][indexPath.row];
    data.checked = !data.checked;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)self.areaPrefectures[section]).count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.areaNames[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PrefectureCellData *data = self.areaPrefectures[indexPath.section][indexPath.row];
    cell.textLabel.text = data.name;
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

#pragma mark - Button Action

- (void)didSelectFiltering
{
    [[FilteringManager sharedManager] savePrefectures];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
