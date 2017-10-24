//
//  PhotoListViewController.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPhotoPickerConfig.h"
#import "PhotoListManager.h"

@interface PhotoListViewController : UITableViewController
@property (nonatomic, strong)KZPhotoPickerConfig * pickerConfig;

@property (nonatomic,strong)PhotoListManager * photoManager;
- (void)showAlbumPermissions;
@end
