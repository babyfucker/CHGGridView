//
//  CHGSlider.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGTabItem.h"

@interface CHGSlider : UIView


+(id)initWithNibName:(NSString*) nibName;

-(void)scrollRate:(CGFloat)rate leftItem:(CHGTabItem*)leftItem rightItem:(CHGTabItem*)rightItem;

@end
