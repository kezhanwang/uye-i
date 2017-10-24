//
//  UIImage+Reshape.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Reshape)

/**
 根据颜色生成图片

 @param color 颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 剪裁图片

 @param frame 剪裁的大小
 */
- (UIImage *)croppedImageWithFrame:(CGRect)frame;

/**
 压缩图片

 @param image 要压缩的图
 @param compressWidth 按此最大的宽度等比例变小
 */
+ (UIImage *)compressImageWithImage:(UIImage *)image compressWidth:(float)compressWidth;
@end
