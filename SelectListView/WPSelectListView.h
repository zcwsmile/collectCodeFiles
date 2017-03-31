//
//  WPSelectListView.h
//  GW_GTS2_iOS
//
//  Created by zhaoKiveen on 2016/12/29.
//  Copyright © 2016年 gw. All rights reserved.
//

#import "GTView.h"

typedef void(^changeSelBlock)(NSInteger index);


@interface WPSelectListView : GTView <UITableViewDelegate,UITableViewDataSource>

//点击选中回调
@property (nonatomic, copy) changeSelBlock selBlock;
//列表数组
@property (nonatomic, strong) NSMutableArray *arrTitles;
//当前选中行 默认为0
@property (nonatomic, assign) NSInteger selIndex;
//当前是否显示下拉列表
//@property (nonatomic, assign) BOOL bShow;


- (instancetype)initWithArrTitles:(NSArray *)arrTitles andSuperView:(GTView*)supView andSelBlock:(changeSelBlock)selBlock;

- (void)setView:(UIFont *)textFont fontColor:(UIColor *)fontColor bgColor:(UIColor *)normalColor andSelColor:(UIColor *)selColor;




@end
