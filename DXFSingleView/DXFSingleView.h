//
//  DXFSingleView.h
//  DXFSingleView
//
//  Created by duanxuefang on 2017/6/16.
//  Copyright © 2017年 duanxuefang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXFSingleViewDelegate <NSObject>

/** 选中view回调 */
@required
-(void)DXFSingleView:(UIView*)DXFSingleView selectedView:(UIView*)selectedView andSelectedContent:(NSString *)selectedContent;

@end

@interface DXFSingleView : UIView
/** 默认选中属性 默认不选任何属性 设置则默认选中*/
@property(assign, nonatomic)NSInteger defaultIndex;
/** 字体大小 */
@property(strong, nonatomic)UIFont *fontSize;
/** 选中的边框颜色 */
@property(strong, nonatomic)UIColor *selecteBorderColor;
/** 未选中的边框颜色 */
@property(strong, nonatomic)UIColor *noSelecteBorderColor;
/** 选中的字体颜色 */
@property(strong, nonatomic)UIColor *selecteTextColor;
/** 未选中的字体颜色*/
@property(strong, nonatomic)UIColor *noSelecteTextColor;
/** 文字从后往前一段长度的文字字体颜色更改*/
@property(assign , nonatomic)NSInteger fromBehindLength;
/** fromBehindLength文字颜色的更改*/
@property(strong , nonatomic)UIColor *fromBehindLengthTextColor;
/** 圆角半径*/
@property(assign , nonatomic)NSInteger cornerRadius;
/** 输入框  可以拿到输入框进行相应的设置*/
@property(strong, nonatomic)UITextField *textField;

@property(weak, nonatomic)id<DXFSingleViewDelegate>delegate;


/** 没有textField初始化方式*/
-(instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)buttonTitleArray rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount BtnWidth:(NSInteger)BtnWidth BtnHeight:(NSInteger)BtnHeight delegate:(id<DXFSingleViewDelegate>)delegate;


/** 存在textField初始化方式 
  * textFiled高度与按钮的高度一致
  * 此时的rowCount和columnCount记住把textFiled控件也算在内
  * textFiled右边没有文本传nil即可
 */
-(instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)buttonTitleArray rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount BtnWidth:(NSInteger)BtnWidth BtnHeight:(NSInteger)BtnHeight textFiledWidth:(NSInteger)textFiledWidth textFieldRightText:(NSString *)textFieldRightText textFieldRightTextFont:(UIFont *)textFieldRightTextFont textFieldRightTextColor:(UIColor *)textFieldRightTextColor delegate:(id<DXFSingleViewDelegate>)delegate;

@end
