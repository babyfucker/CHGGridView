//
//  CHGGridView.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGGridView.h"
#import "CHGGridViewCell.h"

@implementation CHGGridView {
    ///上次滑动的位置
    CGFloat lastScrollDownX;
    ///是否已经结束减速
    BOOL scrollViewDidEndDecelerating;
    ///手指结束拖动
    BOOL scrollViewDidEndDragging;
    ///滑动方向
    ScrollDirection scrollDirection;
    ///当前是否正在创建Cell
    BOOL isCreateCells;
    
    NSInteger curryCreatedPage;
    
    ///获取整数部分
    CGFloat fz;
    ///获取小数部分
    CGFloat fx;
    ///循环状态是否发生改变,  如果是yes 则说明当前 isCycleShow 的值和上次不一样
    BOOL isCycleShowUpdate;
    ///是否是reload
    BOOL isReload;
    CGFloat minValueTemp;
    
    float pageValueMax;
    ///滑动发生轮回
    BOOL isRebirth;
}

//1
//当viewController 被创建并且被显示在屏幕上的时候会执行此时的newSuperview 不为空，   当ViewController退出的时候此方法也会被执行，但是newSuperview为空
-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        //说明当前页面被退出了
        [self closeTimer];
    } else {
        self.backgroundColor = self.backgroundColor;
    }
    NSLog(@"willMoveToSuperview：%@",newSuperview);
    
}

//2 当ViewController被创建 和 ViewController退出的时候会被执行
-(void)didMoveToSuperview {
    [super didMoveToSuperview];
    NSLog(@"didMoveToSuperview");
}

//3 退出当前ViewController的时候为空，   进入当前ViewController 从其他ViewController中返回的时候 参数不为空。  进入其他ViewController中的时候会被执行3次（第1、第3次参数为空，第2次参赛不为空）
-(void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    NSLog(@"willMoveToWindow:%@",newWindow);
    if (newWindow == nil) {
        //简单处理，暂时关闭   以后需改成恢复运行 以节约内存开销
        [self closeTimer];
    } else {
        [self startTimer];
    }
}

//4  执行了2次  后面又多执行了2次
-(void)willRemoveSubview:(UIView *)subview{
    [super willRemoveSubview:subview];
    NSLog(@"willRemoveSubview");
}

//5 进入 退出 重新出现 都会被执行，   进入其他页面的时候会被执行3次
-(void)didMoveToWindow {
    [super didMoveToWindow];
    NSLog(@"didMoveToWindow");
}

-(void)dealloc {
    NSLog(@"dealloc");
}

-(void)setIsCycleShow:(BOOL)isCycleShow {
    isCycleShowUpdate = _isCycleShow != isCycleShow;
    _isCycleShow = isCycleShow;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initDefaultValues];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValues];
    }
    return self;
}

///初始化默认值
-(void)initDefaultValues {
    curryCreatedPage = -1;
    self.cacheCount = 2;
    self.timeInterval = 1;
    isReload = NO;
    self.isShowPageDivider = NO;
    self.isCycleShow = YES;
    self.isTimerShow = NO;
    self.queue = [NSMutableDictionary new];
    self.identifiersDic = [NSMutableDictionary new];
}

///从后台进入前台可以能被调用， 或者从其他页面返回当前页面也可能被调用
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    minValueTemp = -999;
    pageValueMax = -999;
//    fx = 0;
    NSLog(@"drawRect   subViews:%@",self.subviews);
    self.delegate = self;
    [self initViewFromReload:NO];
    if (_data == nil || _data.count == 0) return;
    [self startTimer];
}



-(void)setCurryPage:(NSInteger)curryPage {
    _curryPage = curryPage;
    NSInteger curryPageRealTemp = _isCycleShow ? _curryPage - 1 : _curryPage;
    self.curryPageReal = curryPageRealTemp < 0 ? 0 : curryPageRealTemp;
}

-(void)reloadData {
    isReload = YES;
    fx = 0;
    minValueTemp = -999;
    pageValueMax = -999;
    [self removeSubviews];
    [self initViewFromReload:YES];
    [self startTimer];
}

-(void)startTimer {
    if (_isTimerShow) {
        if (_timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (_data == nil || _data.count == 0) {
                    [self closeTimer];
                    return;
                }
                NSLog(@"定时器");
                NSInteger curryPageTemp = self.curryPageReal + 1;
                [self scroll2Page:curryPageTemp >= self.pageCount ? 0 : curryPageTemp animated:YES];
            }];
        } else {
            //如果timer不为空
        }
    } else {
        [self closeTimer];
    }
}

-(void)closeTimer {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)suspendedTimer {
    if (_timer != nil) {
        _timer.fireDate = [NSDate distantPast];
    }
}

///初始化view
-(void)initViewFromReload:(BOOL)isFromReload {
    //获取单页中最大列数
    NSInteger maxColumnsOfOnePageTemp = [_gridViewDataSource numberOfColumnsInGridView:self];
    //获取单页中最大行数
    NSInteger maxRowsOfOnePageTemp = [_gridViewDataSource numberOfRowsInGridView:self];
    BOOL reSize = YES;
    if (maxRowsOfOnePageTemp != _maxColumnsOfOnePage || maxRowsOfOnePageTemp != _maxRowsOfOnePage) {
        reSize = NO;
        _maxColumnsOfOnePage = maxColumnsOfOnePageTemp;
        _maxRowsOfOnePage = maxRowsOfOnePageTemp;
        [self removeSubviews];
    }
    //获取cell的高度
    _cellHeight = (self.frame.size.height - _intervalOfCell * (_roundLineShow ? _maxRowsOfOnePage + 1 : _maxRowsOfOnePage - 1)) / _maxRowsOfOnePage;
    //获取cell的宽度
    _cellWidth = (self.frame.size.width - _intervalOfCell * (_roundLineShow ? _maxColumnsOfOnePage + (_isShowPageDivider ? 1 : 0) : _maxColumnsOfOnePage - 1)) / _maxColumnsOfOnePage;
    //获取1页中cell的最大数量(可能)
    _maxCellsOfOnePage = _maxColumnsOfOnePage * _maxRowsOfOnePage;
    //获取最多有几页
    _pageCount = [self calculateMaxPageUseColumns:_maxColumnsOfOnePage andRows:_maxRowsOfOnePage withCellCount:_data.count isContainsCyclePage:_isCycleShow];
    //初始化所有注册的cell
    if (!reSize) {
        [self createAllRegisterCellType];
    }
    
    
    self.contentSize = CGSizeMake(self.frame.size.width * _pageCount, 1);
    if (_data == nil || _data.count == 0) return;
    self.curryPage = [self calculateCurryPageIsFromReload:isFromReload];
    [self createCellsOfPage:_curryPage isResize:reSize];
    
    [self scroll2Page:_curryPageReal animated:NO];
}

-(NSInteger)calculateCurryPageIsFromReload:(BOOL)isFromReload {
    NSInteger page = 0;
    if (isFromReload) {///来自于reload方法触发
        if (isCycleShowUpdate) {///如果循环状态发生变化
            isCycleShowUpdate = NO;
            if (_isCycleShow) {///如果当前状态是循环状态，则说明上次是不循环的，因此当前页应该在之前的页面+1
                page = _curryPage + 1;
            } else {///当前不循环， 说明上次是循环换的，因此当前page应该-1
                page = _curryPage - 1;
                page = page < 0 ? 0 : page;
            }
        } else {
            page = _curryPage;
        }
    }
    return page;
}

///计算指定页面总共有多少cell
-(NSInteger)calculateCountOfCellInPage:(NSInteger)page {
    if (_isCycleShow) {
        if (page == 0) {
            return _data.count - (_pageCount - 3) * _maxCellsOfOnePage;
        } else if(_pageCount - 2 == page){
            return _data.count - (_pageCount - 3) * _maxCellsOfOnePage;
        } else {
            return  _maxCellsOfOnePage > _data.count ? _data.count : _maxCellsOfOnePage;
        }
    }
    return page + 1 < _pageCount ? _maxCellsOfOnePage : _data.count - page * _maxCellsOfOnePage;
}

///创建指定页面的cell
-(void)createCellsOfPage:(NSInteger)page isResize:(BOOL)isResize {
    double s = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceNow];
    NSLog(@"========================================%li",page);
    if (page >= _pageCount || page < 0 || isCreateCells) return;
    NSLog(@"---------------------------------------");
    
    curryCreatedPage = page;
    isCreateCells = YES;
    NSInteger columTemp = -1;
    for (int i=0; i<[self calculateCountOfCellInPage:page]; i++) {
        if (i % _maxColumnsOfOnePage == 0) {
            columTemp += 1;
        }
        [self createViewWithIndex:i withColumn:columTemp inPage:page isResize:isResize];
    }
    isCreateCells = NO;
//    NSLog(@"当前时间：%f",[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceNow] - s);
}

-(NSInteger)calculatePositionWithPage:(NSInteger)page andPosition:(NSInteger)i isCycleShow:(BOOL)isCycleShow{
    NSInteger ii = 0;
    if (isCycleShow) {
        if (page + 1 == _pageCount) {
            ii = i;
        } else if (page == 0) {
            ii = i + _maxCellsOfOnePage * (_pageCount - 3);
        } else {
            ii = i + _maxCellsOfOnePage * page;
        }
    } else {
        if (_isCycleShow) {
            if (page + 2 == _pageCount) {
                ii = i;
            } else if(page + 1 == 0){
                ii = i + (_pageCount - 3) * _maxCellsOfOnePage;
            }else {
                ii = i + _maxCellsOfOnePage * page;
            }
        } else {
            ii = i + _maxCellsOfOnePage * page;
        }
    }
    return ii;
}

///创建cell
-(void)createViewWithIndex:(NSInteger)i withColumn:(NSInteger)column inPage:(NSInteger)page isResize:(BOOL)isResize {
    NSInteger framePosition = [self calculatePositionWithPage:page andPosition:i isCycleShow:_isCycleShow];//创建cell的时候使用正常页面计算，如果是循环展示，获取数据应该取比当前页面小一页的数据
    NSInteger dataPosition = [self calculatePositionWithPage:_isCycleShow ? page - 1 : page andPosition:i isCycleShow:NO];//
//    NSLog(@"framePosition:%li",framePosition);
//    NSLog(@"dataPosition:%li",dataPosition);
    if (_gridViewDataSource == nil) {
        return;
    }
    
    CHGGridViewCell * cell = [_gridViewDataSource cellForGridView:self itemAtIndexPosition:_isCycleShow ? dataPosition:framePosition withData:_data[_isCycleShow ? dataPosition:framePosition]];
    cell.frame = [self calculateFrameWithPosition:framePosition andColumn:column andPage:page];
    cell.tag = _isCycleShow ? dataPosition : framePosition;
    [cell addTarget:self action:@selector(itemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//    if (!isResize || isReload) {
        [self addSubview:cell];
//    }
}

-(void)itemTouchUpInside:(id)sender {
    if (_gridViewDelegate == nil) return;
    CHGGridViewCell * cell = sender;
    //    NSLog(@"tag:%li",cell.tag);
    [_gridViewDelegate gridView:self didSelecteAtPosition:cell.tag withData:_data[cell.tag]];
}

-(CGRect)calculateFrameWithPosition:(NSInteger)position andColumn:(NSInteger)column andPage:(NSInteger)page {
    NSInteger y_ = column % _maxRowsOfOnePage;
    CGFloat y = y_ * _cellHeight + _intervalOfCell * (column == 0 && !_roundLineShow ? 0 : (column +(_roundLineShow ? 1 : 0)));
    
    CGFloat x = (position % _maxColumnsOfOnePage) * _cellWidth + page * self.frame.size.width + _intervalOfCell * (position % _maxColumnsOfOnePage == 0 && !_roundLineShow ? 0 : position % _maxColumnsOfOnePage + (_roundLineShow ? 1 : 0));
    
    return CGRectMake(x, y, _cellWidth, _cellHeight);
}

///创建所有注册的cell的nib
-(void)createAllRegisterCellType {
    NSArray * identifiers = [_identifiersDic allKeys];
    for (int i=0; i<identifiers.count; i++) {
        [self createSomeCellWithNib:[_identifiersDic objectForKey:identifiers[i]] withCellReuseIdentifier:identifiers[i]];
    }
}

///通过nib 和 identifier创建2页数量的cell
-(void)createSomeCellWithNib:(NSString*)nib withCellReuseIdentifier:(NSString*)identifier {
    NSMutableArray * cells = [NSMutableArray new];
    for (int i=0; i<_cacheCount; i++) {
        for (int j=0; j<_maxCellsOfOnePage; j++) {
            [cells addObject:[CHGGridViewCell initWithNibName:nib]];
        }
    }
    [_queue setObject:cells forKey:identifier];
}

///移除所有view
-(void)removeSubviews {
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}

///计算总共有几页
-(NSInteger)calculateMaxPageUseColumns:(NSInteger)columns andRows:(NSInteger)rows withCellCount:(NSInteger)cellCount isContainsCyclePage:(BOOL)isContainsCyclePage {
    NSInteger page = 0;
    if (columns * rows == 0) {
        return 0;
    }
    if (cellCount % (columns * rows) == 0) {
        page = cellCount / (columns * rows);
    } else {
        float temp = cellCount / (columns * rows * 1.0) + 1;//乘1.0 是将结果转位浮点类型
        page = floorf(temp);
    }
    
    if (isContainsCyclePage) {
        page += _isCycleShow ? 2 : 0;//如果需要循环显示则增加2页  分别是首页放在最后一页后面， 最后一页放在首页前面
    }
    
    return page;
}

///滑动到指定页面
-(void)scroll2Page:(NSInteger)page animated:(BOOL)animated {
    CGRect rect = CGRectMake(self.frame.size.width * (_isCycleShow ? page + 1 : page), 0, self.frame.size.width, self.frame.size.height);
    [self scrollRectToVisible:rect animated:animated];
}

///注册cell的nib文件
-(void)registerNibName:(NSString*)nibName forCellReuseIdentifier:(NSString*)identifier {
    [_identifiersDic setObject:nibName forKey:identifier];
}

///通过标识符以及当前position获取cell
-(CHGGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier withPosition:(NSInteger)position {
    NSArray * cells = _queue[identifier];
    NSInteger p = _curryPage % _cacheCount;
    CHGGridViewCell * cell = cells[position % _maxCellsOfOnePage + _maxCellsOfOnePage * p];
    return cell;
}

#pragma -mark  UIScrollViewDelegate method
///手指开始拖动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_gridViewScrollDelegate didScrollInGridView:self];
    scrollViewDidEndDragging = NO;
    scrollViewDidEndDecelerating = NO;
    lastScrollDownX = scrollView.contentOffset.x;
}

///手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_gridViewScrollDelegate gridView:self didEndDraggingWillDecelerate:decelerate];
}

///已经结束减速（停止滑动）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_gridViewScrollDelegate didEndDeceleleratingInGridView:self];
    [self scrollViewDidStop:scrollView];
    //    NSLog(@"当前页：%li",_curryPage);
}

//-(NSArray*)modfIfCarryMax:(CGFloat)f{
//    float f2;
//    CGFloat ff = f == 0 ? 0.00001 : f;
//    CGFloat a = modff(ff, &f2);   ///f为传入参数， f2为整数部分    a为小数部分
//    return @[@(a),@(f2)];
//}

-(CGFloat)judgePageChange:(CGFloat)rate {
    CGFloat minValue = floorf(rate);
    CGFloat maxValue = rate - minValue;
//    NSLog(@"minValue:%f                   minValueTemp:%f",minValue,minValueTemp);
    if (minValue != minValueTemp) {
        minValueTemp = minValue;
        return true;
    } else {
        return false;
    }
}

/////滑动中
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (isReload) {
//        fx = 0;
//        isReload = NO;
//        self.curryPage = lroundf(scrollView.contentOffset.x / self.frame.size.width);
////        self.curryPageReal = _isCycleShow ? _curryPage - 1 : _curryPage;
//        return;
//    };
//
//    BOOL change = [self judgePageChange:scrollView.contentOffset.x / self.frame.size.width];
//    [_gridViewScrollDelegate didScrollInGridView:self];
//    CGFloat currScrollX = scrollView.contentOffset.x;
//    if (currScrollX > lastScrollDownX) {
//        scrollDirection = ScrollDirectionLeft;
//        if (change) {
//            self.curryPage += 1;
//            self.curryPage = _isCycleShow ? _curryPage >= _pageCount ? 2:_curryPage : _curryPage >= _pageCount ? _curryPage -1 : _curryPage;
//            [self createCellsOfPage:_curryPage isResize:NO];
//        }
//
//    } else if(currScrollX < lastScrollDownX){
//        scrollDirection = ScrollDirectionRight;
//        if (change) {
//            self.curryPage -= 1;
//            [self createCellsOfPage:_curryPage isResize:NO];
//        }
//    }
////    lastScrollDownX = currScrollX;
//    self.curryPage = lroundf(scrollView.contentOffset.x / self.frame.size.width);
//    
//    ///循环滚动
//    if (_isCycleShow) {
//        if (_curryPage == 0 && self.contentOffset.x <= 0) {
//            NSLog(@"_curryPage     之前:%li    x:%f",_curryPage,self.contentOffset.x);
//            scrollView.contentOffset = CGPointMake(self.frame.size.width * (_pageCount - 2) + self.contentOffset.x, 0);
//            [self createCellsOfPage:_curryPage isResize:NO];
//            NSLog(@"_curryPage     之后:%li    x:%f",_curryPage,self.contentOffset.x);
//        } else if(_curryPage == _pageCount - 1 && self.contentOffset.x >= self.frame.size.width * (_pageCount - 1)){
//            CGFloat xx = self.contentOffset.x - self.frame.size.width * (_pageCount - 1);
//            scrollView.contentOffset = CGPointMake(self.frame.size.width + xx, 0);
//            [self createCellsOfPage:_curryPage isResize:NO];
//            NSLog(@"+++++++");
//        }
//    }
//    lastScrollDownX = currScrollX;
//    
//}



///滑动中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isReload) {
        fx = 0;
        isReload = NO;
        self.curryPage = lroundf(scrollView.contentOffset.x / self.frame.size.width);
//        pageValueMax = ceilf(scrollView.contentOffset.x/scrollView.frame.size.width);
        lastScrollDownX = scrollView.contentOffset.x;
        return;
    };
    
    [_gridViewScrollDelegate didScrollInGridView:self];
    CGFloat currScrollX = scrollView.contentOffset.x;
    float pageValueMaxTemp = ceilf(scrollView.contentOffset.x/scrollView.frame.size.width);

    if (currScrollX > lastScrollDownX) {
        scrollDirection = ScrollDirectionLeft;
        if (isRebirth) {
            self.curryPage = _pageCount - 2;
            [self createCellsOfPage:_curryPage isResize:NO];
            isRebirth = NO;
        } else {
            if (pageValueMaxTemp != pageValueMax) {
                self.curryPage += 1;
                self.curryPage = _isCycleShow ? _curryPage >= _pageCount ? 2:_curryPage : _curryPage >= _pageCount ? _curryPage -1 : _curryPage;
                [self createCellsOfPage:_curryPage isResize:NO];
            }
        }
    } else if(currScrollX < lastScrollDownX){
        scrollDirection = ScrollDirectionRight;
        if (isRebirth) {
            self.curryPage = 1;
            [self createCellsOfPage:_curryPage isResize:NO];
            isRebirth = NO;
        } else {
            if (pageValueMaxTemp != pageValueMax) {
                self.curryPage -= 1;
                [self createCellsOfPage:_curryPage isResize:NO];
            }
        }
    }
    
    self.curryPage = lroundf(scrollView.contentOffset.x / self.frame.size.width);
    lastScrollDownX = currScrollX;
    pageValueMax = pageValueMaxTemp;
    
    if (_isCycleShow) {
        if (pageValueMax == 0 && self.contentOffset.x <= 0) {
            NSLog(@"pageValueMax     之前:%f    x:%f",pageValueMax,self.contentOffset.x);
            isRebirth = YES;
            scrollView.contentOffset = CGPointMake(self.frame.size.width * (_pageCount - 2) + self.contentOffset.x, 0);
            self.curryPage -= 1;
            [self createCellsOfPage:_curryPage isResize:NO];
            NSLog(@"pageValueMax     之后:%f    x:%f",pageValueMax,self.contentOffset.x);
        } else if(_curryPage == _pageCount - 1 && self.contentOffset.x >= self.frame.size.width * (_pageCount - 1)) {
            isRebirth = YES;
            CGFloat xx = self.contentOffset.x - self.frame.size.width * (_pageCount - 1);
            scrollView.contentOffset = CGPointMake(self.frame.size.width + xx, 0);
            self.curryPage += 1;
            [self createCellsOfPage:_curryPage isResize:NO];
        }
    }
}

///动画滑动结束   self scrollRectToVisible:<#(CGRect)#> animated:<#(BOOL)#>   animated = YES 调用此方法
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [_gridViewScrollDelegate didEndScrollingAnimationInGridView:self];
    [self scrollViewDidStop:scrollView];
    
}

///滑动结束
-(void)scrollViewDidStop:(UIScrollView*)scrollView {
    [_gridViewScrollDelegate didStopInGridView:self];
    scrollViewDidEndDecelerating = YES;
    scrollDirection = ScrollDirectionStop;
}

@end
