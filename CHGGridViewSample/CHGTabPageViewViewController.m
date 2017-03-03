//
//  CHGTabPageViewViewController.m
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGTabPageViewViewController.h"
#import "TabItem1.h"
#import "Test1GridViewCell.h"

@interface CHGTabPageViewViewController () {
    CGFloat sliderHeight;
}

@end

@implementation CHGTabPageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = YES;
    [_tabPageView registerNibName:@"Test1GridViewCell" forCellReuseIdentifier:@"Test1GridViewCell"];
    _tabPageView.data = [self simaluData];
    _tabPageView.tabHeight = 45;
    _tabPageView.tabLocation = CHGTabLocationTop;
    _tabPageView.tabItemLayoutMode = CHGTabItemLayoutModeAutoWidth;
    _tabPageView.spacing = 5;
    _tabPageView.sliderLocation = CHGSliderLocationDown;
    _tabPageView.isCycleShow = YES;
    sliderHeight = 1;
}

-(NSArray*)simaluData {
    NSMutableArray * data = [NSMutableArray new];
    [data addObject:@"头条"];
    [data addObject:@"要闻"];
    [data addObject:@"娱乐"];
    [data addObject:@"热点"];
    [data addObject:@"体育"];
    [data addObject:@"上海"];
    [data addObject:@"视频"];
    [data addObject:@"网易号"];
    [data addObject:@"财经"];
    [data addObject:@"轻松一刻"];
    return data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CHGGridViewCell*)cellForTabPage:(id)tabPage itemAtIndexPosition:(NSInteger)position withData:(id)data {
    Test1GridViewCell * cell = (Test1GridViewCell*)[tabPage dequeueReusableCellWithIdentifier:@"Test1GridViewCell" withPosition:position];
    cell.label.text = data;
    return cell;
}

///返回TabItem
-(CHGTabItem*)tab:(id)tab itemAtIndexPosition:(NSInteger)position withData:(id)data {
    TabItem1 * tabItem = [TabItem1 initWithNibName:@"TabItem1"];
//    tabItem.label.text = data;
    [tabItem setItemData:data position:position];
    return tabItem;
}

///滑块的高度
-(CGFloat)tabSliderHeight:(id)tab {
    return sliderHeight;
}

///返回滑块
-(CHGSlider*)tabSlider:(id)tab {
    CHGSlider * slider = [CHGSlider new];
    slider.backgroundColor = [UIColor blueColor];
    return slider;
}

///获取tab的宽度 tabItemLayoutMode == CHGTabItemLayoutMode.AutoWidth 有用
-(CGFloat)tabScrollWidth:(id)tab withPosition:(NSInteger)position withData:(id)data {
    NSString * s = (NSString *) data;
    return s.length * 25;
}



-(IBAction)addItem:(id)sender {
    NSMutableArray * data = [[NSMutableArray alloc] initWithArray:_tabPageView.data];
    [data addObject:[NSString stringWithFormat:@"%li",data.count]];
    _tabPageView.data = data;
    [_tabPageView reloadData];
}

-(IBAction)jianItem:(id)sender {
    NSMutableArray * data = [[NSMutableArray alloc] initWithArray:_tabPageView.data];
    [data removeObjectAtIndex:data.count -1];
    _tabPageView.data = data;
    [_tabPageView reloadData];
}

-(IBAction)recycleItem:(id)sender {
    _tabPageView.isCycleShow = !_tabPageView.isCycleShow;
    [_tabPageView reloadData];
}

-(IBAction)layoutItem:(id)sender {
    _tabPageView.tabItemLayoutMode = _tabPageView.tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth ? CHGTabItemLayoutModeAverageWidth : CHGTabItemLayoutModeAutoWidth;
    [_tabPageView reloadData];
}

-(IBAction)addSpacing:(id)sender {
    _tabPageView.spacing += 1;
    [_tabPageView reloadData];
}

-(IBAction)jianSpacing:(id)sender {
    _tabPageView.spacing -= 1;
    [_tabPageView reloadData];
}

-(IBAction)addSliderHeight:(id)sender {
    sliderHeight += 1;
    [_tabPageView reloadData];
}

-(IBAction)jianSliderHeight:(id)sender {
    sliderHeight -= 1;
    sliderHeight = sliderHeight < 0 ? 0 : sliderHeight;
    [_tabPageView reloadData];
}

@end
