//
//  PhotoNavigationController.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPhotoPickerConfig.h"
typedef void(^PhtotControlHandler)(NSArray * photos,KZPhotoPickerError error);

@interface PhotoNavigationController : UINavigationController
@property(nonatomic, copy)PhtotControlHandler photoHandler;
- (instancetype)initWithPickerConfig:(KZPhotoPickerConfig *)photoConfig;
- (void)selectPhotoComplete:(PhtotControlHandler)complete;
@end
