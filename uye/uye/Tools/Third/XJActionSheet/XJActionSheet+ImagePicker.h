//
//  XJActionSheet+ImagePicker.h
//  KZW_iPhone2
//
//  Created by 刘向晶 on 15/9/14.
//  Copyright (c) 2015年 张宁浩. All rights reserved.
//

#import "XJActionSheet.h"

@interface XJActionSheet (ImagePicker)
/**
 *  显示出ActionSheet并附带图片（居中显示）提示 取消按钮是-1  其他的按从0 开始排。。
 *
 *  @param imageName 图片的名字
 */
- (void)showActionSheetWithImageTips:(NSString *)imageName handle:(ActionSheetHandler)handle;
@end
