//
//  KZDataPicker.h
//  KZW_iPhone2
//
//  Created by 刘向晶 on 15/7/24.
//  Copyright (c) 2015年 张宁浩. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DataPickerBlock)(NSString *selectStr,BOOL isFinal);

typedef void(^DataPickerBlockIndex)(NSString *selectStr,NSInteger index,BOOL isFinal);

@interface KZDataPicker : UIView

@property (nonatomic, assign) NSUInteger selectIndex;
/**
 *  实例化一个picker
 *
 *  @param isMutable 是否是多列显示（由于时间原因，没写）
 *  @param dataArray 数据源
 *
 *  @return picker
 */
-(instancetype)initWithMutableComponent:(BOOL)isMutable dataArray:(NSArray *)dataArray;
/**
 *  显示picker
 *
 *  @param complete 回调信息
 */
-(void)showSinglePickerWithPickerSelect:(DataPickerBlock)complete;

-(void)showSinglePickerWithPickerSelectTitleAndIndex:(DataPickerBlockIndex)complete;

@end
