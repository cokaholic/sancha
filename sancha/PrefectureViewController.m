//
//  PrefectureViewController.m
//  sancha
//
//  Created by tamura on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//


#import "PrefectureViewController.h"
#import <RATreeView.h>
#import "Common.h"
#import "PrefectureCellData.h"

@interface PrefectureViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *areaNames;
@property (nonatomic, retain) NSArray *areaPrefectures;

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
                                     @[@"北海道", @"青森県", @"岩手県", @"宮城県", @"秋田県", @"山形県", @"福島県"],
                                     @[@"茨城県", @"栃木県", @"群馬県", @"埼玉県", @"千葉県", @"東京都", @"神奈川県"],
                                     @[@"新潟県", @"富山県", @"石川県", @"福井県", @"山梨県", @"長野県", @"岐阜県", @"静岡県", @"愛知県"],
                                     @[@"三重県", @"滋賀県", @"京都府", @"大阪府", @"兵庫県", @"奈良県", @"和歌山県"],
                                     @[@"鳥取県", @"島根県", @"岡山県", @"広島県", @"山口県"],
                                     @[@"徳島県", @"香川県", @"愛媛県", @"高知県"],
                                     @[@"福岡県", @"佐賀県", @"長崎県", @"熊本県", @"大分県", @"宮崎県", @"鹿児島県", @"沖縄県"]
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:tableView];
    [tableView reloadData];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
