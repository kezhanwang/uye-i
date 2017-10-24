//
//  BottomView.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView

/**
 可点击状态的背景色
 */
@property(nonatomic, strong)UIColor * normalBackColor;
- (void)updateBottomStatusWithCount:(NSUInteger)count;
- (void)makeSureButtonClick:(void(^)(void))complete;
- (void)showBottomView;
- (void)hiddenBottomView;
@end
