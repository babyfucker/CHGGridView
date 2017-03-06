//
//  CHGTabPageViewViewController.h
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGTabPageView.h"

@interface CHGTabPageViewViewController : UIViewController<CHGTabPageDataSource,CHGTabPageViewDelegate>

@property(nonatomic,weak) IBOutlet CHGTabPageView * tabPageView;

-(IBAction)addItem:(id)sender;
-(IBAction)jianItem:(id)sender;
-(IBAction)recycleItem:(id)sender;
-(IBAction)layoutItem:(id)sender;
-(IBAction)addSpacing:(id)sender;
-(IBAction)jianSpacing:(id)sender;
-(IBAction)addSliderHeight:(id)sender;
-(IBAction)jianSliderHeight:(id)sender;

@end
