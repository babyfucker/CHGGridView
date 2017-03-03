//
//  CHGTab.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGTabItem.h"
#import "CHGSlider.h"
#import "CHGGridView.h"

///CHGTabItem item展示方式
typedef NS_ENUM(NSUInteger, CHGTabItemLayoutMode) {
    CHGTabItemLayoutModeAverageWidth,
    CHGTabItemLayoutModeAutoWidth
};

///滑块位置
typedef NS_ENUM(NSUInteger, CHGSliderLocation) {
    CHGSliderLocationTop,
    CHGSliderLocationDown
};

@protocol CHGTabDataSource <NSObject>
///返回TabItem
-(CHGTabItem*)tab:(id)tab itemAtIndexPosition:(NSInteger)position withData:(id)data;
///滑块的高度
-(CGFloat)tabSliderHeight:(id)tab;
///返回滑块
-(CHGSlider*)tabSlider:(id)tab;
///获取tab的宽度 tabItemLayoutMode == CHGTabItemLayoutMode.AutoWidth 有用
-(CGFloat)tabScrollWidth:(id)tab withPosition:(NSInteger)position withData:(id)data;

@end

///CHGTabDelegate
@protocol CHGTabDelegate <NSObject>
///item被点击
-(void)tabItemTap:(NSInteger)position;

@end

@interface CHGTab : UIScrollView<CHGGridViewScrollDelegate,UIScrollViewDelegate>

///tabItem显示方式
@property(nonatomic,assign) CHGTabItemLayoutMode tabItemLayoutMode;
@property(nonatomic,strong) NSArray * data;
///item之间的间隔
@property(nonatomic,assign) CGFloat spacing;
@property(nonatomic,weak) id<CHGTabDataSource> tabDataSource;
///滑块
@property(nonatomic,strong) CHGSlider * slider;
///滑块位置
@property(nonatomic,assign) CHGSliderLocation sliderLocation;
///滑块高度
@property(nonatomic,assign) CGFloat sliderHeight;
///当前选择的TabItem
@property(nonatomic,strong) CHGTabItem * currySelectedTabItem;
///当前选择的tabItem的位置
@property(nonatomic,assign) NSInteger currySelectedPosition;
///item被点击的回掉
@property(nonatomic,weak) id<CHGTabDelegate> tabDelegate;
///可以滑动的TabItem的Rect
@property(nonatomic,strong) NSMutableDictionary * scrollTabItemRects;
///是否循环现实
@property(nonatomic,assign) BOOL isCycleShow;

-(void)relaodData;


@end
