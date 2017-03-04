//
//  MenuViewController.m
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/4.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "MenuViewController.h"
#import "Test1GridViewCell.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_menuView == nil) {
        self.menuView = [[CHGMenuView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 200)];
        [_menuView registerNibName:@"Test1GridViewCell" forCellReuseIdentifier:@"Test1GridViewCell"];
        _menuView.data = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"];
        _menuView.menuViewShowMode = CHGMenuViewShowModeMenu;
        _menuView.menuViewDelegate = self;
        _menuView.menuViewDataSource = self;
        _menuView.isCycleShow = YES;
    }
    return _menuView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}






///返回CHGMenuView中的rows
-(NSInteger)numberOfRowsInCHGMenuView:(id)menuView {
    return 2;
}
///返回CHGMenuView中的columns
-(NSInteger)numberOfColumnsInCHGMenuView:(id)menuView {
    return 4;
}
///返回cell
-(CHGGridViewCell*)cellForCHGMenuView:(id)menuView itemAtIndexPosition:(NSInteger)position withData:(id)data {
    Test1GridViewCell * cell = (Test1GridViewCell*)[((CHGMenuView*)menuView) dequeueReusableCellWithIdentifier:@"Test1GridViewCell" withPosition:position];
    cell.label.text = data;
    return cell;
}

///当item被点击的时候回掉
-(void)menuView:(id)menuView didSelecteAtIndex:(NSInteger)position withData:(id)data {
    
}

@end
