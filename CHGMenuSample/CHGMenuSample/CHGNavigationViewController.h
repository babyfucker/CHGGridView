//
//  CHGNavigationViewController.h
//  CHGMenuSample
//
//  Created by 陈 海刚 on 16/8/21.
//  Copyright © 2016年 陈 海刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGAdView.h"

@interface CHGNavigationViewController : UIViewController<AdViewDataSource>

@property(nonatomic,strong) CHGAdView * adView;

@end
