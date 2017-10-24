//
//  KZDataPicker.m
//  KZW_iPhone2
//
//  Created by 刘向晶 on 15/7/24.
//  Copyright (c) 2015年 张宁浩. All rights reserved.
//

#import "KZDataPicker.h"
@interface KZDataPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView * _pickerViewBgView;
    UIPickerView *_pickerView;
    NSArray * _contentArray;
    NSInteger currentRow;
    BOOL _isMutable;
}
@property(nonatomic,copy)DataPickerBlock pickerBlcok;

@property(nonatomic,copy)DataPickerBlockIndex pickerIndexBlcok;

@end
#define datePickerHeight 256
#define barViewHeight 45
#define btnSpacing 0
#ifndef R_G_B_A_COLOR//(r,g,b,a)
#define R_G_B_A_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#endif
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([[UIScreen mainScreen]  bounds].size.width)
#endif
#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif
@implementation KZDataPicker

- (instancetype)initWithMutableComponent:(BOOL)isMutable dataArray:(NSArray *)dataArray
{
    self =[super init];
    if (self) {
        _isMutable =isMutable;
        self.frame =[[UIScreen mainScreen]bounds];
        self.alpha = 0;
//        [self setWindowLevel:UIWindowLevelAlert + 1];//
        _contentArray =[[NSArray alloc]initWithArray:dataArray];
        currentRow = 0;
        self.backgroundColor =[UIColor clearColor];
        [self confitUI];
    }
    return self;
    
}
-(void)confitUI {
    //添加时间选择器背景
    _pickerViewBgView =[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, datePickerHeight)];
    _pickerViewBgView.backgroundColor =[UIColor whiteColor];
    
    [self addSubview:_pickerViewBgView];
    //添加工具栏
    UIView * barView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, barViewHeight)];
    barView.backgroundColor = R_G_B_A_COLOR(240, 240, 240, 1);

    [_pickerViewBgView addSubview:barView];
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:R_G_B_A_COLOR(33, 171, 242, 1) forState:UIControlStateNormal];
    leftBtn.frame =CGRectMake(btnSpacing, 0,58 , barViewHeight);
    leftBtn.titleLabel.font =[UIFont systemFontOfSize:14.f];
    [leftBtn addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:leftBtn];
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:R_G_B_A_COLOR(10, 170, 245, 1) forState:UIControlStateNormal];
    rightBtn.frame =CGRectMake(SCREEN_WIDTH-58-btnSpacing, 0, 58, barViewHeight);
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:14.f];
    [rightBtn addTarget:self action:@selector(onMakeSureDate) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:rightBtn];
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, barViewHeight-0.5, SCREEN_WIDTH, 0.5f)];
    lineView.backgroundColor=R_G_B_A_COLOR(225, 225, 225, 1);
    [barView addSubview:lineView];
    
    _pickerView= [[UIPickerView alloc]initWithFrame:CGRectMake(0.0,barViewHeight,CGRectGetWidth(_pickerViewBgView.bounds),218)];
    _pickerView.delegate=self;
    _pickerView.dataSource =self;
//    _pickerView.backgroundColor=[UIColor redColor];
    [_pickerView  setTintColor:R_G_B_A_COLOR(80, 80, 80, 1)];
    [_pickerViewBgView addSubview:_pickerView];
    


    
    UITapGestureRecognizer * tapGes =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenDatePicker:)];
    [self addGestureRecognizer:tapGes];
    
}

#pragma mark - methods
- (void)setSelectIndex:(NSUInteger)selectIndex {
    _selectIndex = selectIndex;
    if ([_pickerView numberOfRowsInComponent:0] > _selectIndex ) {
        currentRow = _selectIndex;
        [_pickerView selectRow:_selectIndex inComponent:0 animated:NO];
    }
}
#pragma mark 现实pickView并时时返回当前选中的行
-(void)showSinglePickerWithPickerSelect:(DataPickerBlock)complete
{
    self.pickerIndexBlcok = nil;
    self.pickerBlcok = complete;
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        self.alpha = 0;
        self.hidden =NO;
        
        UIWindow * keyWindow =[UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            _pickerViewBgView.frame = CGRectMake(0, SCREEN_HEIGHT-datePickerHeight, SCREEN_WIDTH, datePickerHeight);
        }];
    });
}

-(void)showSinglePickerWithPickerSelectTitleAndIndex:(DataPickerBlockIndex)complete{
    self.pickerBlcok = nil;
    self.pickerIndexBlcok = complete;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        self.alpha = 0;
        self.hidden =NO;
        
        UIWindow * keyWindow =[UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            _pickerViewBgView.frame = CGRectMake(0, SCREEN_HEIGHT-datePickerHeight, SCREEN_WIDTH, datePickerHeight);
        }];
    });
}

#pragma mark 隐藏pickView
-(void)dismissPickerView{
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickerViewBgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, datePickerHeight);
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            
            [self setAlpha:0.0f];
            self.hidden=YES;
            [self removeFromSuperview];
      
        }
    }];
}
-(void)hiddenDatePicker:(UITapGestureRecognizer *)tapGes
{
    if ([tapGes locationInView:self].y<(SCREEN_HEIGHT-datePickerHeight)) {
        [self dismissPickerView];
    }
}
#pragma mark 确定pickerView选择
-(void)onMakeSureDate {
    if ([_contentArray count] > currentRow) {
        NSString * selectStr = [_contentArray objectAtIndex:currentRow];
        if (self.pickerBlcok) {
            self.pickerBlcok(selectStr,YES);
        }else{
            self.pickerIndexBlcok(selectStr,currentRow,YES);
        }
        
    }else{
        if (self.pickerBlcok) {
            self.pickerBlcok(@"",YES);
        }else{
            self.pickerIndexBlcok(@"",0,YES);
        }
        
    }
    [self dismissPickerView];
}

#pragma mark - UIPickerViewDelegate-UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_contentArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    [self clearSpearatorLine];
    return [_contentArray objectAtIndex:row];
}
- (void)clearSpearatorLine {
    [_pickerView.subviews enumerateObjectsUsingBlock:^( UIView * obj, NSUInteger idx, BOOL *stop) {
        if (obj.frame.size.height < 1){
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentRow= row;
    if ([_contentArray count]>row) {
        
        NSString * selectStr =[_contentArray objectAtIndex:row];
        
        if (self.pickerBlcok) {
            self.pickerBlcok(selectStr,NO);
        }else{
            self.pickerIndexBlcok(selectStr,currentRow,NO);
        }
        
    }else{
        if (self.pickerBlcok) {
            self.pickerBlcok(nil,NO);
        }else{
            self.pickerIndexBlcok(nil,0,NO);
        }
    }
}
@end
