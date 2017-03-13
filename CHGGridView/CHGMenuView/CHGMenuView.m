//
//  CHGMenuView.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGMenuView.h"

@implementation CHGMenuView {
    BOOL isLayoutSubView;
}


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

//- (void)drawRect:(CGRect)rect {
    //    [super drawRect:rect];
//    [self addSubview:_gridView];
//    [self addSubview:_pageControl];
//    [_gridView addObserver:self forKeyPath:@"curryPageReal" options:NSKeyValueObservingOptionNew context:NULL];
//    [self initView];
//}

-(void)dealloc{
    [_gridView removeObserver:self forKeyPath:@"curryPageReal"];
}

-(void)layoutSubviews {
    if (!isLayoutSubView) {
        isLayoutSubView = YES;
        [self addSubview:_gridView];
        [self addSubview:_pageControl];
        [_gridView addObserver:self forKeyPath:@"curryPageReal" options:NSKeyValueObservingOptionNew context:NULL];
        [self initView];
    }
    
}

-(void)initView{
    _pageControl.hidden = !_isShowPageControl;
    _gridView.data = _data;
    _gridView.intervalOfCell = _intervalOfCell;
    _gridView.roundLineShow = _roundLineShow;
    _gridView.pagingEnabled = true;
    _gridView.gridViewDelegate = self;
    _gridView.gridViewDataSource = self;
    _gridView.timeInterval = _timeInterval;
    _gridView.backgroundColor = self.backgroundColor;
    
    _pageControl.currentPage = _gridView.curryPage;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = [self calculateMaxPageUseColumns:[self numberOfColumnsInGridView:self] andRows:[self numberOfRowsInGridView:self] withCellCount:_data.count];
    
    if (_menuViewShowMode == CHGMenuViewShowModeMenu) {
        _gridView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - (_isShowPageControl ? 30 : 0));
        _gridView.isCycleShow = _isCycleShow;
        _gridView.isTimerShow = NO;
        
        _pageControl.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    } else if(_menuViewShowMode == CHGMenuViewShowModeAd){
        _gridView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _gridView.isCycleShow = YES;
        _gridView.isTimerShow = YES;
        
        _pageControl.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    } else if(_menuViewShowMode == CHGMenuViewShowModeNavigation){
        _gridView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _gridView.isCycleShow = NO;
        _gridView.isTimerShow = NO;
        
        _pageControl.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    }
}

-(void)reloadData{
    [self initView];
    [_gridView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"curryPageReal"]) {
        _pageControl.currentPage = _gridView.curryPageReal;
    }
}

///创建view
-(void)createView{
    self.gridView = [CHGGridView new];
    self.pageControl = [UIPageControl new];
}

-(NSInteger)calculateMaxPageUseColumns:(NSInteger)columns andRows:(NSInteger)rows withCellCount:(NSInteger)cellCount {
    return [_gridView calculateMaxPageUseColumns:columns andRows:rows withCellCount:cellCount isContainsCyclePage:NO];
}

///注册cell的nib文件
-(void)registerNibName:(NSString*)nibName forCellReuseIdentifier:(NSString*)identifier {
    [_gridView registerNibName:nibName forCellReuseIdentifier:identifier];
}

///通过标识符以及当前position获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier withPosition:(NSInteger)position {
    return [_gridView dequeueReusableCellWithIdentifier:identifier withPosition:position];
}


#pragma - mark GridViewDataSource method
///返回GridView中的rows
-(NSInteger)numberOfRowsInGridView:(id)gridView {
    return _menuViewShowMode != CHGMenuViewShowModeMenu ? 1 :[_menuViewDataSource numberOfRowsInCHGMenuView:self];
}

///返回GridView中的columns
-(NSInteger)numberOfColumnsInGridView:(id)gridView {
    return _menuViewShowMode != CHGMenuViewShowModeMenu ? 1 :[_menuViewDataSource numberOfColumnsInCHGMenuView:self];
}

///返回cell
-(CHGGridViewCell*)cellForGridView:(id)gridView itemAtIndexPosition:(NSInteger)position withData:(id)data {
    return [_menuViewDataSource cellForCHGMenuView:self itemAtIndexPosition:position withData:data];
}

#pragma - mark GridViewDelegate method
///gridView item被点击
-(void)gridView:(id)gridView didSelecteAtPosition:(NSInteger)position withData:(id)data {
    [_menuViewDelegate menuView:self didSelecteAtIndex:position withData:data];
}

@end
