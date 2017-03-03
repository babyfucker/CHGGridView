//
//  TabItem1.m
//  CHGGridViewSample
//
//  Created by 陈 海刚 on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "TabItem1.h"

@implementation TabItem1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setSelected_:(BOOL)selected {
    _label.textColor = selected ? [UIColor redColor] :[UIColor blackColor];
}

-(void)setItemData:(id)data position:(NSInteger)position{
    [super setItemData:data position:position];
    _label.text = data;
}

@end
