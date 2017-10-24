//
//  PhotoViewController.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoDataManager.h"
#import "PhotoNavigationController.h"
@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PhotoCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)PhotoDataManager *photoManager;
@property (nonatomic,strong)NSMutableArray * selectPhotoArray;
@property (weak, nonatomic) IBOutlet UIButton *makeSureButton;
@end
static NSString * photoCollectionCellIdentifier = @"PhotoCollectionViewCell";
@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self updateMakeSureButtonStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoManager = [[PhotoDataManager alloc]initWithAssetCollection:self.assetCollection];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:photoCollectionCellIdentifier];
    self.selectPhotoArray = [NSMutableArray array];
    if (self.pickerConfig.barButtonColor) {
        [self.makeSureButton setTitleColor:self.pickerConfig.barButtonColor forState:UIControlStateNormal];
    }
    UIBarButtonItem * rightBarbutton =[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelectAction)];
    [rightBarbutton setTintColor:self.pickerConfig.navigationTitleColor];
    self.navigationItem.rightBarButtonItem = rightBarbutton;
    dispatch_time_t secont = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secont * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self secrollToEnd];
    });
}

- (void)cancelSelectAction {
    PhotoNavigationController * photoNC = (PhotoNavigationController *)self.navigationController;
    if (photoNC.photoHandler) {
        photoNC.photoHandler(@[],KZPhotoPickerUserCancel);
    }
}
#pragma mark- 滚动到底部
-(void)secrollToEnd{
    if (self.collectionView.contentSize.height<self.collectionView.bounds.size.height) {
        return;
    }
    CGFloat scrollHeight = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
    if (scrollHeight < 64) {
        scrollHeight = 64;
    }
    self.collectionView.contentOffset = CGPointMake(0, scrollHeight);
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoManager numberOfItems];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGSizeMake((screenSize.width-3)/3, (screenSize.width-3)/3);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView2 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell* cell = [collectionView2 dequeueReusableCellWithReuseIdentifier:photoCollectionCellIdentifier forIndexPath:indexPath];
    PhotoModel *assetModel = [self.photoManager cellModelWithIndex:indexPath];
    [self.photoManager requestImageForAsset:assetModel.asset size:(CGSize){cell.bounds.size.width*2,cell.bounds.size.width*2} resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    
    [cell.markBtn setSelected:assetModel.isSelect];
    cell.indexPath = indexPath;
    cell.delegate = self;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoPreviewController * photoPreViewC = [[PhotoPreviewController alloc]init];
    photoPreViewC.pickerConfig = self.pickerConfig;
    photoPreViewC.photoManager = self.photoManager;
    photoPreViewC.selectPhotoArray = self.selectPhotoArray;
    photoPreViewC.currentIndex = indexPath.item;
    [self.navigationController pushViewController:photoPreViewC animated:YES];
}
- (void)selectAssetAction:(NSIndexPath *)indexPath {
    PhotoModel *assetModel = [self.photoManager cellModelWithIndex:indexPath];
    if (assetModel.isSelect) {
        [self hadnlerPhotoModel:assetModel select:NO complete:NULL];
    }else{
        if (self.pickerConfig.allowsMultipleSelection) {
            if (self.pickerConfig.maxNumberOfSelection > self.selectPhotoArray.count) {
                [self hadnlerPhotoModel:assetModel select:YES complete:NULL];
            }else{
                NSString * titleStr =[NSString stringWithFormat:@"最多只能选择%ld张照片哦",(long)self.pickerConfig.maxNumberOfSelection];
                UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:titleStr message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }else{
            __weak typeof(self)weakSelf = self;
            [self hadnlerPhotoModel:assetModel select:YES complete:^(BOOL finish) {
                [weakSelf makeSureButtonAction:nil];
            }];
        
        }
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}
- (void)hadnlerPhotoModel:(PhotoModel *)assetModel select:(BOOL)select complete:(void(^)(BOOL finish))complete {
    assetModel.isSelect = select;
    if (select) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize expectSize = (CGSize){screenSize.width*3,screenSize.height*3};
        __weak typeof(self)weakSelf = self;
        [self.photoManager requestImageForAsset:assetModel.asset size:expectSize resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
            if (image) {
                assetModel.image = image;
            }
            [weakSelf.selectPhotoArray addObject:assetModel];
            [weakSelf updateMakeSureButtonStatus];
            if (complete) {
                complete(YES);
            }
        }];
    }else{
        assetModel.image = nil;
        if ([self.selectPhotoArray containsObject:assetModel]) {
            [self.selectPhotoArray removeObject:assetModel];
        }
        if (complete) {
            complete(YES);
        }
    }
}
- (void)updateMakeSureButtonStatus {
    if (self.selectPhotoArray.count > 0) {
        [self.makeSureButton setEnabled:YES];
    }else{
        [self.makeSureButton setEnabled:NO];
    }
}
- (IBAction)makeSureButtonAction:(id)sender {
    PhotoNavigationController * photoNC = (PhotoNavigationController *)self.navigationController;
    if (photoNC.photoHandler) {
        NSMutableArray * imageArray = [NSMutableArray array];
        for (PhotoModel *assetModel in self.selectPhotoArray) {
            if (assetModel.image) {
                [imageArray addObject:assetModel.image];
            }
        }
        photoNC.photoHandler(imageArray,KZPhotoPickerSuccess);
    }
}


@end
