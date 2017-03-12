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
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    minValueTemp = 1;
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
//    self.delegate = self;
//    
//    [self removeSubviews];
//    self.slider = [_tabDataSource tabSlider:self];
//    [self addSubview:_slider];
//    [self initViewWithResize:NO];
//}

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
    self.sliderHeight = [_tabDataSource tabSliderHeight:self];
    if (!isResize) {
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
            if (_tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth) {
                self.contentSize = CGSizeMake(self.contentSize.width + _spacing + cell.frame.size.width, 1);
            }
        }
        self.contentSize = CGSizeMake(self.contentSize.width + _spacing, 1);
    }
    if (_tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth) {
        
    } else {
        CGRect item0Frame = [self calculateRectWithPosition:_currySelectedPosition];
        //滑块1
        _slider.frame = CGRectMake(item0Frame.origin.x, _sliderLocation == CHGSliderLocationDown ? self.frame.size.height - _sliderHeight : 0, item0Frame.size.width, _sliderHeight);
        //滑块2
        _sliderC.frame = CGRectMake(-(_slider.frame.size.width + _spacing), _sliderLocation == CHGSliderLocationDown ? self.frame.size.height - _sliderHeight : 0, _slider.frame.size.width, _slider.frame.size.height);
        
        _sliderC.hidden = !_isCycleShow;
        
    }
    _slider.hidden = _tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth;
    _sliderC.hidden = _tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth;
}

-(void)relaodData {
    [self initViewWithResize:NO];
    [self selectItemWithPosition:_currySelectedPosition fromReload:YES];
}

//-(void)layoutSubviews {
//    if (_data != nil) {
//        [self initViewWithResize:YES];
//        [self selectItemWithPosition:_currySelectedPosition fromReload:NO];
//    }
//}

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
        //        [_scrollTabItemRects setValue:rect forKey:[NSString stringWithFormat:@"%li",position]];
    }
    return rect;
}

///设置当前选择的位置
-(void)selectItemWithPosition:(NSInteger)position fromReload:(BOOL)fromReload {
    if (position < 0 || position >= _data.count ||_currySelectedPosition == position) {
        if (fromReload) {
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
        return;
    }
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

//-(CGFloat)modfIfCarryMax:(CGFloat)f{
//    float f1,f2;
//    CGFloat ff = f == 0 ? 0.00001 : f;
//    CGFloat a = modff(f1, &f2);
//    return f1 == 0 ? 1.0 : f2;
//}

///计算滑动的百分比
-(CGFloat)calculatePercent:(CGFloat)ratio scrollDirection:(ScrollDirection)scrollDirection {
    if (scrollDirection == ScrollDirectionLeft) {
        return [self modfIfCarryMax:ratio];
    } else if(scrollDirection == ScrollDirectionRight){
        return (1 - (1 - [self modfIfCarryMax:ratio]) == 1 ? 0 : [self modfIfCarryMax:ratio]);
    }
    return 0;
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


-(CGFloat)modfIfCarryMax:(CGFloat)f{
    float f2;
    CGFloat ff = f == 0 ? 0.00001 : f;
    CGFloat a = modff(ff, &f2);   ///f为传入参数， f2为整数部分    a为小数部分
    NSLog(@"a = %f      f2=%f",a,f2);
    return a == 0 ? 1.0 :f2;
//    return @[@(a),@(f2)];
}

-(CGFloat)getRateWithValue:(CGFloat)rate {
    CGFloat minValue = floorf(rate);
    CGFloat maxValue = rate - minValue;
    
    if (minValueTemp < minValue) {
        maxValue = 1;
    }
    minValueTemp = minValue;
    return maxValue;
}

///滑动中
-(void)didScrollInGridView:(id)gridView {
    CHGGridView * gridView_ = (CHGGridView *)gridView;
    
    CGFloat rateTemp = gridView_.contentOffset.x / gridView_.frame.size.width;
//    CGFloat rate = [self getRateWithValue:rateTemp];
    
    NSInteger curryPage = lroundf(gridView_.contentOffset.x / gridView_.frame.size.width);
    curryPage = gridView_.isCycleShow ? curryPage - 1 : curryPage;
    
    if (_tabItemLayoutMode == CHGTabItemLayoutModeAutoWidth) {
        [self selectItemWithPosition:curryPage fromReload:NO];
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
        
        [self selectItemWithPosition:curryPage fromReload:NO];
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
