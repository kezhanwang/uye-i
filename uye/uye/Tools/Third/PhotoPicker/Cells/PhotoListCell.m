//
//  PhotoListCell.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoListCell.h"

@implementation PhotoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerView.layer.masksToBounds = YES;
}



@end
