//
//  UIView+CHGBase.h
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CHGBase)

///通过tag 在view中寻找view
-(UIView*)findViewByTag:(NSInteger)tag withClassType:(Class)classType;

@end
