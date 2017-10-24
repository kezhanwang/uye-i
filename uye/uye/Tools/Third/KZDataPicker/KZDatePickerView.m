//
//  KZDatePickerView.m
//  KZW_iPhone2
//
//  Created by 刘向晶 on 16/3/4.
//  Copyright © 2016年 课栈网. All rights reserved.
//

#import "KZDatePickerView.h"
@interface KZDatePickerView ()
{
    UIView *_pickerViewBgView;
    UIDatePicker * _datePicker;
}
@property(nonatomic,copy)datePickerHanlder pickerHandler;
@end
#import "NSDate+CalendarHandler.h"
#ifndef kScreenWidth
#define kScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])
#endif

#ifndef kScreenHeight
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#endif
CGFloat pickerViewHeight = 256;
CGFloat barViewHeight = 45;
CGFloat btnSpacing = 0;
@implementation KZDatePickerView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView {
    self.frame = [UIScreen mainScreen].bounds;
    //添加时间选择器背景
    _pickerViewBgView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, pickerViewHeight)];
    _pickerViewBgView.backgroundColor =[UIColor whiteColor];
    
    [self addSubview:_pickerViewBgView];
    //添加工具栏
    UIView * barView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, barViewHeight)];
    barView.backgroundColor =[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    [_pickerViewBgView addSubview:barView];
    
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:33.0/255 green:171.0/255 blue:242.0/255 alpha:1] forState:UIControlStateNormal];//R_G_B_A_COLOR(33, 171, 242, 1)
    leftBtn.frame =CGRectMake(btnSpacing, 0,58 , barViewHeight);
    leftBtn.titleLabel.font =[UIFont systemFontOfSize:14.f];
    [leftBtn addTarget:self action:@selector(hiddenDatePickerAnimate) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:leftBtn];
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:10.0/255 green:170.0/255 blue:245.0/255 alpha:1] forState:UIControlStateNormal];//R_G_B_A_COLOR(10.0/255, 170.0/255, 245.0/255, 1)
    rightBtn.frame =CGRectMake(kScreenWidth-58-btnSpacing, 0, 58, barViewHeight);
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:14.f];
    [rightBtn addTarget:self action:@selector(onMakeSureDate) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:rightBtn];
    
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, barViewHeight-0.5, kScreenWidth, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1];//R_G_B_A_COLOR(225, 225, 225, 1);
    [barView addSubview:lineView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 58, kScreenWidth, pickerViewHeight-barViewHeight)];
    
    _datePicker.timeZone = [NSTimeZone localTimeZone];
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    _datePicker.minimumDate = [NSDate date];
    [_pickerViewBgView addSubview:_datePicker];
    
    //去除了分割线
    for (UIView * subView1 in _datePicker.subviews)
    {
        if ([subView1 isKindOfClass:[UIPickerView class]])//取出UIPickerView
        {
            for(UIView *subView2 in subView1.subviews)
            {
                if (subView2.frame.size.height < 1)//取出分割线view
                {
                    subView2.hidden = YES;//隐藏分割线
                }
            }
        }
    }
    
    UITapGestureRecognizer * tapGes =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenDatePickerAnimate)];
    [self addGestureRecognizer:tapGes];
}
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePicker.datePickerMode = datePickerMode;
}
- (void)setMinimumDate:(NSDate *)minimumDate {
    _datePicker.minimumDate = minimumDate;
}
- (void)setMaximumDate:(NSDate *)maximumDate {
    _datePicker.maximumDate = maximumDate;
}
- (void)setBeginDate:(NSDate *)beginDate {
    _beginDate = beginDate;
    [_datePicker setDate:beginDate animated:YES];
}
- (void)showDatePickerComolete:(datePickerHanlder)complete {
    if (complete) {
        self.pickerHandler = complete;
    }
    [self showPickerViewAnimate];
}
- (void)onMakeSureDate {
    if (self.pickerHandler) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger year = [calendar component:NSCalendarUnitYear fromDate:_datePicker.date];
        NSInteger mouth = [calendar component:NSCalendarUnitMonth fromDate:_datePicker.date];
        NSInteger day = [calendar component:NSCalendarUnitDay fromDate:_datePicker.date];
        NSString * dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)mouth,(long)day];
        self.pickerHandler(dateString);
    }
    [self hiddenDatePickerAnimate];
}
- (void)hiddenDatePickerAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        _pickerViewBgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pickerViewHeight);
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self setAlpha:0.0f];
            self.hidden=YES;
            [self removeFromSuperview];
            
        }
    }];
}
- (void)showPickerViewAnimate{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden =NO;
        UIWindow * keyWindow =[UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            _pickerViewBgView.frame = CGRectMake(0, kScreenHeight-pickerViewHeight, kScreenWidth, pickerViewHeight);
            [keyWindow bringSubviewToFront:self];
        }];
    });
}
@end
