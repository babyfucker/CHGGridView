//
//  CHGGridViewBaseDemoViewController.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGGridViewBaseDemoViewController.h"
#import "Test1GridViewCell.h"
#import "SampleViewController.h"

@interface CHGGridViewBaseDemoViewController () {
    NSInteger columns;
    NSInteger rows;
    NSInteger lineWidth;
    BOOL aroundLine;
}

@end

@implementation CHGGridViewBaseDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = YES;
    columns = 2;
    rows = 2;
    lineWidth = 1;
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_gridView registerNibName:@"Test1GridViewCell" forCellReuseIdentifier:@"Test1GridViewCell"];
    _gridView.data = [self simaluData];//@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
    _gridView.intervalOfCell = lineWidth;
    _gridView.roundLineShow = YES;
    _gridView.isShowPageDivider = YES;
    _gridView.isCycleShow = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///返回GridView中的rows
-(NSInteger)numberOfRowsInGridView:(id)gridView {
    return rows;
}

///返回GridView中的columns
-(NSInteger)numberOfColumnsInGridView:(id)gridView {
    return columns;
}

///返回cell
-(CHGGridViewCell*)cellForGridView:(id)gridView itemAtIndexPosition:(NSInteger)position withData:(id)data {
    Test1GridViewCell * cell = (Test1GridViewCell*)[gridView dequeueReusableCellWithIdentifier:@"Test1GridViewCell" withPosition:position];
    cell.label.text = data;
    cell.backgroundColor = position % 2 == 0 ? [UIColor greenColor]:[UIColor redColor];
    return cell;
}


///gridView item被点击
-(void)gridView:(id)gridView didSelecteAtPosition:(NSInteger)position withData:(id)data {
    SampleViewController * vc = [[SampleViewController alloc] initWithNibName:@"SampleViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


-(NSArray*)simaluData {
    NSMutableArray * data = [NSMutableArray new];
    for (int i=0; i<columns * rows * 4; i++) {
        data[i] = [NSString stringWithFormat:@"%i",i];
    }
//    [data addObject:@"测试"];
    return data;
}

///减
-(IBAction)jian:(id)sender {
    columns -= 1;
    rows -= 1;
    columns = columns <= 0 ? 1:columns;
    rows = rows <= 0 ? 1:rows;
    _gridView.data = [self simaluData];
    [_gridView reloadData];
}

///加
-(IBAction)jia:(id)sender {
    columns += 1;
    rows += 1;
    _gridView.data = [self simaluData];
    [_gridView reloadData];
}

///下一页
-(IBAction)nextPage:(id)sender {
    [_gridView scroll2Page:_gridView.curryPage + 1 animated:YES];
}

///上一页
-(IBAction)previousPage:(id)sender {
    [_gridView scroll2Page:_gridView.curryPage - 1 animated:YES];
}

//显示／关闭周围线条
-(IBAction)aroundLine:(id)sender {
    aroundLine = !aroundLine;
    _gridView.roundLineShow = aroundLine;
    [_gridView reloadData];
}

///减少线条的粗细
-(IBAction)lineJian:(id)sender {
    lineWidth -= 1;
    if (lineWidth < 0) {
        lineWidth = 0;
    }
    _gridView.intervalOfCell = lineWidth;
    [_gridView reloadData];
}

///减少线条的粗细
-(IBAction)lineJia:(id)sender {
    lineWidth += 1;
    _gridView.intervalOfCell = lineWidth;
    [_gridView reloadData];
}

///按页／关闭按页显示
-(IBAction)showWithPage:(id)sender {
    _gridView.pagingEnabled = !_gridView.pagingEnabled;
    [_gridView scroll2Page:_gridView.curryPage animated:YES];
    [_gridView reloadData];
}

///减少线条的粗细
-(IBAction)showPageDiver:(id)sender {
    _gridView.isShowPageDivider = !_gridView.isShowPageDivider;
    [_gridView reloadData];
}

///定时显示 开／关
-(IBAction)timerShow:(id)sender {
    _gridView.isTimerShow = !_gridView.isTimerShow;
    [_gridView reloadData];
}

///循环显示 开／关
-(IBAction)cycleShow:(id)sender {
    _gridView.isCycleShow = !_gridView.isCycleShow;
    [_gridView reloadData];
}

@end
