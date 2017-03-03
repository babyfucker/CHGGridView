//
//  CHGGridViewBaseDemoViewController.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGGridView.h"

@interface CHGGridViewBaseDemoViewController : UIViewController<CHGGridViewDataSource,CHGGridViewDelegate>

@property(nonatomic,weak) IBOutlet CHGGridView * gridView;
///减
-(IBAction)jian:(id)sender;
///加
-(IBAction)jia:(id)sender;
///下一页
-(IBAction)nextPage:(id)sender;
///上一页
-(IBAction)previousPage:(id)sender;
//显示／关闭周围线条
-(IBAction)aroundLine:(id)sender;
///减少线条的粗细
-(IBAction)lineJian:(id)sender;
///减少线条的粗细
-(IBAction)lineJia:(id)sender;
///按页／关闭按页显示
-(IBAction)showWithPage:(id)sender;
///减少线条的粗细
-(IBAction)showPageDiver:(id)sender;
///定时显示 开／关
-(IBAction)timerShow:(id)sender;
///循环显示 开／关
-(IBAction)cycleShow:(id)sender;

@end
