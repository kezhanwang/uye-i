//
//  PhotoCollectionViewCell.h
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoCollectionViewCellDelegate;
@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;
@property(nonatomic, strong)NSIndexPath * indexPath;
@property(nonatomic, assign)id<PhotoCollectionViewCellDelegate> delegate;
@end
@protocol PhotoCollectionViewCellDelegate <NSObject>

- (void)selectAssetAction:(NSIndexPath *)indexPath;

@end
