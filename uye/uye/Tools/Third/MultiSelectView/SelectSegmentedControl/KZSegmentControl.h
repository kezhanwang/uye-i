//
//  KZSegmentControl.h
//  saas
//
//  Created by 刘向晶 on 2016/11/21.
//  Copyright © 2016年 课栈网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZSegmentItemConfig : NSObject

@property(nonatomic,assign)CGFloat itemWidth;      //default is 0
@property(nonatomic,strong)UIFont * itemFont;       //default is 16
@property(nonatomic,strong)UIColor *textColor;     //default is saas_blackColor
@property(nonatomic,strong)UIColor *selectedColor; //default is themeColor

@property(nonatomic,assign)float linePercent;  //default is 1.0 线的长度占百分比
@property(nonatomic,assign)float lineHieght;   //default is 2.0 线的高度
@end


@interface KZSegmentControl : UIScrollView

@property(nonatomic,strong)KZSegmentItemConfig *config;
/**
 titleArray
 */
@property(nonatomic,strong)NSArray *titleArray;

/**
 当前第几个
 */
@property(nonatomic,readonly)NSInteger currentIndex;

/**
 是否联动外部的ScrollView，默认是YES。如果跟ScrollView无关，需要设置为NO
 */
@property(nonatomic, assign)BOOL isLinkScrollView;



- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

/**
 segment改变的

 @param complete 从0开始
 */
- (void)segmentControlChangeSelect:(void(^)(NSInteger selectedSegmentIndex))complete;


/**
 移动到第几个，如果是联动的，需要在`scrollViewDidScroll`调用此方法
 ```
 float offset = scrollView.contentOffset.x;
 offset = offset/CGRectGetWidth(scrollView.frame);
 [_segmentControl moveToIndex:offset];
 
 ```
 @param index 当前移动到的第几个
 */
-(void)moveToIndex:(float)index; //called in scrollViewDidScroll
/*
 首次出现，需要高亮显示第二个元素,scroll: 是外部关联的scroll
 [self endMoveToIndex:2];
 [scroll scrollRectToVisible:CGRectMake(2*w, 0.0, w,h) animated:NO];
 设置当前显示的第几个。 如果是联动 的，需要在`scrollViewDidEndDecelerating`方法调用此方法
 ```
 float offset = scrollView.contentOffset.x;
 offset = offset/CGRectGetWidth(scrollView.frame);
 [_segmentControl endMoveToIndex:offset];
 ```
 */
-(void)endMoveToIndex:(float)index;  //called in scrollViewDidEndDecelerating



//
-(void)hiddenSelect;


@end
