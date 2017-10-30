//
//  MultiSelectView.h
//  MultiSelectView
//
//  Created by Tintin on 2017/3/30.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MultiSelectViewDataSource <NSObject>
//`row`当前选中的行，`index`当前选中的页码
@required
/**return 当前页码的行数*/
- (NSInteger)numberOfRowsInSelectViewIndex:(NSInteger)index;
/*return 当前行的标题*/
- (NSString *)titleWithRow:(NSInteger)row selectViewIndex:(NSInteger)index;
/*返回是否还有下一个选择项页*/
- (BOOL)haveNextSelectViewWithDidSelectedRow:(NSInteger)row selectViewIndex:(NSInteger)index;
@end

/*多选框，类似京东地址选择
 实线思路按照了TableView的类似思路，数据源由外面给出，界面样式却写死里面了。
 */
@interface MultiSelectView : UIView

/*数据源*/
@property (nonatomic, assign) id<MultiSelectViewDataSource> dataSource;
/*标题，默认是空*/
@property (nonatomic, copy) NSString * title;
/*默认是nil*/
@property (nonatomic, strong) UIView * headView;

- (void)reloadDateWithColumnIndex:(NSInteger)index;

- (void)showMultiSelectiView;
- (void)dismissMultiSelectiView;
@end
