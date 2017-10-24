//
//  UIImage+Reshape.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "UIImage+Reshape.h"

@implementation UIImage (Reshape)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0,0, 4, 4);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (BOOL)hasAlpha
{
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    return (alphaInfo == kCGImageAlphaFirst || alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaPremultipliedLast);
}

- (UIImage *)croppedImageWithFrame:(CGRect)frame
{
    UIImage *croppedImage = nil;
    UIGraphicsBeginImageContextWithOptions(frame.size, ![self hasAlpha], self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
        [self drawAtPoint:CGPointZero];
        
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:croppedImage.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}
//要压缩到的宽度
+ (UIImage *)compressImageWithImage:(UIImage *)image compressWidth:(float)compressWidth {
    //压缩图片
    //    1、是 “压” 文件体积变小，但是像素数不变，长宽尺寸不变，那么质量可能下降，
    //    NSData * data = UIImageJPEGRepresentation(image, 0.1);这种压缩
    //    2、是 “缩” 文件的尺寸变小，也就是像素数减少。长宽尺寸变小，文件体积同样会减小。
    CGSize size = image.size;
    float width = size.width;
    float height= size.height; //原大小
    if (width> compressWidth) {
        //等比缩小
        size.width = compressWidth;
        size.height = size.width/width*height;
    }else{
        return image;
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
@end
