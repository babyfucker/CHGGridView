//
//  CHGSlider.m
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import "CHGSlider.h"

@implementation CHGSlider

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

-(void)scrollRate:(CGFloat)rate leftItem:(CHGTabItem*)leftItem rightItem:(CHGTabItem*)rightItem {
    
}

@end
