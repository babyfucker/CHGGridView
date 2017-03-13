//
//  CHGTabPage.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGTabPageView.h"

@implementation CHGTabPageView
{
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

-(void)createView {
    self.gridView = [CHGGridView new];
    [self addSubview:_gridView];
    
    self.tab = [CHGTab new];
    [self addSubview:_tab];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _tab.backgroundColor = self.backgroundColor;
}

-(void)initView{
    UIView * leftView = [_tabPageDataSource leftViewInTabPageView:self];
    UIView * rightView = [_tabPageDataSource rightViewInTabPageView:self];
    _tab.data = _data;
    _tab.tabDataSource = self;
    _tab.tabDelegate = self;
    _tab.tabItemLayoutMode = _tabItemLayoutMode;
    _tab.sliderLocation = _sliderLocation;
    _tab.spacing = _spacing;
    _tab.isCycleShow = _isCycleShow;
    if (leftView != nil) {
        leftView.frame = CGRectMake(0, _tabLocation == CHGTabLocationTop ? 0 : self.frame.size.height - _tabHeight, leftView.frame.size.width, leftView.frame.size.height);
        [self addSubview:leftView];
    }
    if (rightView != nil) {
        rightView.frame = CGRectMake(self.frame.size.width - rightView.frame.size.width, _tabLocation == CHGTabLocationTop ? 0 : self.frame.size.height - _tabHeight, rightView.frame.size.width, rightView.frame.size.height);
        [self addSubview:rightView];
    }
    
    _tab.frame = CGRectMake(leftView.frame.size.width, _tabLocation == CHGTabLocationTop ? 0 : self.frame.size.height - _tabHeight, self.frame.size.width - leftView.frame.size.width - rightView.frame.size.width, _tabHeight);
    
    _gridView.frame = CGRectMake(0, _tabLocation == CHGTabLocationTop ? _tabHeight : 0, self.frame.size.width, self.frame.size.height - _tabHeight);
    _gridView.data = _data;
    _gridView.intervalOfCell = _intervalOfCell;
    _gridView.roundLineShow = _roundLineShow;
    _gridView.pagingEnabled = YES;
    _gridView.backgroundColor = self.backgroundColor;
    _gridView.gridViewDataSource = self;
    _gridView.gridViewScrollDelegate = self;
    _gridView.isCycleShow = _isCycleShow;
    _gridView.isTimerShow = NO;
    
}


-(void)reloadData {
    [self initView];
    [_gridView reloadData];
    [_tab relaodData];
}

-(void)layoutSubviews {
    if (!isLayoutSubView) {
        isLayoutSubView = YES;
        [self initView];
    }
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


#pragma _mark CHGTabPageDataSource method
///返回cell
-(CHGGridViewCell*)cellForGridView:(id)gridView itemAtIndexPosition:(NSInteger)position withData:(id)data {
    return [_tabPageDataSource cellForTabPageView:self itemAtIndexPosition:position withData:data];
}

///返回TabItem
-(CHGTabItem*)tab:(id)tab itemAtIndexPosition:(NSInteger)position withData:(id)data {
    return [_tabPageDataSource tabPageView:self itemAtIndexPosition:position withData:data];
}

///滑块的高度
-(CGFloat)tabSliderHeight:(id)tab {
    return [_tabPageDataSource tabSliderHeight:self];
}

///返回滑块
-(CHGSlider*)tabSlider:(id)tab {
    return [_tabPageDataSource tabSlider:self];
}

///获取tab的宽度 tabItemLayoutMode == CHGTabItemLayoutMode.AutoWidth 有用
-(CGFloat)tabScrollWidth:(id)tab withPosition:(NSInteger)position withData:(id)data {
    return [_tabPageDataSource tabPageScrollWidth:self withPosition:position withData:data];
}

///item被点击
-(void)tabItemTap:(NSInteger)position {
    [_gridView scroll2Page:position - 1 animated:YES];
}


#pragma _mark CHGGridViewScrollDelegate method
///手指开始拖动
-(void)willBeginDraggingInGridView:(id)gridView {
    [_tab willBeginDraggingInGridView:gridView];
}

///手指结束拖动
-(void)gridView:(id)gridView didEndDraggingWillDecelerate:(BOOL)decelerate {
    [_tab gridView:gridView didEndDraggingWillDecelerate:decelerate];
}

///已经结束减速
-(void)didEndDeceleleratingInGridView:(id)gridView {
    [_tab didEndDeceleleratingInGridView:gridView];
}

///滑动中
-(void)didScrollInGridView:(id)gridView {
    [_tab didScrollInGridView:gridView];
}
///滑动动画停止
-(void)didEndScrollingAnimationInGridView:(id)gridView {
    [_tab didEndScrollingAnimationInGridView:gridView];
}

///停止滑动
-(void)didStopInGridView:(id)gridView {
    [_tab didStopInGridView:gridView];
    
    NSInteger page = [gridView curryPageReal];
    [_tabPageViewDelegate tabPageView:self
               pageDidChangedWithPage:page
                             withCell:[_tabPageDataSource cellForTabPageView:self
                                                         itemAtIndexPosition:page
                                                                    withData:[_data objectAtIndex:page]]];
    
}

-(NSInteger)curryPageReal {
    return [_gridView curryPageReal];
}

@end
