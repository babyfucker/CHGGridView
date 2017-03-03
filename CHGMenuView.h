//
//  CHGMenuView.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGGridView.h"
#import "CHGGridViewCell.h"

///CHGMenu显示模式
typedef NS_ENUM(NSUInteger, CHGMenuViewShowMode) {
    CHGMenuViewShowModeMenu,        //菜单模式
    CHGMenuViewShowModeAd,          //广告模式此模式下每一页只有一个item
    CHGMenuViewShowModeNavigation   //应用首次开启时候的引导模式 和广告模式相比不会自动展示下一页
};


///CHGMenuView 的代理方法
@protocol CHGMenuViewDelegate <NSObject>

///当item被点击的时候回掉
-(void)menuView:(id)menuView didSelecteAtIndex:(NSInteger)position withData:(id)data;

@end


///CHGMenuView的dataSource
@protocol CHGMenuViewDataSource <NSObject>
///返回CHGMenuView中的rows
-(NSInteger)numberOfRowsInCHGMenuView:(id)menuView;
///返回CHGMenuView中的columns
-(NSInteger)numberOfColumnsInCHGMenuView:(id)menuView;
///返回cell
-(CHGGridViewCell*)cellForCHGMenuView:(id)menuView itemAtIndexPosition:(NSInteger)position withData:(id)data;

@end


///CHGMenuView 封装的一个菜单类
@interface CHGMenuView : UIView<CHGGridViewDataSource,CHGGridViewDelegate>

@property(nonatomic,strong) CHGGridView * gridView;
///pageControl
@property(nonatomic,strong) UIPageControl * pageControl;
///是否显示pageControl
@property(nonatomic,assign) BOOL isShowPageControl;
///cell之间的间隔
@property(nonatomic,assign) CGFloat intervalOfCell;
///隐藏周围的线条
@property(nonatomic,assign) BOOL roundLineShow;
///gridView的datasource
@property(nonatomic,weak) IBOutlet id<CHGMenuViewDataSource> menuViewDataSource;
///delegate
@property(nonatomic,weak) IBOutlet id<CHGMenuViewDelegate> menuViewDelegate;
///自动展示的时间间隔
@property(nonatomic,assign) NSInteger timeInterval;
///cell的数据
@property(nonatomic,strong) NSArray * data;
///是否循环显示
@property(nonatomic,assign) BOOL isCycleShow;
///pageControl 选择的颜色
@property(nonatomic,strong) UIColor * currentPageIndicatorTintColor;
///pageControl未选择颜色
@property(nonatomic,strong) UIColor * pageIndicatorTintColor;
///显示模式，默认为菜单模式
@property(nonatomic,assign) CHGMenuViewShowMode menuViewShowMode;

///注册cell的nib文件
-(void)registerNibName:(NSString*)nibName forCellReuseIdentifier:(NSString*)identifier;

///通过标识符以及当前position获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier withPosition:(NSInteger)position;

-(void)reloadData;

@end
