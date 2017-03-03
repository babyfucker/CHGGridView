//
//  CHGTabItem.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGTabItem.h"

@implementation CHGTabItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(id)initWithNibName:(NSString*) nibName {
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    id view = [views objectAtIndex:0];
    //    CHGGridViewCell * cell = (CHGGridViewCell*)view;
    return view;
}

///此方法会返回当前tabitem需要的数据   如果子类重写此方法 需调用父类的方法，如果不调用则 data不能正确赋值
-(void)setItemData:(id)data position:(NSInteger)position {
    self.data = data;
}

///当item被点击后此方法会被调用  selected == true 表示被调用,  此方法中写 item被选中后和选择前的变化
-(void)setSelected_:(BOOL)selected {
    
}

///变化率
-(void)onTabScrollRateChange:(CGFloat)rateChange {
    
}

@end
