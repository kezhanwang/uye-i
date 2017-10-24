//
//  PhotoModel.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoModel : NSObject
@property(nonatomic, strong)PHAsset * asset;
@property(nonatomic, assign)BOOL isSelect;
@property(nonatomic, strong)UIImage * image;
@end
