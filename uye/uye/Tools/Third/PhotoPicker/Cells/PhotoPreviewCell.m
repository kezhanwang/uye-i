//
//  PhotoPreviewCell.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoPreviewCell.h"

@implementation PhotoPreviewCell

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
@end
