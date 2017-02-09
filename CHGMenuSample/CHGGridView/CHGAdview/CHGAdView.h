//
//  CHGAdView.h
//  com.chg.CHGMenu
//
//  Created by hogan on 16/7/5.
//  Copyright © 2016年 hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGMenu.h"
#import "CHGGridView.h"

///广告数据datasource
@protocol AdViewDataSource <NSObject>

///返回view
-(CHGGridViewCell*)adView:(id)adView itemAtIndex:(NSInteger) position withData:(NSDictionary*)data;
///当广告页面被点击返回
-(void)adView:(id)adView didSelectInPosition:(NSInteger)position withData:(NSDictionary*)data;

@end

@interface CHGAdView : UIView<CHGGridViewDatasource,CHGGridViewDelegate,CHGGridViewScrollDelegate>{
    BOOL refresh;
}

@property(nonatomic,strong) CHGMenu * chgMenu;
@property(nonatomic,strong) UIPageControl * pageControl;
@property(nonatomic,strong) NSArray * data;     //数据
@property(nonatomic,assign) BOOL isCycleShow;   //  是否循环显示
@property(nonatomic,assign) BOOL isTimerShow;   //  是否自动切换
@property(nonatomic,assign) BOOL isShowPageControll;   //是否显示pagecontroll
@property (nonatomic, assign) BOOL            isDragging;//是否开始拖动
@property(nonatomic,assign) BOOL islayout;
@property(nonatomic,weak) id<AdViewDataSource>  dataSource;
@property(nonatomic,strong) NSTimer * timer;


-(void)reloadData;

-(void)registerNibName:(NSString*)nib forCellReuseIdentifier:(NSString*)identifier;
///通过标识符获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier  withPosition:(NSInteger)position;

@end
