//
//  CHGTabPage.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGTabPageView.h"

@implementation CHGTabPageView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView {
    self.gridView = [CHGGridView new];
    [self addSubview:_gridView];
    
    self.tab = [CHGTab new];
    [self addSubview:_tab];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self initView];
//    [_gridView addObserver:_tab forKeyPath:@"curryPage" options:NSKeyValueObservingOptionNew context:NULL];
    _gridView.gridViewScrollDelegate = _tab;
}



-(void)initView{
    _tab.backgroundColor = [UIColor whiteColor];
    _tab.data = _data;
    _tab.tabDataSource = _tabPageDataSource;
    _tab.tabDelegate = self;
    _tab.tabItemLayoutMode = _tabItemLayoutMode;
    _tab.sliderLocation = _sliderLocation;
    _tab.spacing = _spacing;
    _tab.isCycleShow = _isCycleShow;
    _tab.frame = CGRectMake(0, _tabLocation == CHGTabLocationTop ? 0 : self.frame.size.height - _tabHeight, self.frame.size.width, _tabHeight);
    
    _gridView.frame = CGRectMake(0, _tabLocation == CHGTabLocationTop ? _tabHeight : 0, self.frame.size.width, self.frame.size.height - _tabHeight);
    _gridView.data = _data;
    _gridView.intervalOfCell = _intervalOfCell;
    _gridView.roundLineShow = _roundLineShow;
    _gridView.pagingEnabled = YES;
    _gridView.backgroundColor = self.backgroundColor;
    _gridView.gridViewDataSource = self;
    _gridView.isCycleShow = _isCycleShow;
    _gridView.isTimerShow = NO;
    
}


-(void)reloadData {
    [self initView];
    [_gridView reloadData];
    [_tab relaodData];
}

///注册cell的nib文件
-(void)registerNibName:(NSString*)nibName forCellReuseIdentifier:(NSString*)identifier {
    [_gridView registerNibName:nibName forCellReuseIdentifier:identifier];
}

///通过标识符以及当前position获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier withPosition:(NSInteger)position {
    return [_gridView dequeueReusableCellWithIdentifier:identifier withPosition:position];
}

///返回GridView中的rows
-(NSInteger)numberOfRowsInGridView:(id)gridView {
    return 1;
}

///返回GridView中的columns
-(NSInteger)numberOfColumnsInGridView:(id)gridView {
    return 1;
}

///返回cell
-(CHGGridViewCell*)cellForGridView:(id)gridView itemAtIndexPosition:(NSInteger)position withData:(id)data {
    return [_tabPageDataSource cellForTabPage:self itemAtIndexPosition:position withData:data];
}

///item被点击
-(void)tabItemTap:(NSInteger)position {
    [_gridView scroll2Page:position - 1 animated:YES];
}

@end
