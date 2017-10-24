//
//  KZPhotoPicker+TipsImage.h
//  KZW_iPhone2
//
//  Created by Tintin on 2017/1/5.
//  Copyright © 2017年 课栈网. All rights reserved.
//


#import "KZPhotoPicker.h"
@interface KZPhotoPicker (TipsImage)
-(void)showActionSheetFromViewController:(UIViewController *)controller TipsImage:(NSString *)imageName complete:(void(^)(NSArray *photos,NSError * error,BOOL isCamera))complte;
- (void)showLoanImagePickerFromViewController:(UIViewController *)controller tipsImage:(NSString *)imageName complete:(void(^)(NSArray *photos,NSError * error,BOOL isCamera))complte;
@end
