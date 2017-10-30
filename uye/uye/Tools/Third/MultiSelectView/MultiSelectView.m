//
//  MultiSelectView.m
//  MultiSelectView
//
//  Created by Tintin on 2017/3/30.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import "MultiSelectView.h"
#import "MultSelectHeadView.h"
#import "KZSegmentControl.h"
@interface MultiSelectView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    NSInteger _nearlyindex;
}
@property (nonatomic, strong) UIView * bgView;//整个背景白色

@property (nonatomic, strong) MultSelectHeadView * selectHeadView;//头部，标题和关闭按钮
@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) KZSegmentControl * segmentControl;
@end
#ifndef kScreenWidth
#define kScreenWidth    CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

#ifndef kScreenHeight
#define kScreenHeight    CGRectGetHeight([UIScreen mainScreen].bounds)
#endif
#define MultiSelectViewDefaultHeight 440
#define MultSelectHeadViewHeight 44

static NSString * cellIdentifier = @"cellIdentifier";
@implementation MultiSelectView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMultiSelectiView)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _nearlyindex = 0;
        [self configSubViews];
        
    }
    return self;
}

- (void)configSubViews  {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.selectHeadView];
    [self.bgView addSubview:self.segmentControl];
    [self.bgView addSubview:self.contentView];
    [self addTableView];

}
- (void)setHeadView:(UIView *)headView {
    _headView = headView;
    if (![self.subviews containsObject:_headView]) {
        [self.bgView addSubview:_headView];
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat height = CGRectGetHeight(_headView.bounds);
            self.bgView.frame = CGRectMake(0, kScreenHeight-MultiSelectViewDefaultHeight-height, kScreenWidth, MultiSelectViewDefaultHeight+height);
            _headView.frame = CGRectMake(0, MultSelectHeadViewHeight, kScreenWidth, height);
            self.segmentControl.frame = CGRectMake(0, MultSelectHeadViewHeight+height, kScreenWidth, MultSelectHeadViewHeight);
            self.contentView.frame = CGRectMake(0, MultSelectHeadViewHeight*2+height, kScreenWidth, MultiSelectViewDefaultHeight-2*MultSelectHeadViewHeight);
        }];
    }
}
- (void)reloadDateWithColumnIndex:(NSInteger)index {
    UITableView * tableView = [self.contentView viewWithTag:index];
    if ([tableView isKindOfClass:[UITableView class]]) {
        [tableView reloadData];
    }
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInSelectViewIndex:)]) {
        return [self.dataSource numberOfRowsInSelectViewIndex:tableView.tag];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString * textStr = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleWithRow:selectViewIndex:)]) {
      textStr = [self.dataSource titleWithRow:indexPath.row selectViewIndex:tableView.tag];
    }
    cell.textLabel.text = textStr;
    return cell;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    NSString * cellText = cell.textLabel.attributedText.string;
    cellText = [cellText substringToIndex:cellText.length-1];
    cell.textLabel.text = cellText;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL hasNext = NO;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(haveNextSelectViewWithDidSelectedRow:selectViewIndex:)]) {
      hasNext = [self.dataSource haveNextSelectViewWithDidSelectedRow:indexPath.row selectViewIndex:tableView.tag];
    }
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * cellText = cell.textLabel.text;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",cellText] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:10/255.0 green:171/255.0 blue:246/255.0 alpha:1]}];
    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
    NSString * imageName = @"loan_select_icon";
    UIImage * image = [UIImage imageNamed:imageName];
    attachment.image = image;
    attachment.bounds = CGRectMake(5,1, image.size.width, image.size.height);
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    
    cell.textLabel.attributedText = attributedString;
    
    NSMutableArray * titleArray = [NSMutableArray arrayWithArray:self.segmentControl.titleArray];
    [titleArray replaceObjectAtIndex:tableView.tag withObject:cellText];
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",cellText];
    if (hasNext) {
        _nearlyindex = tableView.tag +1;
        if (titleArray.count >= self.contentView.subviews.count && _nearlyindex == self.contentView.subviews.count) {
            [self addTableView];
            [titleArray addObject:@"请选择"];
            [self.contentView setContentOffset:CGPointMake(kScreenWidth * (_nearlyindex-1), 0) animated:YES];
            self.segmentControl.titleArray = titleArray;
            [self scrollViewDidEndDecelerating:self.contentView];
            [self scrollViewDidScroll:self.contentView];
        }else{
            if (titleArray.count > _nearlyindex) {
                [titleArray replaceObjectAtIndex:_nearlyindex withObject:@"请选择"];
                [titleArray removeObjectsInRange:NSMakeRange(_nearlyindex+1, titleArray.count - _nearlyindex-1)];

            }else{
                [titleArray replaceObjectAtIndex:titleArray.count-1 withObject:@"请选择"];
            }
            self.segmentControl.titleArray = titleArray;
            [self removeTableViewWithUpdateTitleArray:NO];
        }
    }else{
        self.segmentControl.titleArray = titleArray;
        [self scrollViewDidScroll:self.contentView];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [self.segmentControl moveToIndex:offset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [self.segmentControl endMoveToIndex:offset];
    }
}

#pragma mark - 生命周期
- (void)showMultiSelectiView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        self.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        }];
    });

}
- (void)dismissMultiSelectiView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.bgView.frame, point)){
        return NO;
    }
    return YES;
}

#pragma mark - lazzy
- (void)setTitle:(NSString *)title {
    self.selectHeadView.title = title;
}
- (NSString *)title {
    return self.selectHeadView.title;
}
- (UIView *)bgView {
    if (!_bgView) {
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-MultiSelectViewDefaultHeight, width, MultiSelectViewDefaultHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (MultSelectHeadView *)selectHeadView {
    if (!_selectHeadView) {
        _selectHeadView = [[MultSelectHeadView alloc]init];
        __weak typeof(self)weakSelf = self;
        [_selectHeadView closeButtonAction:^{
            [weakSelf dismissMultiSelectiView];
        }];
    }
    return _selectHeadView;
}
- (KZSegmentControl *)segmentControl {
    if (!_segmentControl) {
        KZSegmentItemConfig * config = [[KZSegmentItemConfig alloc]init];
        config.itemWidth = kScreenWidth/4;
        config.lineHieght = 2.f;
        
        _segmentControl = [[KZSegmentControl alloc]initWithFrame:CGRectMake(0, MultSelectHeadViewHeight, kScreenWidth, MultSelectHeadViewHeight)];
        _segmentControl.config = config;
        _segmentControl.titleArray = @[@"请选择"];
        
        _segmentControl.isLinkScrollView = YES;
        [_segmentControl segmentControlChangeSelect:^(NSInteger selectedSegmentIndex) {
            _nearlyindex = selectedSegmentIndex;
            [self removeTableViewWithUpdateTitleArray:YES];
        }];
    }
    return _segmentControl;
}
- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, MultSelectHeadViewHeight *2, kScreenWidth, MultiSelectViewDefaultHeight-2*MultSelectHeadViewHeight)];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.delegate = self;
    }
    return _contentView;
}
- (void)addTableView {

    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*_nearlyindex, 0, kScreenWidth, height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.rowHeight = 40;
    tableView.tag = _nearlyindex;
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableView];
    _nearlyindex++;
    [self.contentView setContentSize:CGSizeMake(kScreenWidth*_nearlyindex, height)];
}
- (void)removeTableViewWithUpdateTitleArray:(BOOL)needUpdate {
    for (UIView * tableView in self.contentView.subviews) {
        if ([tableView isKindOfClass:[UITableView class]] && tableView.tag > _nearlyindex) {
            [tableView removeFromSuperview];
        }
    }
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    [self.contentView setContentSize:CGSizeMake(kScreenWidth*(_nearlyindex+1), height)];
    if (needUpdate) {
        
        NSMutableArray * titleArray = [NSMutableArray arrayWithArray:self.segmentControl.titleArray];
        [titleArray removeObjectsInRange:NSMakeRange(_nearlyindex+1, titleArray.count - _nearlyindex-1)];
        self.segmentControl.titleArray = titleArray;
    }
    
    [self.contentView setContentOffset:CGPointMake(kScreenWidth*_nearlyindex, 0) animated:YES];
    [self scrollViewDidScroll:self.contentView];

}
@end
