//
//  PhotoViewController.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPreviewController.h"

@interface PhotoViewController : UIViewController
@property(nonatomic, strong)KZPhotoPickerConfig * pickerConfig;
@property (nonatomic, strong)PHAssetCollection *assetCollection; //相册集，通过该属性获取该相册集下所有照片

@end
