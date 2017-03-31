//
//  WPSelectListView.m
//  GW_GTS2_iOS
//
//  Created by zhaoKiveen on 2016/12/29.
//  Copyright © 2016年 gw. All rights reserved.
//

#import "WPSelectListView.h"

#define  tbViewCellHight  GTSize(@"height_i")

@interface WPSelectListView ()

//被选中显示的btn标题
@property (nonatomic, retain) GTLabel *lbSelTitle;
@property (nonatomic, retain) GTButton *btnSel;

@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, retain) UIColor *normalBgColor;
@property (nonatomic, retain) UIColor *selectBgColr;

//上一层父View
@property (nonatomic, assign) GTView *supView;
//底层view让下拉消失
@property (nonatomic, retain) GTButton *btnDoMiss;
//下拉列表
@property (nonatomic, retain) GTTableView *tbView;

@end


@implementation WPSelectListView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.theme = [GTConfigManager shareInstance].curTheme;
    
}

- (instancetype)initWithArrTitles:(NSArray *)arrTitles andSuperView:(GTView*)supView andSelBlock:(changeSelBlock)selBlock{
    self = [super init];
    if (self) {
        _arrTitles = [arrTitles copy];
        _supView = supView;
        _selBlock = selBlock;
    }
    return self;
}


- (void)setView:(UIFont *)textFont fontColor:(UIColor *)fontColor bgColor:(UIColor *)normalColor andSelColor:(UIColor *)selColor{
    _font = textFont;
    _fontColor = fontColor;
    _normalBgColor = normalColor;
    _selectBgColr = selColor;
    _selIndex = 0;
    
    WS(weakSelf)
    
    _btnSel = [GTButton new];
    [self addSubview:_btnSel];
    [_btnSel setBgColor:_normalBgColor andSelected:_selectBgColr];
    [_btnSel.layer setMasksToBounds:YES];
    [_btnSel.layer setCornerRadius:6.0];
    [_btnSel addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(0);
        make.top.equalTo(weakSelf).with.offset(0);
        make.width.mas_equalTo(@(GTSize(@"width_b")));
        make.height.mas_equalTo(@(GTSize(@"height_i")));
    }];
    
    _lbSelTitle = [GTLabel new];
    [_btnSel addSubview:_lbSelTitle];
    _lbSelTitle.textAlignment = NSTextAlignmentCenter;
    _lbSelTitle.textColor = _fontColor;
    _lbSelTitle.text = _arrTitles[0];
    [_lbSelTitle setFont:_font];
    [_lbSelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_btnSel).with.offset(GTSize(@"space_a"));
        make.top.mas_equalTo(_btnSel).with.offset(0);
        make.bottom.mas_equalTo(_btnSel).with.offset(0);
        //make.width.mas_equalTo(_lbSelTitle).multipliedBy(0.7);
    }];
    
    UIImageView *imgArrow = [UIImageView new];
    [_btnSel addSubview:imgArrow];
    //变白
    [imgArrow setImage:[GTRImage(@"a_icon_arrowdownb") gt_tintedImageWithColor:[UIColor whiteColor]]];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_lbSelTitle.mas_right).with.offset(0);
        make.right.mas_equalTo(_btnSel.mas_right).with.offset(-GTSize(@"space_a"));
        make.centerY.mas_equalTo(_btnSel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 8));
    }];
    
    _btnDoMiss = [GTButton buttonWithType:UIButtonTypeCustom];
    [_btnDoMiss setFrame:[UIScreen mainScreen].bounds];
    [_btnDoMiss setBackgroundColor:[UIColor clearColor]];
    [_btnDoMiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _btnDoMiss.hidden = YES;
    
    //下拉列表
    _tbView = [GTTableView new];
    _tbView.scrollEnabled = NO;
    _tbView.backgroundColor = _normalBgColor;
    _tbView.separatorColor = [UIColor lightGrayColor];
    [_tbView.layer setMasksToBounds:YES];
    [_tbView.layer setCornerRadius:6.0];
    _tbView.separatorColor = [UIColor whiteColor];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    
    [_btnDoMiss addSubview:_tbView];
    [_supView addSubview: _btnDoMiss];
    
}

//背景透明层点击事件
-(void)dismiss{
    NSLog(@"dismiss-收回下拉框");
    _btnDoMiss.hidden = YES;

}

#pragma mark - btnClicked
- (void)clickShow:(GTButton *)btn{
    [_supView bringSubviewToFront:_btnDoMiss];

    CGRect tbFrame = self.frame;
    tbFrame.origin.y = tbFrame.origin.y + tbFrame.size.height + 5;
    tbFrame.size.height = _arrTitles.count * tbViewCellHight;
    _tbView.frame = tbFrame;
    _btnDoMiss.hidden = !_btnDoMiss.hidden;
    
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _lbSelTitle.text = _arrTitles[indexPath.row];
    _selIndex = indexPath.row;
    _btnDoMiss.hidden = YES;
    _selBlock(_selIndex);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tbViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _arrTitles[indexPath.row];
    cell.textLabel.font = _font;
    cell.backgroundColor = _normalBgColor;

    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.selectedBackgroundView.backgroundColor = _selectBgColr;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tbViewCellHight;
}




@end
