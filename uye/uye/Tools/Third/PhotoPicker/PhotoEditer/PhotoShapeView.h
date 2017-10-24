//
//  PhotoShapeView.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoShapeView : UIView
@property (nonatomic, strong) UIBezierPath *shapePath;

@property (nonatomic, strong) NSArray<UIBezierPath *> *shapePaths;

@property (nonatomic, strong) UIColor *coverColor; // default is black, alpha 0.7
@end
