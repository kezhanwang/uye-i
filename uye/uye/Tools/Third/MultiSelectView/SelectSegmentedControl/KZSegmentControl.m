//
//  KZSegmentControl.m
//  saas
//
//  Created by 刘向晶 on 2016/11/21.
//  Copyright © 2016年 课栈网. All rights reserved.
//

#import "KZSegmentControl.h"
@implementation KZSegmentItemConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        _itemWidth = 0;
        _itemFont = [UIFont systemFontOfSize:16];
        _textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        _selectedColor = [UIColor colorWithRed:10.0/255 green:170.0/255 blue:245.0/255 alpha:1];
        _linePercent = 1.0;
        _lineHieght = 3.0;
    }
    return self;
}


@end
#ifndef kScreenWidth
#define kScreenWidth    CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

#ifndef kScreenHeight
#define kScreenHeight    CGRectGetHeight([UIScreen mainScreen].bounds)
#endif

typedef void(^SegmentControlItemSelect)(NSInteger selectIndex);
@interface KZSegmentControl ()
@property(nonatomic,strong)UIView *line;
@property (nonatomic,copy)SegmentControlItemSelect selectAction;
@end
#define minButtonWidth  kScreenWidth/4
#define lineSpace 5 //竖线距离上面以及下面的具体。
@implementation KZSegmentControl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self initDataSource];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDataSource];
}

- (void)initDataSource {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.isLinkScrollView = NO;
}
- (void)segmentControlChangeSelect:(void (^)(NSInteger))complete {
    self.selectAction = complete;
}
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    UIButton *btn = (UIButton*)[self viewWithTag:segment+100];
    [btn setTitle:title forState:UIControlStateNormal];
}
-(void)setTitleArray:(NSArray *)titleArray {

    _titleArray = titleArray;
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    if(!_config){
        NSLog(@"请先设置config");
        return;
    }
    
    float x = 0;
    float y = 0;
    float width = _config.itemWidth;
    float height = self.frame.size.height;
    
    for (int i=0; i<titleArray.count; i++) {
        
        x = _config.itemWidth*i;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
        btn.tag = 100+i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
        btn.titleLabel.font = _config.itemFont;
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [btn addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if(i==0){
            [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
            _currentIndex = 0;
            self.line = [[UIView alloc] initWithFrame:CGRectMake(_config.itemWidth*(1-_config.linePercent)/2.0, CGRectGetHeight(self.frame) - _config.lineHieght, _config.itemWidth*_config.linePercent, _config.lineHieght)];
            _line.backgroundColor = _config.selectedColor;
            [self addSubview:_line];
        }
    }
    CGFloat lineWidth = width*titleArray.count < kScreenWidth ? kScreenWidth : width*titleArray.count;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height-1, lineWidth, 0.5f)];
    lineView.backgroundColor =[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1];
    [self addSubview:lineView];
    [self bringSubviewToFront:self.line];
    self.contentSize = CGSizeMake(width*titleArray.count, height);
}


#pragma mark - 点击事件

- (void)itemButtonClicked:(UIButton*)button {
    //接入外部效果
    _currentIndex = button.tag-100;
    
    if(!_isLinkScrollView){
        //没有动画，需要手动瞬移线条，改变颜色
        [self changeItemColor:_currentIndex];
        [self changeLine:_currentIndex];
    }

    [self changeScrollOfSet:_currentIndex];
    
    if(self.selectAction){
        _selectAction(_currentIndex);
    }
    
    
}


#pragma mark - Methods

//改变文字焦点
- (void)changeItemColor:(NSInteger)index {
    
    _line.hidden = NO;
    for (int i=0; i<_titleArray.count; i++) {
        
        UIButton *btn = (UIButton*)[self viewWithTag:i+100];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
        if(btn.tag == index+100){
            [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
        }
    }
}

//改变线条位置
- (void)changeLine:(float)index {
    _line.hidden = NO;
    CGRect rect = _line.frame;
    rect.origin.x = index*_config.itemWidth + _config.itemWidth*(1-_config.linePercent)/2.0;
    _line.frame = rect;
}


//向上取整
- (NSInteger)changeProgressToInteger:(float)x {
    
    float max = _titleArray.count;
    float min = 0;
    
    NSInteger index = 0;
    
    if(x< min+0.5){
        
        index = min;
        
    }else if(x >= max-0.5){
        
        index = max;
        
    }else{
        
        index = (x+0.5)/1;
    }
    
    return index;
}


//移动ScrollView
- (void)changeScrollOfSet:(NSInteger)index {
    float  halfWidth = CGRectGetWidth(self.frame)/2.0;
    float  scrollWidth = self.contentSize.width;
    
    float leftSpace = _config.itemWidth*index - halfWidth + _config.itemWidth/2.0;
    
    if(leftSpace > scrollWidth- 2*halfWidth){
        leftSpace = scrollWidth-2*halfWidth;
    }
    if(leftSpace<0){
        leftSpace = 0;
    }
    [self setContentOffset:CGPointMake(leftSpace, 0) animated:YES];
}


#pragma mark - 在ScrollViewDelegate中回调
- (void)moveToIndex:(float)x {
    [self changeLine:x];
    NSInteger tempIndex = [self changeProgressToInteger:x];
    if(tempIndex != _currentIndex){
        //保证在一个item内滑动，只执行一次
        [self changeItemColor:tempIndex];
    }
    _currentIndex = tempIndex;
}

- (void)endMoveToIndex:(float)x {
    [self changeLine:x];
    [self changeItemColor:x];
    _currentIndex = x;
    [self changeScrollOfSet:x];
}



//是否隐藏选中的颜色
-(void)hiddenSelect{
    
    _line.hidden = YES;
    
    for (int i=0; i<_titleArray.count; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:i+100];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
    
    }


}


@end
