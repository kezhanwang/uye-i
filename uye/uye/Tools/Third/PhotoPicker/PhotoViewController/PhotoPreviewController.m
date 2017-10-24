//
//  PhotoPreviewController.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoPreviewController.h"
#import "PhotoPreviewCell.h"
#import "HeadView.h"
#import "BottomView.h"
#import "PhotoNavigationController.h"
@interface PhotoPreviewController ()
{
    BOOL isShowBarView;//监控bottomView和HeadView是否显示
}
@property (nonatomic,strong)HeadView * headerView;
@property (nonatomic,strong)BottomView * bottomView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
static NSString * previewCellIdentifier = @"PhotoPreviewCell";
@implementation PhotoPreviewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isShowBarView = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoPreviewCell" bundle:nil] forCellWithReuseIdentifier:previewCellIdentifier];
    self.headerView = [[HeadView alloc]init];
    [self.view addSubview:self.headerView];
    self.bottomView = [[BottomView alloc]init];
    self.bottomView.normalBackColor = self.pickerConfig.barButtonColor;
    [self.view addSubview:self.bottomView];
    [self.bottomView updateBottomStatusWithCount:self.selectPhotoArray.count];
    
    __weak typeof(self)weakSelf = self;
    [self.headerView backButtonClick:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.headerView selectButtonAction:^BOOL{
        return [weakSelf updateSelectArray];
    }];
    [self.bottomView makeSureButtonClick:^{
        [weakSelf makeSureBttonAction];
    }];
    
    UITapGestureRecognizer * taggesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBarViews)];
    [self.view addGestureRecognizer:taggesture];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:CGPointMake(_currentIndex*screenSize.width,0) animated:NO];
        [self scrollViewDidEndDecelerating:self.collectionView];
    });
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoManager numberOfItems];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return (CGSize){screenSize.width,screenSize.height};
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView2 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPreviewCell* cell = [collectionView2 dequeueReusableCellWithReuseIdentifier:previewCellIdentifier forIndexPath:indexPath];
    PhotoModel *assetModel = [self.photoManager cellModelWithIndex:indexPath];
    [self.photoManager requestImageForAsset:assetModel.asset size:(CGSize){cell.bounds.size.width*2,cell.bounds.size.height*2} resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    return cell;
}
- (void)hiddenBarViews {
    if (isShowBarView) {
        [self.headerView hiddenHeaderView];
        [self.bottomView hiddenBottomView];
        [[UIApplication  sharedApplication]setStatusBarHidden:YES];
    }else{
        [self.headerView showHeaderView];
        [self.bottomView showBottomView];
        [[UIApplication  sharedApplication]setStatusBarHidden:NO];
    }
    isShowBarView = !isShowBarView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat screenWidth =  CGRectGetWidth([UIScreen mainScreen].bounds);
    NSInteger currentShowIndex = scrollView.contentOffset.x/screenWidth;
    _currentIndex = currentShowIndex;
    PhotoModel *assetModel = [self.photoManager cellModelWithIndex:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    [self.headerView updateSelectButtonStatus:assetModel.isSelect];
    
    currentShowIndex += 1;
    if (currentShowIndex >= [self.photoManager numberOfItems]) {
        currentShowIndex = [self.photoManager numberOfItems];
    }
    self.headerView.title = [NSString stringWithFormat:@"%ld/%ld",(long)currentShowIndex,(long)[self.photoManager numberOfItems]];
}
- (BOOL)updateSelectArray {
    PhotoModel *assetModel = [self.photoManager cellModelWithIndex:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
        if (assetModel.isSelect) {
            [self hadnlerPhotoModel:assetModel select:NO complete:NULL];

        }else{
            if (self.pickerConfig.allowsMultipleSelection) {
                if (self.pickerConfig.maxNumberOfSelection > self.selectPhotoArray.count) {
                    [self hadnlerPhotoModel:assetModel select:YES complete:NULL];
                }else{
                    NSString * titleStr = [NSString stringWithFormat:@"最多只能选择%ld张照片哦",(long)self.pickerConfig.maxNumberOfSelection];
                    UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:titleStr message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }else{
                __weak typeof(self)weakSelf = self;
                [self hadnlerPhotoModel:assetModel select:YES complete:^(BOOL finish) {
                    [weakSelf makeSureBttonAction];
                }];

            }
        }
    [self.bottomView updateBottomStatusWithCount:self.selectPhotoArray.count];
    return assetModel.isSelect;
}
- (void)hadnlerPhotoModel:(PhotoModel *)assetModel select:(BOOL)select complete:(void(^)(BOOL finish))complete {
    assetModel.isSelect = select;
    if (select) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize expectSize = self.pickerConfig.allowsMultipleSelection ? (CGSize){screenSize.width*3,screenSize.height*3} : PHImageManagerMaximumSize;
        __weak typeof(self)weakSelf = self;

        [self.photoManager requestImageForAsset:assetModel.asset size:expectSize resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
            assetModel.image = image;
            [weakSelf.selectPhotoArray addObject:assetModel];
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
- (void)makeSureBttonAction {
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
