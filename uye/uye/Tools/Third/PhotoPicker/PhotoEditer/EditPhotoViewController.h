//
//  EditPhotoViewController.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void(^PhotoEditHandler)(UIImage *shapeImage,NSInteger code);

@interface EditPhotoViewController : UIViewController

@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, assign) CGFloat reshapeScale; //宽高比

- (void)editPhotoFinish:(PhotoEditHandler)complete;
@end
