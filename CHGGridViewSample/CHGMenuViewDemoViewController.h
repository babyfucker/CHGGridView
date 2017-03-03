//
//  CHGMenuViewDemoViewController.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGMenuView.h"

@interface CHGMenuViewDemoViewController : UIViewController<CHGMenuViewDelegate,CHGMenuViewDataSource>

@property(nonatomic,weak) IBOutlet CHGMenuView * menuView;

-(IBAction)showPageControl:(id)sender;
-(IBAction)adMode:(id)sender;
-(IBAction)menuMode:(id)sender;
-(IBAction)navicegationMode:(id)sender;

@end
