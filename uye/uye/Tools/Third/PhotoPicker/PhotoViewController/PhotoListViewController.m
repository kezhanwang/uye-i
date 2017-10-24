//
//  PhotoListViewController.m
//  PhotoPicker
//
//  Created by 刘向晶 on 2016/12/12.
//  Copyright © 2016年 KeZhanWang. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoViewController.h"
#import "PhotoNavigationController.h"
@interface PhotoListViewController ()
@end
#import "PhotoListCell.h"
static NSString * photoListCellIdentifier = @"normalCellIdentifier";
@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoListCell" bundle:nil] forCellReuseIdentifier:photoListCellIdentifier];
    self.navigationItem.title = @"相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPhotoSelect)];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)setPhotoManager:(PhotoListManager *)photoManager {
    _photoManager = photoManager;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)showAlbumPermissions {
    
    UILabel * tipeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 300)];
    tipeLabel.text = @"相册权限被禁了，请在设置中打开";
    tipeLabel.textColor =[UIColor lightGrayColor];
    tipeLabel.textAlignment =NSTextAlignmentCenter;
    self.tableView.tableFooterView = tipeLabel;
}
- (void)cancelPhotoSelect {
    [self dismissControllerFailWithErrorCode:KZPhotoPickerUserCancel];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photoManager numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:photoListCellIdentifier];

    PhotoListModel * cellModel =  [self.photoManager cellModelWithIndexPath:indexPath];
    [self.photoManager requestImageForAsset:cellModel.headImageAsset size:CGSizeMake(80, 80) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
        cell.headerView.image = image;
    }];
    cell.titleLabel.text = cellModel.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld",(long)cellModel.count];;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoListModel * cellModel =  [self.photoManager cellModelWithIndexPath:indexPath];
    PhotoViewController * photoVC = [[PhotoViewController alloc]init];
    photoVC.navigationItem.title = cellModel.title;
    photoVC.assetCollection = cellModel.assetCollection;
    photoVC.pickerConfig = self.pickerConfig;
    [self.navigationController pushViewController:photoVC animated:YES];
}
- (void)dismissControllerFailWithErrorCode:(KZPhotoPickerError)code {
    PhotoNavigationController * photoNC = (PhotoNavigationController *)self.navigationController;
    if (photoNC.photoHandler) {
        photoNC.photoHandler(@[],code);
    }
}

@end
