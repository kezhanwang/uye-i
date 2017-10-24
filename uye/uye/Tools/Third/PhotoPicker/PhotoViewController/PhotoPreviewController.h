//
//  PhotoPreviewController.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPhotoPickerConfig.h"
#import "PhotoDataManager.h"
@interface PhotoPreviewController : UIViewController
@property(nonatomic, strong)KZPhotoPickerConfig * pickerConfig;
@property(nonatomic, strong)PhotoDataManager * photoManager;
@property(nonatomic, strong)NSMutableArray * selectPhotoArray;
@property(nonatomic, assign)NSInteger currentIndex;

@end
