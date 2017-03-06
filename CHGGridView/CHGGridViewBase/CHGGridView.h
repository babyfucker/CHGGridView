//
//  CHGGridView.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHGGridViewCell;

///GridView的DataSource
@protocol CHGGridViewDataSource <NSObject>

///返回GridView中的rows
-(NSInteger)numberOfRowsInGridView:(id)gridView;
///返回GridView中的columns
-(NSInteger)numberOfColumnsInGridView:(id)gridView;
///返回cell
-(CHGGridViewCell*)cellForGridView:(id)gridView itemAtIndexPosition:(NSInteger)position withData:(id)data;

@end

///GridView的代理
@protocol CHGGridViewDelegate <NSObject>
///gridView item被点击
-(void)gridView:(id)gridView didSelecteAtPosition:(NSInteger)position withData:(id)data;

@end

///CHGGridView滑动delegate
@protocol CHGGridViewScrollDelegate <NSObject>

///手指开始拖动
-(void)willBeginDraggingInGridView:(id)gridView;
///手指结束拖动
-(void)gridView:(id)gridView didEndDraggingWillDecelerate:(BOOL)decelerate;
///已经结束减速
-(void)didEndDeceleleratingInGridView:(id)gridView;
///滑动中
-(void)didScrollInGridView:(id)gridView;
///滑动动画停止
-(void)didEndScrollingAnimationInGridView:(id)gridView;
///停止滑动
-(void)didStopInGridView:(id)gridView;

@end

///滑动方向判断
typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionStop,    ///滑动停止
    ScrollDirectionLeft,    ///向左滑动
    ScrollDirectionRight    ///向右滑动
};

///CHGGridView 主要实现横向的网格试图， 具有定时滚动，循环滚动 动态添加网格数量等功能
@interface CHGGridView : UIScrollView<UIScrollViewDelegate>

///DataSource数据源
@property(nonatomic,weak) IBOutlet id<CHGGridViewDataSource> gridViewDataSource;
///CHGGridView的delegate
@property(nonatomic,weak) IBOutlet id<CHGGridViewDelegate> gridViewDelegate;
///一页最多能显示的cell数量
@property(nonatomic,assign) NSInteger maxCellsOfOnePage;
/// 一页中最多的列数
@property(nonatomic,assign) NSInteger maxColumnsOfOnePage;
/// 一页中最多的行数
@property(nonatomic,assign) NSInteger maxRowsOfOnePage;
///总共页数
@property(nonatomic,assign) NSInteger pageCount;
///cell的高度
@property(nonatomic,assign) CGFloat cellHeight;
///cell的宽度
@property(nonatomic,assign) CGFloat cellWidth;
///cell之间的间隔
@property(nonatomic,assign) CGFloat intervalOfCell;
///隐藏周围的线条
@property(nonatomic,assign) BOOL roundLineShow;
///存放所有cell对象的字典，字典通过identifier获取CHGGridViewCell数组
@property(nonatomic,strong) NSMutableDictionary * queue;
///保存identifier  所有注册的cell 类
@property(nonatomic,strong) NSMutableDictionary * identifiersDic;
///当前显示的页面
@property(nonatomic,assign) NSInteger curryPage;
///当前显示的页面
@property(nonatomic,assign) NSInteger curryPageReal;
///是否显示页面分割线
@property(nonatomic,assign) BOOL isShowPageDivider;
///是否循环显示
@property(nonatomic,assign) BOOL isCycleShow;
///缓存页数
@property(nonatomic,assign) NSInteger cacheCount;
///是否定时滚动显示
@property(nonatomic,assign) BOOL isTimerShow;
///定时间隔
@property(nonatomic,assign) NSInteger timeInterval;
///定时器
@property(nonatomic,strong) NSTimer * timer;
///CHGGridView滑动delegate
@property(nonatomic,weak) id<CHGGridViewScrollDelegate> gridViewScrollDelegate;
///cell的数据
@property(nonatomic,strong) NSArray * data;


///注册cell的nib文件
-(void)registerNibName:(NSString*)nibName forCellReuseIdentifier:(NSString*)identifier;
///通过标识符以及当前position获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier withPosition:(NSInteger)position;

-(void)reloadData;

///滑动到指定页面
-(void)scroll2Page:(NSInteger)page animated:(BOOL)animated;

///计算总共有几页
-(NSInteger)calculateMaxPageUseColumns:(NSInteger)columns andRows:(NSInteger)rows withCellCount:(NSInteger)cellCount isContainsCyclePage:(BOOL)isContainsCyclePage;








@end
