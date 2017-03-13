//
//  CHGTab.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGTab.h"
#import "CHGTabItem.h"
#import "UIView+CHGBase.h"

@implementation CHGTab {
    CGFloat nextBtnWidth;
    CGFloat minValueTemp;
    BOOL isLayoutSubView;
    NSMutableArray * itemTemp;
}

-(void)layoutSubviews {
    if (!isLayoutSubView) {
        isLayoutSubView = YES;
        minValueTemp = 1;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
        [self removeSubviews];
        self.slider = [_tabDataSource tabSlider:self];
        self.sliderC = [_tabDataSource tabSlider:self];
        [self addSubview:_slider];
        [self addSubview:_sliderC];
        [self initViewWithResize:NO];
    }
}

-(void)removeSubView{
    for (UIView * v in self.subviews) {
        if ([v isKindOfClass:[CHGTabItem class]]) {
            [v removeFromSuperview];
        }
    }
}

-(void)initViewWithResize:(BOOL)isResize {
    if (_data.count == 0) return;
    self.sliderHeight = [_tabDataSource tabSliderHeight:self];
    if (!isResize) {
        if (itemTemp == nil) {
            itemTemp = [NSMutableArray new];
        } else {
            [itemTemp removeAllObjects];
        }
        [self removeSubView];
        self.contentSize = CGSizeMake(0, 0);
        for (int i=0; i<_data.count; i++) {
            CHGTabItem * cell = [_tabDataSource tab:self itemAtIndexPosition:i withData:_data[i]];
            cell.frame = [self calculateRectWithPosition:i];
            cell.tag = i + 1;
            [cell addTarget:self action:@selector(itemTap:) forControlEvents:UIControlEventTouchUpInside];
            [cell setItemData:_data[i] position:i];
            if (i == _currySelectedPosition) {
                self.currySelectedTabItem = cell;
            }
            [cell setCurryItemSelected:i == _currySelectedPosition];
            [self addSubview:cell];
            [itemTemp addObject:cell];
            if (_tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth) {
                self.contentSize = CGSizeMake(self.contentSize.width + _spacing + cell.frame.size.width, 1);
            }
        }
        self.contentSize = CGSizeMake(self.contentSize.width + _spacing, 1);
    }
    if (_tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth) {
        //滑块1
        CGFloat width = [_tabDataSource tabSliderHeight:self];
        _slider.frame = CGRectMake(0, _sliderLocation == CHGSliderLocationDown ? self.frame.size.height - _sliderHeight : 0, width, _sliderHeight);
    } else {
        //        CGRect item0Frame = [self calculateRectWithPosition:_currySelectedPosition];
        CGRect item0Frame  = [itemTemp[0] frame];
        //滑块1
        _slider.frame = CGRectMake(item0Frame.origin.x, _sliderLocation == CHGSliderLocationDown ? self.frame.size.height - _sliderHeight : 0, item0Frame.size.width, _sliderHeight);
        //滑块2
        _sliderC.frame = CGRectMake(-(_slider.frame.size.width + _spacing), _sliderLocation == CHGSliderLocationDown ? self.frame.size.height - _sliderHeight : 0, _slider.frame.size.width, _slider.frame.size.height);
        
        _sliderC.hidden = !_isCycleShow;
        
    }
    _sliderC.hidden = _tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth;
}

-(void)relaodData {
    [self initViewWithResize:NO];
    [self selectItemWithPosition:_currySelectedPosition fromReload:YES];
}

-(void)itemTap:(id)sender {
    UIView * view = sender;
    [_tabDelegate tabItemTap:view.tag];
}

///计算frame
-(CGRect)calculateRectWithPosition:(NSInteger)position {
    CGRect rect;
    if (_tabItemLayoutMode == CHGTabItemLayoutModeAverageWidth) {
        CGFloat itemWidth = (self.frame.size.width - _spacing * (_data.count + 1)) / _data.count;
        CGFloat x = position * (itemWidth + _spacing) + _spacing;
        rect = CGRectMake(x, _sliderLocation == CHGSliderLocationDown ? 0 : _sliderHeight, itemWidth, self.frame.size.height - _sliderHeight);
    } else {
        CGFloat width = [_tabDataSource tabScrollWidth:self withPosition:position withData:_data[position]];
        rect = CGRectMake(self.contentSize.width + _spacing, _sliderLocation == CHGSliderLocationDown ? 0 : _sliderHeight, width, self.frame.size.height - _sliderHeight);
    }
    return rect;
}

///设置当前选择的位置
-(void)selectItemWithPosition:(NSInteger)position fromReload:(BOOL)fromReload {
    UIView * view1 = [self findViewByTag:position + 1 withClassType:[CHGTabItem class]];
    if (view1 != nil) {
        CHGTabItem * currySelectItem = (CHGTabItem*)view1;
        [currySelectItem setCurryItemSelected:YES];
        [_currySelectedTabItem setCurryItemSelected:NO];
        CGRect rect = CGRectMake(currySelectItem.center.x - self.frame.size.width / 2, 0, self.frame.size.width, self.frame.size.height);
        [self scrollRectToVisible:rect animated:YES];
        _currySelectedTabItem = currySelectItem;
        _currySelectedPosition = position;
    }
}

///手指开始拖动
-(void)willBeginDraggingInGridView:(id)gridView {
    
}

///手指结束拖动
-(void)gridView:(id)gridView didEndDraggingWillDecelerate:(BOOL)decelerate {
    
}

///已经结束减速
-(void)didEndDeceleleratingInGridView:(id)gridView {
    
}

///滑动中
-(void)didScrollInGridView:(id)gridView {
    CHGGridView * gridView_ = (CHGGridView *)gridView;
    CGFloat rateTemp = gridView_.contentOffset.x / gridView_.frame.size.width;
    NSInteger minValue = floorl(rateTemp);
    NSInteger maxValue = ceill(rateTemp);
    NSInteger curryPage = lroundf(rateTemp);
        curryPage = gridView_.isCycleShow ? curryPage - 1 : curryPage;
    [self selectItemWithPosition:curryPage fromReload:NO];
    if (_tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth) {
        if (maxValue > _data.count || minValue <= 0) {
            return;
        }
        CHGTabItem * startView = itemTemp[minValue - 1];
        CHGTabItem * endView = itemTemp[maxValue - 1];
        CGFloat starX = startView.frame.origin.x;
        CGFloat endX = endView.frame.origin.x;
        
        CGFloat x = startView.frame.origin.x + (rateTemp - minValue)*(endX - starX);
        CGFloat w = startView.frame.size.width + (endView.frame.size.width - startView.frame.size.width) * (rateTemp - minValue);
        _slider.frame = CGRectMake(x,
                                   _slider.frame.origin.y,
                                   w,
                                   _sliderHeight);
        [_slider scrollRate:rateTemp - minValue leftItem:startView rightItem:endView];
    } else {
        if (_isCycleShow) {
            NSArray * array = [self calculateSliderRectWithGridView:gridView_];
            _slider.frame = CGRectMake([array[0] floatValue],
                                       _slider.frame.origin.y,
                                       _slider.frame.size.width,
                                       _slider.frame.size.height);
            _sliderC.frame = CGRectMake([array[1] floatValue],
                                        _sliderC.frame.origin.y,
                                        _sliderC.frame.size.width,
                                        _sliderC.frame.size.height);
        } else {
            CGFloat x = (rateTemp) * (_slider.frame.size.width + _spacing) + _spacing;
            _slider.frame = CGRectMake(x,
                                       _slider.frame.origin.y,
                                       _slider.frame.size.width,
                                       _slider.frame.size.height);
        }
        
        if (maxValue > _data.count || minValue <= 0) {
            return;
        }
        CHGTabItem * startView = itemTemp[minValue - 1];
        CHGTabItem * endView = itemTemp[maxValue - 1];
        [_slider scrollRate:rateTemp - minValue leftItem:startView rightItem:endView];
        [_sliderC scrollRate:rateTemp - minValue leftItem:startView rightItem:endView];
    }
    
}

///循环的时候的计算方式   计算 slider的位置
-(NSArray*)calculateSliderRectWithGridView:(CHGGridView*)gridView{
    CGFloat rateTemp = gridView.contentOffset.x / gridView.frame.size.width;
    
    CGFloat x = (rateTemp - 1) * (_slider.frame.size.width + _spacing) + _spacing;
    CGFloat xCopy = 0;
    
    if (gridView.contentOffset.x < gridView.frame.size.width) {
        xCopy = (_slider.frame.size.width + _spacing) * (gridView.pageCount - 2) + x ;
    } else {
        xCopy = - (_slider.frame.size.width + _spacing);
    }
    
    if (gridView.contentOffset.x > gridView.frame.size.width * (gridView.pageCount - 2)) {
        xCopy = x - (gridView.pageCount - 2) * (_slider.frame.size.width + _spacing);
    }
    return @[@(x),@(xCopy)];
}

///滑动动画停止
-(void)didEndScrollingAnimationInGridView:(id)gridView {
    
}

///停止滑动
-(void)didStopInGridView:(id)gridView {
    
}

#pragma - mark UIScrollViewDelegate method
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}








@end
