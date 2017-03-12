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
    ///记录page   当页面滑动完毕才会变化
    float pageValueMax;
    ///记录page   当页面滑动完毕才会变化
    float pageValueMin;
    ///从左往右滑动轮回开始
    BOOL isRebirthLeft2RightStart;
    ///从右往左滑动轮回开始
    BOOL isRebirthRight2LeftStart;
    ///从右往左滑动轮回结束
    BOOL isRebirthLeft2RightEnd;
    ///从左往右滑动轮回结束
    BOOL isRebirthLeft2LeftEnd;
    
    BOOL isLayoutSubView;
    
}

//1
//当viewController 被创建并且被显示在屏幕上的时候会执行此时的newSuperview 不为空，   当ViewController退出的时候此方法也会被执行，但是newSuperview为空
-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        //说明当前页面被退出了
        [self closeTimer];
    } else {
        
    }
    
}

//2 当ViewController被创建 和 ViewController退出的时候会被执行
-(void)didMoveToSuperview {
    [super didMoveToSuperview];
    
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
//        [self reloadData];
    }
}

//4 进入 退出 重新出现 都会被执行，   进入其他页面的时候会被执行3次
-(void)didMoveToWindow {
    [super didMoveToWindow];
    NSLog(@"didMoveToWindow");
    
//    pageValueMax = -999;
//    self.delegate = self;
//    [self initViewFromReload:NO];
//    if (_data == nil || _data.count == 0) return;
//    [self startTimer];
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

-(void)setFrame:(CGRect)frame {
    super.frame = frame;
}

//-(void)drawRect:(CGRect)rect {
//    pageValueMax = -999;
//    self.delegate = self;
//    [self initViewFromReload:NO];
//    if (_data == nil || _data.count == 0) return;
//    [self startTimer];
//}

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

-(void)setCurryPage:(NSInteger)curryPage {
    _curryPage = curryPage;
    NSInteger curryPageRealTemp = _isCycleShow ? _curryPage - 1 : _curryPage;
    self.curryPageReal = curryPageRealTemp < 0 ? 0 : curryPageRealTemp;
}

-(void)layoutSubviews {
    if (!isLayoutSubView) {
        isLayoutSubView = YES;
        pageValueMax = -999;
        self.delegate = self;
        [self initViewFromReload:NO];
        if (_data == nil || _data.count == 0) {
            _cellHeight = 0;
            _cellWidth = 0;
        }
        [self startTimer];
    }
}

-(void)reloadData {
    isReload = YES;
    fx = 0;
    //    minValueTemp = -999;
    pageValueMax = -999;
    [self removeSubviews];
    [self initViewFromReload:YES];
    [self startTimer];
}

///启动定时器
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

///关闭定时器
-(void)closeTimer {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

///暂停定时器
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
    if (maxRowsOfOnePageTemp != _maxRowsOfOnePage || maxRowsOfOnePageTemp != _maxColumnsOfOnePage) {
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
    //    double s = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSinceNow];
    NSLog(@"================请求创建第 %li 页========================",page);
    
    if (page >= _pageCount || page < 0 || isCreateCells) return;
    
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
    NSLog(@"================创建第 %li 页 完成========================",page);
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
    if (_gridViewDataSource == nil) return;
    NSInteger framePosition = [self calculatePositionWithPage:page andPosition:i isCycleShow:_isCycleShow];//创建cell的时候使用正常页面计算，如果是循环展示，获取数据应该取比当前页面小一页的数据
    NSInteger dataPosition = [self calculatePositionWithPage:_isCycleShow ? page - 1 : page andPosition:i isCycleShow:NO];//
    CHGGridViewCell * cell = [_gridViewDataSource cellForGridView:self itemAtIndexPosition:_isCycleShow ? dataPosition:framePosition withData:_data[_isCycleShow ? dataPosition:framePosition]];
    cell.frame = [self calculateFrameWithPosition:framePosition andColumn:column andPage:page];
    cell.tag = _isCycleShow ? dataPosition : framePosition;
    [cell addTarget:self action:@selector(itemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cell];
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
    
    NSInteger p;
//    if (scrollDirection == ScrollDirectionRight) {
//        p =  (_curryPage - 1)  % _cacheCount;
//    } else if(scrollDirection == ScrollDirectionLeft) {
//        p =  (_curryPage + 1)  % _cacheCount;
//    } else {
//        p =  _curryPage  % _cacheCount;
//    }
    p = curryCreatedPage % _cacheCount;
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

///滑动中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_gridViewScrollDelegate didScrollInGridView:self];
    CGFloat currScrollX = scrollView.contentOffset.x;///当前实时坐标
    float pageValueMaxTemp = ceilf(scrollView.contentOffset.x/scrollView.frame.size.width);///向上取整数  比如1.1 1.6   都会取2
    float pageValueMinTemp = floorf(scrollView.contentOffset.x/scrollView.frame.size.width);///向下取整  比如1.1  1.6 都会取1
    self.curryPage = lroundf(scrollView.contentOffset.x / self.frame.size.width);//四舍五入   1.1 取1   1.6 取 2

//    NSLog(@"滑动中：%f",currScrollX);
    
    if (currScrollX > lastScrollDownX) {  ///手指表示从右向左滑动
        scrollDirection = ScrollDirectionLeft;
        if (pageValueMaxTemp > pageValueMax) {
            [self createCellsOfPage:pageValueMaxTemp isResize:NO];
        }
        ///此方向发生轮回则应该创建第一页
        if (isRebirthRight2LeftStart) {
            isRebirthRight2LeftStart = NO;
            [self createCellsOfPage:1 isResize:NO];
        }
        
        if (_isCycleShow) {
            if (self.contentOffset.x >= self.frame.size.width * (_pageCount - 1)) {
                isRebirthRight2LeftStart = YES;
                NSLog(@"移动");
                CGFloat x = self.contentOffset.x - (self.frame.size.width * (_pageCount - 2));
                lastScrollDownX = x - 0.0001;
                scrollView.contentOffset = CGPointMake(x, 0);
                ///当轮回创建玩第一页  此处应该创建第2页
                [self createCellsOfPage:_curryPage + 1 isResize:NO];
                NSLog(@"移动完毕");
            }
        }
        
    } else if(currScrollX < lastScrollDownX){
        scrollDirection = ScrollDirectionRight;
        if (pageValueMinTemp < pageValueMin) {
            [self createCellsOfPage:pageValueMinTemp isResize:NO];
        }
        if (isRebirthLeft2RightStart) {
            isRebirthLeft2RightStart = NO;
            [self createCellsOfPage:_pageCount - 2 isResize:NO];
        }
        if (_isCycleShow) {
            if (self.contentOffset.x < self.frame.size.width) {
                isRebirthLeft2RightStart = YES;
                CGFloat x = self.contentOffset.x + self.frame.size.width * (_pageCount - 2);
                lastScrollDownX = x - 0.0001;
                scrollView.contentOffset = CGPointMake(x, 0);
                [self createCellsOfPage:_curryPage - 1 isResize:NO];
            }
        }
    } else {
        NSLog(@"停止滑动");
        ///发生轮回完毕
    }
    
    lastScrollDownX = currScrollX;
    pageValueMax = pageValueMaxTemp;
    pageValueMin = pageValueMinTemp;
}

///动画滑动结束   self scrollRectToVisible:(CGRect) animated:(BOOL)   animated = YES 调用此方法
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
