//
//  PhotoCollectionViewCell.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
@interface PhotoCollectionViewCell ()
@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.layer.masksToBounds = YES;
}
- (IBAction)markBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAssetAction:)]) {
        [self.delegate selectAssetAction:self.indexPath];
    }
}

@end
