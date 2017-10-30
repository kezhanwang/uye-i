//
//  MultSelectHeadView.h
//  MultiSelectView
//
//  Created by Tintin on 2017/3/30.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultSelectHeadView : UIView

@property (nonatomic, copy) NSString * title;

- (void)closeButtonAction:(void(^)(void))action;
@end
