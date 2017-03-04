//
//  MenuViewController.h
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/4.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGMenuView.h"

@interface MenuViewController : UIViewController<CHGMenuViewDelegate,CHGMenuViewDataSource,UITabBarDelegate,UITableViewDataSource>

@property(nonatomic,strong) CHGMenuView * menuView;
@property(nonatomic,weak) IBOutlet UITableView * tableview;

@end
