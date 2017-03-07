//
//  CHGTabPage.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGGridViewCell.h"
#import "CHGGridView.h"
#import "CHGTab.h"

///CHGTab在CHGTabPage中的位置
typedef NS_ENUM(NSUInteger, CHGTabLocation) {
    CHGTabLocationTop,  //设置Tab的位置，CHGTabLocation.Top 表示Tab在整个view的顶部现实
    CHGTabLocationDown  //CHGTabLocation.Down 则在整个view的底部显示
};

///CHGTabPage的DataSource
@protocol CHGTabPageDataSource <NSObject>

///返回TabItem
-(CHGTabItem*)tabPageView:(id)tabPageView itemAtIndexPosition:(NSInteger)position withData:(id)data;
///滑块的高度
-(CGFloat)tabSliderHeight:(id)tabPageView;
///返回滑块
-(CHGSlider*)tabSlider:(id)tabPageView;
///获取tab的宽度 tabItemLayoutMode == CHGTabItemLayoutMode.AutoWidth 有用
-(CGFloat)tabPageScrollWidth:(id)tabPageView withPosition:(NSInteger)position withData:(id)data;
///返回cell
-(CHGGridViewCell*)cellForTabPageView:(id)tabPage itemAtIndexPosition:(NSInteger)position withData:(id)data;
///左边view
-(UIView*)leftViewInTabPageView:(id)tabPage;
///右边view
-(UIView*)rightViewInTabPageView:(id)tabPage;

@end

///CHGTabPageViewDelegate
@protocol CHGTabPageViewDelegate <NSObject>
///当页面选择后回掉
-(void)tabPageView:(id)tabPageView pageDidChangedWithPage:(NSInteger)page withCell:(CHGGridViewCell*)cell;
@end

@interface CHGTabPageView : UIView<CHGGridViewDataSource,CHGTabDelegate,CHGTabDataSource,CHGGridViewScrollDelegate>

@property(nonatomic,strong) CHGGridView * gridView;
@property(nonatomic,strong) CHGTab * tab;
///CHGTab在CHGTabPage中的位置
@property(nonatomic,assign) CHGTabLocation tabLocation;
@property(nonatomic,assign) CGFloat tabHeight;
///按钮之间的间隔
@property(nonatomic,assign) CGFloat spacing;
///cell之间的间隔
@property(nonatomic,assign) CGFloat intervalOfCell;
///隐藏周围的线条
@property(nonatomic,assign) BOOL roundLineShow;
///数据
@property(nonatomic,strong) NSArray * data;
///CHGTabPageDataSource
@property(nonatomic,weak) IBOutlet id<CHGTabPageDataSource> tabPageDataSource;
///CHGTabPageViewDelegate
@property(nonatomic,weak) IBOutlet id<CHGTabPageViewDelegate> tabPageViewDelegate;
///item的宽度模式
@property(nonatomic,assign) CHGTabItemLayoutMode tabItemLayoutMode;
///滑块的位置
@property(nonatomic,assign) CHGSliderLocation sliderLocation;
///是否循环显示
@property(nonatomic,assign) BOOL isCycleShow;
///当前页面的位置
@property(nonatomic,assign,readonly) NSInteger curryPageReal;

-(void)reloadData;

///注册cell的nib文件
-(void)registerNibName:(NSString*)nibName forCellReuseIdentifier:(NSString*)identifier;

///通过标识符以及当前position获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier withPosition:(NSInteger)position;
@end
