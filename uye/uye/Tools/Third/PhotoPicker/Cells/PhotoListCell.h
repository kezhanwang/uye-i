//
//  PhotoListCell.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
