//
//  MySlider.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/11.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "MySlider.h"

@implementation MySlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)scrollRate:(CGFloat)rate leftItem:(CHGTabItem*)leftItem rightItem:(CHGTabItem*)rightItem {
    _btn.text = [NSString stringWithFormat:@"%.2f",rate];
    NSInteger l = floorl(rate*10);
    _image_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%li",l]];
}

@end
