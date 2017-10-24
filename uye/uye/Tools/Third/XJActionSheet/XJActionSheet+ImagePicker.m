//
//  XJActionSheet+ImagePicker.m
//  KZW_iPhone2
//
//  Created by 刘向晶 on 15/9/14.
//  Copyright (c) 2015年 张宁浩. All rights reserved.
//

#import "XJActionSheet+ImagePicker.h"
@implementation XJActionSheet (ImagePicker)
- (void)showActionSheetWithImageTips:(NSString *)imageName handle:(ActionSheetHandler)handle {
    
    UIImage * tipsImage = [UIImage imageNamed:imageName];
    UIImageView * imageView =[[UIImageView alloc]initWithImage:tipsImage];
    CGRect screenRect =  [UIScreen mainScreen].bounds;
    imageView.frame = CGRectMake(32, 0, CGRectGetWidth(screenRect)-64,  CGRectGetHeight(screenRect)-bgViewHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [self showActionSheetWithHandle:handle];
}
@end
