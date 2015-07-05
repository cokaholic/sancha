//
//  EventDetailViewController.m
//  sancha
//
//  Created by Keisuke_Tatsumi on 2015/07/04.
//  Copyright (c) 2015年 Keisuke Tatsumi. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventDetailData.h"
#import "Common.h"
#import "KINWebBrowserViewController.h"
#import <AutoScrollLabel/CBAutoScrollLabel.h>

@interface EventDetailViewController ()
{
    CBAutoScrollLabel *_navBarTitleLabel;
    UIScrollView *_backScrollView;
    UIView *_backWhiteView;
    
    UITextView *_eventTitleTextView;
    UITextView *_performerTextView;
    UITextView *_dateTextView;
    UITextView *_locationTextView;
    UITextView *_howToTextView;
    UITextView *_officialHPTextView;
    
    UILabel *_performerTitleLabel;
    UILabel *_dateTitleLabel;
    UILabel *_locationTitleLabel;
    UILabel *_howToTitleLabel;
    UILabel *_officialHPTitleLabel;
    
    UIImageView *_performerIconImageView;
    UIImageView *_dateIconImageView;
    UIImageView *_locationIconImageView;
    UIImageView *_howToIconImageView;
    UIImageView *_officialHPIconImageView;
}

@property (nonatomic, retain) EventDetailData *eventDetailData;
@property (nonatomic, retain) GADBannerView *banner;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self setUI];
}

- (void)initData
{
    _eventDetailData = [[EventDetailData alloc]initWithURL:_detailURL];
}

- (void)initUI
{
    _navBarTitleLabel = [[CBAutoScrollLabel alloc]initWithFrame:CGRectMake(0, 0, [Common screenSize].width-80, 44)];
    _navBarTitleLabel.textColor = DEFAULT_TEXT_COLOR;
    _navBarTitleLabel.font = DEFAULT_FONT(16);
    _navBarTitleLabel.scrollSpeed = 35;
    _navBarTitleLabel.labelSpacing = 30;
    _navBarTitleLabel.pauseInterval = 2.0;
    _navBarTitleLabel.scrollDirection = CBAutoScrollDirectionLeft;
    self.navigationItem.titleView = _navBarTitleLabel;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, [Common screenSize].width, [Common screenSize].height - NAVBAR_HEIGHT - GAD_SIZE_320x50.height)];
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_backScrollView];
    
    _backWhiteView = [[UIView alloc]initWithFrame:CGRectMake(5, 5 - NAVBAR_HEIGHT, 0, 0)];
    _backWhiteView.backgroundColor = ACCENT_COLOR;
    _backWhiteView.layer.masksToBounds = NO;
    _backWhiteView.layer.cornerRadius = 3.0f;
    _backWhiteView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _backWhiteView.layer.shadowOpacity = 0.1f;
    _backWhiteView.layer.shadowColor = DEFAULT_TEXT_COLOR.CGColor;
    _backWhiteView.layer.shadowRadius = 2.0f;
    
    _eventTitleTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _eventTitleTextView.editable = NO;
    _eventTitleTextView.scrollEnabled = NO;
    _eventTitleTextView.backgroundColor = CLEAR_COLOR;
    _eventTitleTextView.font = DEFAULT_BOLD_FONT(16);
    _eventTitleTextView.textColor = DETAIL_TITLE_COLOR;
    _eventTitleTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    [_backWhiteView addSubview:_eventTitleTextView];
    
    _performerIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    _performerIconImageView.backgroundColor = CLEAR_COLOR;
    _performerIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _performerIconImageView.image = [UIImage imageNamed:@"icon_actor"];
    [_backWhiteView addSubview:_performerIconImageView];
    
    _performerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    _performerTitleLabel.backgroundColor = CLEAR_COLOR;
    _performerTitleLabel.font = DEFAULT_BOLD_FONT(14);
    _performerTitleLabel.textColor = DEFAULT_TEXT_COLOR;
    _performerTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backWhiteView addSubview:_performerTitleLabel];
    
    _performerTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _performerTextView.editable = NO;
    _performerTextView.scrollEnabled = NO;
    _performerTextView.backgroundColor = CLEAR_COLOR;
    _performerTextView.font = DEFAULT_FONT(14);
    _performerTextView.textColor = DEFAULT_TEXT_COLOR;
    _performerTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    [_backWhiteView addSubview:_performerTextView];
    
    [_backScrollView addSubview:_backWhiteView];
    
    _dateIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    _dateIconImageView.backgroundColor = CLEAR_COLOR;
    _dateIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _dateIconImageView.image = [UIImage imageNamed:@"icon_clock"];
    [_backWhiteView addSubview:_dateIconImageView];
    
    _dateTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    _dateTitleLabel.backgroundColor = CLEAR_COLOR;
    _dateTitleLabel.font = DEFAULT_BOLD_FONT(14);
    _dateTitleLabel.textColor = DEFAULT_TEXT_COLOR;
    _dateTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backWhiteView addSubview:_dateTitleLabel];
    
    _dateTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _dateTextView.editable = NO;
    _dateTextView.scrollEnabled = NO;
    _dateTextView.backgroundColor = CLEAR_COLOR;
    _dateTextView.font = DEFAULT_FONT(14);
    _dateTextView.textColor = DEFAULT_TEXT_COLOR;
    _dateTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    [_backWhiteView addSubview:_dateTextView];
    
    _locationIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    _locationIconImageView.backgroundColor = CLEAR_COLOR;
    _locationIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _locationIconImageView.image = [UIImage imageNamed:@"icon_pin"];
    [_backWhiteView addSubview:_locationIconImageView];
    
    _locationTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    _locationTitleLabel.backgroundColor = CLEAR_COLOR;
    _locationTitleLabel.font = DEFAULT_BOLD_FONT(14);
    _locationTitleLabel.textColor = DEFAULT_TEXT_COLOR;
    _locationTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backWhiteView addSubview:_locationTitleLabel];
    
    _locationTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _locationTextView.editable = NO;
    _locationTextView.scrollEnabled = NO;
    _locationTextView.backgroundColor = CLEAR_COLOR;
    _locationTextView.font = DEFAULT_FONT(14);
    _locationTextView.textColor = DEFAULT_TEXT_COLOR;
    _locationTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    [_backWhiteView addSubview:_locationTextView];
    
    _howToIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    _howToIconImageView.backgroundColor = CLEAR_COLOR;
    _howToIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _howToIconImageView.image = [UIImage imageNamed:@"icon_question"];
    [_backWhiteView addSubview:_howToIconImageView];
    
    _howToTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    _howToTitleLabel.backgroundColor = CLEAR_COLOR;
    _howToTitleLabel.font = DEFAULT_BOLD_FONT(14);
    _howToTitleLabel.textColor = DEFAULT_TEXT_COLOR;
    _howToTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backWhiteView addSubview:_howToTitleLabel];
    
    _howToTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _howToTextView.editable = NO;
    _howToTextView.scrollEnabled = NO;
    _howToTextView.backgroundColor = CLEAR_COLOR;
    _howToTextView.font = DEFAULT_FONT(14);
    _howToTextView.textColor = DEFAULT_TEXT_COLOR;
    _howToTextView.dataDetectorTypes = (UIDataDetectorTypePhoneNumber | UIDataDetectorTypeAddress);
    [_backWhiteView addSubview:_howToTextView];
    
    _officialHPIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    _officialHPIconImageView.backgroundColor = CLEAR_COLOR;
    _officialHPIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _officialHPIconImageView.image = [UIImage imageNamed:@"icon_link"];
    [_backWhiteView addSubview:_officialHPIconImageView];
    
    _officialHPTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    _officialHPTitleLabel.backgroundColor = CLEAR_COLOR;
    _officialHPTitleLabel.font = DEFAULT_BOLD_FONT(14);
    _officialHPTitleLabel.textColor = DEFAULT_TEXT_COLOR;
    _officialHPTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backWhiteView addSubview:_officialHPTitleLabel];
    
    _officialHPTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    _officialHPTextView.editable = NO;
    _officialHPTextView.scrollEnabled = NO;
    _officialHPTextView.backgroundColor = CLEAR_COLOR;
    _officialHPTextView.font = DEFAULT_FONT(14);
    _officialHPTextView.textColor = [UIColor blueColor];
    _officialHPTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(openWebView)];
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [_officialHPTextView addGestureRecognizer:tapGestureRecognizer];
    [_backWhiteView addSubview:_officialHPTextView];
    
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
    _navBarTitleLabel.text = _eventDetailData.title;
    _performerTitleLabel.text = @"出演者";
    _dateTitleLabel.text = @"開催日時";
    _locationTitleLabel.text = @"会場";
    _howToTitleLabel.text = @"参加方法";
    _officialHPTitleLabel.text = @"公式HP";
    
    CGSize textViewSize = [Common sizeOfString:_eventDetailData.title inFont:DEFAULT_BOLD_FONT(16) maxWidth:[Common screenSize].width - 30];
    _eventTitleTextView.frame = CGRectMake(0, 0, [Common screenSize].width - 10, textViewSize.height + 30);
    _eventTitleTextView.text = _eventDetailData.title;
    
    _performerIconImageView.center = CGPointMake(_performerIconImageView.center.x, _performerIconImageView.center.y + CGRectGetMaxY(_eventTitleTextView.frame));
    _performerTitleLabel.center = CGPointMake(_performerTitleLabel.center.x, _performerTitleLabel.center.y  + CGRectGetMaxY(_eventTitleTextView.frame));
    
    textViewSize = [Common sizeOfString:_eventDetailData.performers inFont:DEFAULT_FONT(16) maxWidth:[Common screenSize].width - 30];
    _performerTextView.frame = CGRectMake(0, CGRectGetMaxY(_performerTitleLabel.frame), [Common screenSize].width - 10, textViewSize.height + 30);
    _performerTextView.text = _eventDetailData.performers;
    
    _dateIconImageView.center = CGPointMake(_dateIconImageView.center.x, _dateIconImageView.center.y + CGRectGetMaxY(_performerTextView.frame));
    _dateTitleLabel.center = CGPointMake(_dateTitleLabel.center.x, _dateTitleLabel.center.y  + CGRectGetMaxY(_performerTextView.frame));
    
    textViewSize = [Common sizeOfString:_eventDetailData.datetime inFont:DEFAULT_FONT(16) maxWidth:[Common screenSize].width - 30];
    _dateTextView.frame = CGRectMake(0, CGRectGetMaxY(_dateTitleLabel.frame), [Common screenSize].width - 10, textViewSize.height + 30);
    _dateTextView.text = _eventDetailData.datetime;
    
    _locationIconImageView.center = CGPointMake(_locationIconImageView.center.x, _locationIconImageView.center.y + CGRectGetMaxY(_dateTextView.frame));
    _locationTitleLabel.center = CGPointMake(_locationTitleLabel.center.x, _locationTitleLabel.center.y  + CGRectGetMaxY(_dateTextView.frame));
    
    textViewSize = [Common sizeOfString:_eventDetailData.location inFont:DEFAULT_FONT(16) maxWidth:[Common screenSize].width - 30];
    _locationTextView.frame = CGRectMake(0, CGRectGetMaxY(_locationTitleLabel.frame), [Common screenSize].width - 10, textViewSize.height + 30);
    _locationTextView.text = _eventDetailData.location;
    
    _howToIconImageView.center = CGPointMake(_howToIconImageView.center.x, _howToIconImageView.center.y + CGRectGetMaxY(_locationTextView.frame));
    _howToTitleLabel.center = CGPointMake(_howToTitleLabel.center.x, _howToTitleLabel.center.y  + CGRectGetMaxY(_locationTextView.frame));
    
    textViewSize = [Common sizeOfString:_eventDetailData.howTo inFont:DEFAULT_FONT(16) maxWidth:[Common screenSize].width - 30];
    
    _howToTextView.frame = CGRectMake(0, CGRectGetMaxY(_howToTitleLabel.frame), [Common screenSize].width - 10, textViewSize.height);
    if (textViewSize.height<150) {
        _howToTextView.frame = CGRectMake(0, CGRectGetMaxY(_howToTitleLabel.frame), [Common screenSize].width - 10, textViewSize.height + 30);
    }
    _howToTextView.text = _eventDetailData.howTo;
    
    _officialHPIconImageView.center = CGPointMake(_officialHPIconImageView.center.x, _officialHPIconImageView.center.y + CGRectGetMaxY(_howToTextView.frame));
    _officialHPTitleLabel.center = CGPointMake(_officialHPTitleLabel.center.x, _officialHPTitleLabel.center.y  + CGRectGetMaxY(_howToTextView.frame));
    
    textViewSize = [Common sizeOfString:_eventDetailData.officialPageTitle inFont:DEFAULT_FONT(16) maxWidth:[Common screenSize].width - 30];
    _officialHPTextView.frame = CGRectMake(0, CGRectGetMaxY(_officialHPTitleLabel.frame), [Common screenSize].width - 10, textViewSize.height + 30);
    _officialHPTextView.text = _eventDetailData.officialPageTitle;
    
    _backWhiteView.frame = CGRectMake(5, 5 - NAVBAR_HEIGHT, [Common screenSize].width - 10, CGRectGetMaxY(_officialHPTextView.frame));
    
    _backScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(_backWhiteView.frame) - 53);
}

- (void)openWebView
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    
    KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
    webBrowser.showsPageTitleInNavigationBar = YES;
    webBrowser.showsURLInNavigationBar = YES;
    webBrowser.tintColor = CANCEL_COLOR;
    webBrowser.barTintColor = ACCENT_COLOR;
    webBrowser.progressView.tintColor = MAIN_COLOR;
    [self.navigationController pushViewController:webBrowser animated:YES];
    [webBrowser loadURL:_eventDetailData.officialPageURL];
}

- (void)dealloc
{
    _eventDetailData = nil;
    
    _backScrollView = nil;
    _backWhiteView = nil;
    
    _eventTitleTextView = nil;
    _performerTextView = nil;
    _dateTextView = nil;
    _locationTextView = nil;
    _howToTextView = nil;
    _officialHPTextView = nil;
    
    _performerTitleLabel = nil;
    _dateTitleLabel = nil;
    _locationTitleLabel = nil;
    _howToTitleLabel = nil;
    _officialHPTitleLabel = nil;
    
    _performerIconImageView = nil;
    _dateIconImageView = nil;
    _locationIconImageView = nil;
    _howToIconImageView = nil;
    _officialHPIconImageView = nil;
    
    _banner = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
