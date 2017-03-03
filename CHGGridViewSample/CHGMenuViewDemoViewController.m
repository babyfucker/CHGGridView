//
//  CHGMenuViewDemoViewController.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGMenuViewDemoViewController.h"
#import "Test1GridViewCell.h"

@interface CHGMenuViewDemoViewController ()

@end

@implementation CHGMenuViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = YES;
    [_menuView registerNibName:@"Test1GridViewCell" forCellReuseIdentifier:@"Test1GridViewCell"];
    _menuView.data = [self simaluData];
    _menuView.timeInterval = 1;
    _menuView.intervalOfCell = 2;
    _menuView.roundLineShow = YES;
    
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

-(IBAction)showPageControl:(id)sender {
    _menuView.isShowPageControl = !_menuView.isShowPageControl;
    [_menuView reloadData];
}

-(IBAction)adMode:(id)sender {
    _menuView.menuViewShowMode = CHGMenuViewShowModeAd;
    _menuView.isCycleShow = NO;
    [_menuView reloadData];
}

-(IBAction)menuMode:(id)sender {
    _menuView.menuViewShowMode = CHGMenuViewShowModeMenu;
    _menuView.isCycleShow = YES;
    [_menuView reloadData];
}

-(IBAction)navicegationMode:(id)sender {
    _menuView.menuViewShowMode = CHGMenuViewShowModeNavigation;
    _menuView.isCycleShow = NO;
    [_menuView reloadData];
}


///返回CHGMenuView中的rows
-(NSInteger)numberOfRowsInCHGMenuView:(id)menuView {
    return 2;
}

///返回CHGMenuView中的columns
-(NSInteger)numberOfColumnsInCHGMenuView:(id)menuView {
    return 2;
}

///返回cell
-(CHGGridViewCell*)cellForCHGMenuView:(id)menuView itemAtIndexPosition:(NSInteger)position withData:(id)data {
    Test1GridViewCell * cell = (Test1GridViewCell*)[menuView dequeueReusableCellWithIdentifier:@"Test1GridViewCell" withPosition:position];
    cell.label.text = data;
    cell.backgroundColor = position % 2 == 0 ? [UIColor greenColor]:[UIColor redColor];
    return cell;
}

///当item被点击的时候回掉
-(void)menuView:(id)menuView didSelecteAtIndex:(NSInteger)position withData:(id)data {
    
}

@end
