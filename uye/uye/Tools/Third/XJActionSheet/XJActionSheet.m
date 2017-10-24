//
//  XJActionSheet.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/4.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//



#import "XJActionSheet.h"
@interface XJActionSheet ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat bgViewOrY;//bgView的初始位置
//    CGFloat bgViewHeight;//背景View的高度。
    CGFloat tableViewHeigt;//tableView的高度
    
    UIFont * destructiveBtnFont;
    UIColor * destructiveBtnColor;
    UIFont * otherBtnFont;
    UIColor * otherBtnColor;
    
}
@property(nonatomic,copy)ActionSheetHandler handle;
/**
 *  放otherButton 和destructiveButton 的title （destructiveButton 在第一位）
 */
@property(nonatomic,copy)NSMutableArray * titleArray;
/**
 *  存放按钮和标题的
 */
@property(nonatomic,strong)UITableView * otherTableView;
/**
 *  取消按钮
 */
@property(nonatomic,strong)UIButton * cancelButton;
/**
 *  titleLabel otherTableView的tableViewHeadView
 */
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView * bgView;//白色部分

@property(nonatomic,copy)NSString * title;//title
@end

#define spacing 10

#define heightOfRow 44

#define kScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])

#define bgViewWidth kScreenWidth-20
#define maxTableViewHeght kScreenHeight-spacing * 3 - heightOfRow-20
static BOOL isDestructiveBtn = NO;


static NSString * cellIdentifier =@"UITableViewCell";


@implementation XJActionSheet

@synthesize titleArray =_titleArray,otherTableView =_otherTableView,cancelButton=_cancelButton;
#pragma mark - configureUI

-(instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self =[super init];
    if (self) {
        _titleArray =[NSMutableArray array];
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles)
        {
            [_titleArray addObject: otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id)))
                [_titleArray addObject: eachObject];
            va_end(argumentList);
        }
        
        if (destructiveButtonTitle) {
            isDestructiveBtn = YES;
            destructiveBtnFont =[UIFont systemFontOfSize:15];
            destructiveBtnColor =[UIColor redColor];
            [_titleArray insertObject:destructiveButtonTitle atIndex:0];
        }else{
            isDestructiveBtn = NO;
        }
        otherBtnFont =[UIFont systemFontOfSize:21];
        otherBtnColor =[UIColor colorWithRed:0.0/255 green:165.0/255 blue:240.0/255 alpha:1];
        self.title = title;
        [self calculateBgViewHeightAndOry];
        
        if (title) {
            [[self titleLabel] setText:title];
            [[self otherTableView]setTableHeaderView:[self titleLabel]];
        }
        [self otherTableView];
        
        if (cancelButtonTitle) {
            [[self cancelButton] setTitle:cancelButtonTitle forState:UIControlStateNormal];
        }
        self.frame = CGRectMake(0,0, kScreenWidth, kScreenHeight);
        self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4f];
    }
    return self;
}
#pragma mark - get方法
- (UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgViewWidth, heightOfRow)];
        _titleLabel.adjustsFontSizeToFitWidth =YES;
        _titleLabel.font =[UIFont systemFontOfSize:13];
        _titleLabel.backgroundColor=[UIColor whiteColor];
        _titleLabel.textColor =[UIColor colorWithRed:160.0/255 green:160.0/255 blue:160.0/255 alpha:1];
        _titleLabel.textAlignment =NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame =CGRectMake(spacing, tableViewHeigt+spacing, bgViewWidth, heightOfRow);
        _cancelButton.layer.cornerRadius = 2;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.titleLabel.font = otherBtnFont;
        _cancelButton.backgroundColor =[UIColor whiteColor];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0.0/255 green:165.0/255 blue:240.0/255 alpha:1] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [[self bgView] addSubview:_cancelButton];
    }
    return _cancelButton;
}
-(UITableView *)otherTableView{
    if (!_otherTableView) {
        _otherTableView =[[UITableView alloc]initWithFrame:CGRectMake(spacing,0, bgViewWidth, tableViewHeigt) style:UITableViewStyleGrouped];
        _otherTableView.delegate=self;
        _otherTableView.dataSource=self;
        _otherTableView.layer.cornerRadius = 2;
        _otherTableView.estimatedRowHeight = heightOfRow;
        _otherTableView.estimatedSectionFooterHeight = 0;
        _otherTableView.estimatedSectionHeaderHeight = 0;
        _otherTableView.layer.masksToBounds = YES;
        _otherTableView.bounces = NO;
        if ([_otherTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_otherTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_otherTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_otherTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        _otherTableView.rowHeight = heightOfRow;
        _otherTableView.tableFooterView =[UIView new];
        [[self bgView] addSubview:_otherTableView];
    }
    return _otherTableView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight,bgViewWidth, bgViewHeight)];
//        _bgView.backgroundColor =[UIColor clearColor];
        _bgView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.3f];// R_G_B_A_COLOR(0, 0, 0, .4);
        [self addSubview:_bgView];
        
        UIView * otherView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-bgViewHeight)];
//        otherView.backgroundColor =[UIColor clearColor];
        otherView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        [self addSubview:otherView];
        UITapGestureRecognizer * tapges =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissActionSheet)];
        [otherView addGestureRecognizer:tapges];
    }
    return _bgView;
}
-(void)configureActionTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor{
    [[self titleLabel] setFont:titleFont];
    [[self titleLabel] setTextColor:titleColor];
}
- (void)configureCancelButtonTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor{
    [[self cancelButton].titleLabel setFont:titleFont];
    [[self cancelButton] setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)configureDestructiveButtonTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor{
    destructiveBtnColor =titleColor;
    destructiveBtnFont =titleFont;
}
- (void)configureOtherButtonTitleWithFont:(UIFont *)titleFont textColor:(UIColor *)titleColor{
    otherBtnColor =titleColor;
    otherBtnFont =titleFont;
}

#pragma mark - UITableViewDelegate及DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.adjustsFontSizeToFitWidth =YES;
        cell.textLabel.textAlignment =NSTextAlignmentCenter;
        UIView * bgView =[[UIView alloc]initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1];
        cell.selectedBackgroundView =bgView;
    }
    if (indexPath.row == 0 && isDestructiveBtn) {
        cell.textLabel.textColor = destructiveBtnColor;
        cell.textLabel.font = destructiveBtnFont;
    }else{
        cell.textLabel.textColor = otherBtnColor;
        cell.textLabel.font = otherBtnFont;
    }
    cell.textLabel.text =(NSString *)[_titleArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.handle) {
        self.handle(indexPath.row);
    }
    [self dismissActionSheet];
}
#pragma mark - 显示ActionSheet
- (void)showActionSheetWithHandle:(ActionSheetHandler)handle{
    self.handle =handle;
    [self showActionSheet];
}

#pragma mark 显示动画
-(void)showActionSheet{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.alpha = 0;
        UIWindow * keyWindow =[UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            [self bgView].frame = CGRectMake(0,bgViewOrY, kScreenWidth, bgViewHeight);
        }];
    });
}
#pragma mark 取消按钮点击
- (void)cancelButtonAction{
    if (self.handle) {
        self.handle(-1);
    }
    [self dismissActionSheet];
}
#pragma mark 消失动画
- (void)dismissActionSheet{
    [UIView animateWithDuration:0.2 animations:^{
          [self bgView].frame = CGRectMake(0, kScreenHeight, kScreenWidth, bgViewHeight);
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self setAlpha:0.0f];
            self.hidden=YES;
            [self removeFromSuperview];
            
        }
    }];
}
#pragma mark - calculate 计算 tableView的高度 和bgView的高度
-(void)calculateBgViewHeightAndOry{
    
    tableViewHeigt = [_titleArray count] *heightOfRow;
    if (self.title) {
        tableViewHeigt += heightOfRow;
    }
    if (tableViewHeigt > maxTableViewHeght ) {
        tableViewHeigt = maxTableViewHeght;
    }
    
    bgViewOrY = kScreenHeight -tableViewHeigt-heightOfRow-2*spacing;
    bgViewHeight =tableViewHeigt+heightOfRow+2*spacing;
}
@end
