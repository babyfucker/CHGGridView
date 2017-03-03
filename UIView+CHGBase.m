//
//  UIView+CHGBase.m
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "UIView+CHGBase.h"

@implementation UIView (CHGBase)

-(UIView*)findViewByTag:(NSInteger)tag withClassType:(Class)classType {
    for (UIView * view in self.subviews) {
        if (view.tag == tag && [view isKindOfClass:classType]) {
            return view;
        }
    }
    return nil;
}

@end
