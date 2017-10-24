//
//  HeadView.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView
@property (nonatomic,copy)NSString * title;
- (void)updateSelectButtonStatus:(BOOL)isSelect;
- (void)backButtonClick:(void(^)(void))complete;
- (void)selectButtonAction:(BOOL(^)(void))complete;
- (void)showHeaderView;
- (void)hiddenHeaderView;
@end
