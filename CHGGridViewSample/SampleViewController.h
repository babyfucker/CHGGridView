//
//  SampleViewController.h
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/4.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) IBOutlet UITableView *tableView;

@end
