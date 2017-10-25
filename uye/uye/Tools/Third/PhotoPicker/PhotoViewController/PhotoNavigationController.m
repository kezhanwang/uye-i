//
//  PhotoNavigationController.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoNavigationController.h"
#import "PhotoListViewController.h"
#import "PhotoViewController.h"
@interface PhotoNavigationController ()

@end

@implementation PhotoNavigationController
- (instancetype)initWithPickerConfig:(KZPhotoPickerConfig *)photoConfig {
    PhotoListViewController * pickerVC =[[PhotoListViewController alloc]init];
    pickerVC.pickerConfig = photoConfig;
    
    self = [super initWithRootViewController:pickerVC];
    //设置返回按钮
    [self.navigationBar setTintColor:photoConfig.navigationTitleColor];
    
 
    __weak typeof(self)weakSelf =self;
    [PhotoListManager requestPhotoAuthorizationStatus:^(BOOL isSuccess) {
        if (isSuccess) {
            pickerVC.photoManager = [[PhotoListManager alloc]init];
            [weakSelf gotoPhotoVCWithPhotoManager:pickerVC.photoManager pickerConfig:photoConfig];
        }else{
            [pickerVC showAlbumPermissions];
            if (weakSelf.photoHandler) {
                weakSelf.photoHandler(@[],KZPhotoPickerAlbumPermissions);
            }
        }
    }];
    
    /*
     navigationBar.barTintColor = UIColor.white
     navigationBar.tintColor = UIColor.navigationBarTintColor
     navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.navigationBarTintColor,
     NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)];
     */
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:photoConfig.navigationBarColor];
    //设置titlr
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:photoConfig.navigationTitleColor,NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    
    /*设置 item文字 颜色 大小*/
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:photoConfig.navigationTitleColor,NSFontAttributeName :[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:141.0/255 green:141.0/255 blue:141.0/255 alpha:1],NSFontAttributeName : [UIFont systemFontOfSize:15]} forState:UIControlStateDisabled];
    
  

    return self;
}
- (void)gotoPhotoVCWithPhotoManager:(PhotoListManager*)photoManager pickerConfig:(KZPhotoPickerConfig *)photoConfig  {
    dispatch_async(dispatch_get_main_queue(), ^{
        PhotoListModel * cellModel =  [photoManager cellModelWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        PhotoViewController * photoVC = [[PhotoViewController alloc]init];
        photoVC.navigationItem.title = cellModel.title;
        photoVC.assetCollection = cellModel.assetCollection;
        photoVC.pickerConfig = photoConfig;
        [self pushViewController:photoVC animated:NO];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
  

}

- (void)selectPhotoComplete:(PhtotControlHandler)complete {
    self.photoHandler = complete;
}
- (void)dealloc {
    NSLog(@"navigatuon可以释放啊");
}
@end
