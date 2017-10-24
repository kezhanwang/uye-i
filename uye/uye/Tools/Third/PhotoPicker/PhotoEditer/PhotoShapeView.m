//
//  PhotoShapeView.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/13.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoShapeView.h"

@implementation PhotoShapeView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    [clipPath appendPath:self.shapePath];
    for (UIBezierPath *path in self.shapePaths) {
        [clipPath appendPath:path];
    }
    
    clipPath.usesEvenOddFillRule = YES;
    [clipPath addClip];
    
    if (!self.coverColor) {
        self.coverColor = [UIColor blackColor];
        CGContextSetAlpha(context, 0.7f);
    }
    [self.coverColor setFill];
    [clipPath fill];
}


@end
