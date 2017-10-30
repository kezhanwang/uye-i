//
//  KZTextField.m
//  MultiSelectView
//
//  Created by Tintin on 2017/3/31.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import "KZTextField.h"

@implementation KZTextField

-(CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 0, 5);
}

-(CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 0, 5);
}


@end
