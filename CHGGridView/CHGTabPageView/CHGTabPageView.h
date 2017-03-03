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
@protocol CHGTabPageDataSource <CHGTabDataSource>

-(CHGGridViewCell*)cellForTabPage:(id)tabPage itemAtIndexPosition:(NSInteger)position withData:(id)data;

@end

@interface CHGTabPageView : UIView<CHGGridViewDataSource,CHGTabDelegate>

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
///item的宽度模式
@property(nonatomic,assign) CHGTabItemLayoutMode tabItemLayoutMode;
///滑块的位置
@property(nonatomic,assign) CHGSliderLocation sliderLocation;
///是否循环显示
@property(nonatomic,assign) BOOL isCycleShow;

-(void)reloadData;

///注册cell的nib文件
-(void)registerNibName:(NSString*)nibName forCellReuseIdentifier:(NSString*)identifier;

///通过标识符以及当前position获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier withPosition:(NSInteger)position;
@end
