//
//  SampleViewController.m
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/4.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "SampleViewController.h"
#import "CHGGridViewBaseDemoViewController.h"
#import "CHGTabPageViewViewController.h"
#import "CHGMenuViewDemoViewController.h"

@interface SampleViewController ()

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [UITableViewCell new];
    
    cell.textLabel.text = @[@"CHGGridView基础控件展示",@"CHGTabPageView控件展示",@"菜单、广告、首页导航展示"][indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController * controller = nil;
    if (indexPath.row == 0) {
        controller = [[CHGGridViewBaseDemoViewController alloc] initWithNibName:@"CHGGridViewBaseDemoViewController" bundle:nil];
    } else if(indexPath.row == 1){
        controller = [[CHGTabPageViewViewController alloc] initWithNibName:@"CHGTabPageViewViewController" bundle:nil];
    } else {
        controller = [[CHGMenuViewDemoViewController alloc] initWithNibName:@"CHGMenuViewDemoViewController" bundle:nil];
    }
    controller.title = @[@"CHGGridView基础控件展示",@"CHGTabPageView控件展示",@"菜单、广告、首页导航展示"][indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
