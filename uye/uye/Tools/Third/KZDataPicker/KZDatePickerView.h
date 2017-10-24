//
//  KZDatePickerView.h
//  KZW_iPhone2
//
//  Created by 刘向晶 on 16/3/4.
//  Copyright © 2016年 课栈网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^datePickerHanlder)(NSString * date);

@interface KZDatePickerView : UIView
@property ( nonatomic, strong) NSDate *minimumDate;
@property ( nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, strong) NSDate * beginDate;;
@property (nonatomic) UIDatePickerMode datePickerMode; 

- (void)showDatePickerComolete:(datePickerHanlder)complete;
@end
