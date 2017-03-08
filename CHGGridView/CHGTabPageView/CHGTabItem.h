//
//  CHGTabItem.h
//  CHGGridViewSample
//
//  Created by Hogan on 2017/3/3.
//  Copyright © 2017年 Hogan. All rights reserved.
//

#import <UIKit/UIKit.h>


///此类是TabPage中选项的item类。写此类可以实现不通的风格
@interface CHGTabItem : UIControl


@property(nonatomic,assign) BOOL curryItemSelected;
///cell的数据
@property(nonatomic,strong) id data;

///此方法会返回当前tabitem需要的数据   如果子类重写此方法 需调用父类的方法，如果不调用则 data不能正确赋值
-(void)setItemData:(id)data position:(NSInteger)position;

//-(void)setSelected_:(BOOL)selected;
///当item被点击后此方法会被调用  selected == true 表示被调用,  此方法中写 item被选中后和选择前的变化
-(void)setCurryItemSelected:(BOOL)curryItemSelected;
///变化率
-(void)onTabScrollRateChange:(CGFloat)rateChange;

+(id)initWithNibName:(NSString*) nibName;

@end
