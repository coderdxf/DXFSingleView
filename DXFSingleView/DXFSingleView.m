//
//  DXFSingleView.m
//  DXFSingleView
//
//  Created by duanxuefang on 2017/6/16.
//  Copyright © 2017年 duanxuefang. All rights reserved.
//

#import "DXFSingleView.h"


@interface DXFSingleView()

@property(strong, nonatomic)NSArray *buttonTitleArray;

@property(assign , nonatomic)NSInteger columnCount;

@property(assign , nonatomic)NSInteger rowCount;

@property(assign , nonatomic)NSInteger BtnWidth;

@property(assign , nonatomic)NSInteger BtnHeight;

/** 文字从后往前一段长度的文字字体颜色更改*/
@property(assign , nonatomic)NSInteger fromBehindLength;
/** fromBehindLength文字颜色的更改*/
@property(strong , nonatomic)UIColor *fromBehindLengthTextColor;

@property(assign , nonatomic)BOOL isHaveTextFiled;

@property(assign , nonatomic)NSInteger textFiledHeight;
/** 输入框的宽度 */
@property(assign , nonatomic)NSInteger textFiledWidth;
/** 输入框右边文字内容*/
@property(copy , nonatomic)NSString *textFieldRightText;
/** 输入框右边文字字体大小*/
@property(strong , nonatomic)UIFont *textFieldRightTextFont;
/** 输入框右边文字字体颜色*/
@property(strong , nonatomic)UIColor *textFieldRightTextColor;
/** 输入框右边文字*/
@property(strong, nonatomic)UILabel *textFieldRightLabel;
/** 输入框右边文字长度*/
@property(assign, nonatomic)CGFloat textFieldRightTextWidth;
@end
@implementation DXFSingleView
-(instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)buttonTitleArray rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount BtnWidth:(NSInteger)BtnWidth BtnHeight:(NSInteger)BtnHeight delegate:(id<DXFSingleViewDelegate>)delegate{
    if (self == [super initWithFrame:frame]) {
        self.buttonTitleArray = buttonTitleArray;
        self.columnCount = columnCount;
         self.rowCount = rowCount;
        self.BtnWidth = BtnWidth;
        self.BtnHeight = BtnHeight;
        self.textFiledWidth = BtnWidth;
        self.textFiledHeight = BtnHeight;
        self.isHaveTextFiled = NO;
        self.delegate = delegate;
        
        [self initialization];
        [self configureSubviewsNoTextFiled];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame buttonTitleArray:(NSArray *)buttonTitleArray rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount BtnWidth:(NSInteger)BtnWidth BtnHeight:(NSInteger)BtnHeight textFiledWidth:(NSInteger)textFiledWidth textFieldRightText:(NSString *)textFieldRightText textFieldRightTextFont:(UIFont*)textFieldRightTextFont textFieldRightTextColor:(UIColor *)textFieldRightTextColor delegate:(id<DXFSingleViewDelegate>)delegate{
    if (self == [super initWithFrame:frame]) {
        self.buttonTitleArray = buttonTitleArray;
        self.columnCount = columnCount;
        self.rowCount = rowCount;
        self.BtnWidth = BtnWidth;
        self.BtnHeight = BtnHeight;
        self.textFiledWidth = textFiledWidth;
        self.textFiledHeight = BtnHeight;
        if (textFieldRightText == nil) {
            textFieldRightText = @"";
        }
        self.textFieldRightText = textFieldRightText;
        self.textFieldRightTextFont = textFieldRightTextFont;
        self.textFieldRightTextColor = textFieldRightTextColor;
        self.textFieldRightTextWidth = [self widthForString:textFieldRightText];
        self.isHaveTextFiled = YES;
        self.delegate = delegate;
        
        [self initialization];
        [self configureSubviewsWithTextFiled];
    }
    return self;
}
- (void)initialization
{
    _defaultIndex = -1;
    _fontSize = [UIFont systemFontOfSize:15];
    _selecteBorderColor = [UIColor redColor];
    _noSelecteBorderColor = [UIColor grayColor];
    _selecteTextColor = [UIColor redColor];
    _noSelecteTextColor = [UIColor grayColor];
    _cornerRadius = self.BtnHeight / 10;
    _fromBehindLength = 0;
    _fromBehindLengthTextColor = [UIColor greenColor];
    
}
#pragma mark -计算文本的宽度
- (float)widthForString:(NSString *)value
{
    if (value == nil || [value isEqualToString:@""]) {
        return 0.0;
    }
    UIFont *font=self.textFieldRightTextFont;
    NSDictionary *attrs=@{NSFontAttributeName:font};
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, self.BtnHeight) options:NSStringDrawingTruncatesLastVisibleLine  attributes:attrs context:nil];
    return sizeToFit.size.width;
}
#pragma mark -配置button
- (void)configureSubviewsWithTextFiled{
    CGRect frame = self.frame;
    CGFloat marginX;
    CGFloat marginY;
    if (self.isHaveTextFiled == NO) {
        marginX = (frame.size.width - (self.columnCount) * self.BtnWidth) / (self.columnCount + 1);
        marginY = (frame.size.height  - (self.rowCount) * self.BtnHeight) / (self.rowCount + 1);
    }else {
        self.textField = [[UITextField alloc] init];
        self.textField.layer.borderWidth = 1;
        self.textField.layer.borderColor = _noSelecteBorderColor.CGColor;
        self.textField.layer.cornerRadius = _cornerRadius;
        self.textField.textColor =  _noSelecteTextColor;
        self.textField.font = _fontSize;
        [self.textField addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
        [self.textField addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventValueChanged | UIControlEventEditingDidBegin];
        [self addSubview:self.textField];
        
        self.textFieldRightLabel = [[UILabel alloc] init];
        self.textFieldRightLabel.text = self.textFieldRightText;
        self.textFieldRightLabel.textColor = self.textFieldRightTextColor;
        self.textFieldRightLabel.font = self.textFieldRightTextFont;
        self.textFieldRightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textFieldRightLabel];
        
        if (self.rowCount == 1) {
            marginX = (frame.size.width - (self.columnCount - 1) * self.BtnWidth - self.textFiledWidth - self.textFieldRightTextWidth) / (self.columnCount + 1);
            marginY = (frame.size.height  - (self.rowCount) * self.BtnHeight) / (self.rowCount + 1);
            self.textField.frame = CGRectMake(marginX +(self.buttonTitleArray.count % self.columnCount)*(self.BtnWidth +marginX), marginY+ (self.buttonTitleArray.count / self.columnCount)*(self.BtnHeight+marginY), self.textFiledWidth, self.textFiledHeight);
            self.textFieldRightLabel.frame = CGRectMake(CGRectGetMaxX(self.textField.frame), marginY+ (self.buttonTitleArray.count / self.columnCount)*(self.BtnHeight+marginY), self.textFieldRightTextWidth, self.textFiledHeight);
        }else if(self.buttonTitleArray.count + 1 == self.rowCount * self.columnCount){
            marginX = (frame.size.width - (self.columnCount) * self.BtnWidth) / (self.columnCount + 1);
            marginY = (frame.size.height  - (self.rowCount) * self.BtnHeight) / (self.rowCount + 1);
            self.textField.frame = CGRectMake(marginX +(self.buttonTitleArray.count % self.columnCount)*(self.BtnWidth +marginX), marginY+ (self.buttonTitleArray.count / self.columnCount)*(self.BtnHeight+marginY), self.BtnWidth - self.textFieldRightTextWidth, self.BtnHeight);
            self.textFieldRightLabel.frame = CGRectMake(CGRectGetMaxX(self.textField.frame), marginY+ (self.buttonTitleArray.count / self.columnCount)*(self.BtnHeight+marginY), self.textFieldRightTextWidth, self.textFiledHeight);
        }else {
            marginX = (frame.size.width - (self.columnCount) * self.BtnWidth) / (self.columnCount + 1);
            marginY = (frame.size.height  - (self.rowCount) * self.BtnHeight) / (self.rowCount + 1);
            self.textField.frame = CGRectMake(marginX +(self.buttonTitleArray.count % self.columnCount)*(self.BtnWidth +marginX), marginY+ (self.buttonTitleArray.count / self.columnCount)*(self.BtnHeight+marginY), self.textFiledWidth, self.textFiledHeight);
            self.textFieldRightLabel.frame = CGRectMake(CGRectGetMaxX(self.textField.frame), marginY+ (self.buttonTitleArray.count / self.columnCount)*(self.BtnHeight+marginY), self.textFieldRightTextWidth, self.textFiledHeight);
        }
        
    }
    for (int i = 0; i<self.buttonTitleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setAttributedTitle:[self attributedStringChangeColorWithStr:self.buttonTitleArray[i]] forState:UIControlStateNormal];
        btn.tag = 250 + i;
        btn.titleLabel.font = self.fontSize;
        btn.titleLabel.textColor = self.noSelecteTextColor;

        btn.layer.borderWidth = 1;
        btn.layer.borderColor = self.noSelecteBorderColor.CGColor;
        btn.layer.cornerRadius = _cornerRadius ;
        
        if (i == _defaultIndex) {
            btn.layer.borderColor = _selecteBorderColor.CGColor;
            btn.titleLabel.textColor = _selecteTextColor;
        }
        
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake( marginX +(i % self.columnCount)*(self.BtnWidth +marginX), marginY+ (i / self.columnCount)*(self.BtnHeight+marginY), self.BtnWidth, self.BtnHeight);
        [self addSubview:btn];
    }
    
}

#pragma mark -配置button
- (void)configureSubviewsNoTextFiled{
    CGRect frame = self.frame;
    CGFloat marginX;
    CGFloat marginY;
        marginX = (frame.size.width - (self.columnCount) * self.BtnWidth) / (self.columnCount + 1);
        marginY = (frame.size.height  - (self.rowCount) * self.BtnHeight) / (self.rowCount + 1);
    
    for (int i = 0; i<self.buttonTitleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setAttributedTitle:[self attributedStringChangeColorWithStr:self.buttonTitleArray[i]] forState:UIControlStateNormal];
        btn.tag = 250 + i;
        btn.titleLabel.font = self.fontSize;
        btn.titleLabel.textColor = self.noSelecteTextColor;
   
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = self.noSelecteBorderColor.CGColor;
        btn.layer.cornerRadius = _cornerRadius ;

        if (i == _defaultIndex) {
            btn.layer.borderColor = _selecteBorderColor.CGColor;
            btn.titleLabel.textColor = _selecteTextColor;
        }
        
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake( marginX +(i % self.columnCount)*(self.BtnWidth +marginX), marginY+ (i / self.columnCount)*(self.BtnHeight+marginY), self.BtnWidth, self.BtnHeight);
        [self addSubview:btn];
    }

}
#pragma mark -textField的值变化
-(void)textFieldValueChanged {
    self.textField.textColor = self.selecteTextColor;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = self.selecteBorderColor.CGColor;
    for (int i = 0 ; i < self.buttonTitleArray.count; i ++) {
        UIButton *butt = (UIButton *)[self viewWithTag:250 + i];
        butt.selected = NO;
        butt.layer.borderWidth = 1;
        butt.layer.borderColor = self.noSelecteBorderColor.CGColor;
        butt.titleLabel.textColor = self.noSelecteTextColor;
    }
    if ([self.delegate respondsToSelector:@selector(DXFSingleView:selectedView:andSelectedContent:)]) {
        [self.delegate DXFSingleView:self selectedView:_textField andSelectedContent:[_textField.text stringByAppendingString:self.textFieldRightText]];
    }
}
#pragma mark -点击方法
- (void)BtnClick:(UIButton *)btn{
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = _noSelecteBorderColor.CGColor;
    self.textField.layer.cornerRadius = _cornerRadius;
    self.textField.textColor =  _noSelecteTextColor;
    self.textField.text = nil;
    [self.textField endEditing:YES];
    for (int i = 0 ; i < self.buttonTitleArray.count; i ++) {
        if (btn.tag == 250 + i) {
            btn.selected = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = self.selecteBorderColor.CGColor;
            btn.titleLabel.textColor = self.selecteTextColor;
            continue;
        }
        UIButton *butt = (UIButton *)[self viewWithTag:250 + i];
        butt.selected = NO;
        butt.layer.borderWidth = 1;
        butt.layer.borderColor = self.noSelecteBorderColor.CGColor;
        butt.titleLabel.textColor = self.noSelecteTextColor;
    }
    if ([self.delegate respondsToSelector:@selector(DXFSingleView:selectedView:andSelectedContent:)]) {
        [self.delegate DXFSingleView:self selectedView:btn andSelectedContent:btn.titleLabel.text];
    }
}
-(NSAttributedString *)attributedStringChangeColorWithStr:(NSString *)str {
    NSMutableAttributedString *attrStr ;
    NSRange range = NSMakeRange(str.length -self.fromBehindLength, self.fromBehindLength);
    attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.fromBehindLengthTextColor range:range];
    return attrStr;
}
#pragma mark -- setter
- (void)setFontSize:(UIFont *)fontSize
{
    _fontSize = fontSize;
    for (int i = 0 ; i < self.buttonTitleArray.count; i ++) {
        UIButton *butt = (UIButton *)[self viewWithTag:250 + i];
        butt.titleLabel.font = fontSize;
    }
    self.textField.font = fontSize;
}
-(void)setDefaultIndex:(NSInteger)defaultIndex {
    if(defaultIndex >= self.buttonTitleArray.count || defaultIndex < 0){
      @throw [NSException exceptionWithName:@"defaultIndex is over the buttonTitleArray count" reason:nil userInfo:nil];
    }else {
        _defaultIndex = defaultIndex;
        UIButton *butt = (UIButton *)[self viewWithTag:250 + self.defaultIndex];
        butt.layer.borderColor = _selecteBorderColor.CGColor;
        butt.titleLabel.textColor = _selecteTextColor;
        [butt setAttributedTitle:[self attributedStringChangeColorWithStr:butt.titleLabel.text] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(DXFSingleView:selectedView:andSelectedContent:)]) {
            [self.delegate DXFSingleView:self selectedView:butt andSelectedContent:butt.titleLabel.text];
        }
    }
}
-(void)setSelecteBorderColor:(UIColor *)selecteBorderColor {
     _selecteBorderColor = selecteBorderColor;
    if (_defaultIndex < 0) {
        
    }else{
        
    UIButton *butt = (UIButton *)[self viewWithTag:250 + self.defaultIndex];
    butt.layer.borderColor = selecteBorderColor.CGColor;
        
    }
    
}

-(void)setNoSelecteBorderColor:(UIColor *)noSelecteBorderColor {
    _noSelecteBorderColor = noSelecteBorderColor;
    for (int i = 0 ; i < self.buttonTitleArray.count; i ++) {
        if (_defaultIndex >= 0 && _defaultIndex == i) {
            UIButton *btn = (UIButton *)[self viewWithTag:250 + self.defaultIndex];
            btn.selected = YES;
            btn.layer.borderColor = _noSelecteBorderColor.CGColor;
            continue;
        }
        UIButton *butt = (UIButton *)[self viewWithTag:250 + i];
        butt.selected = NO;
        butt.layer.borderColor = self.noSelecteBorderColor.CGColor;
    }

}
-(void)setSelecteTextColor:(UIColor *)selecteTextColor {
    _selecteTextColor = selecteTextColor;
    if (_defaultIndex < 0) {
        
    }else{
        
        UIButton *butt = (UIButton *)[self viewWithTag:250 + self.defaultIndex];
        butt.titleLabel.textColor = selecteTextColor;
        
    }
}
-(void)setNoSelecteTextColor:(UIColor *)noSelecteTextColor {
    _noSelecteTextColor = noSelecteTextColor;
    for (int i = 0 ; i < self.buttonTitleArray.count; i ++) {
        if (_defaultIndex >= 0 && _defaultIndex == i) {
            UIButton *btn = (UIButton *)[self viewWithTag:250 + self.defaultIndex];
            btn.selected = YES;
            btn.titleLabel.textColor = _noSelecteTextColor;
            continue;
        }
        UIButton *butt = (UIButton *)[self viewWithTag:250 + i];
        butt.selected = NO;
        butt.titleLabel.textColor = self.noSelecteTextColor;
    }
}
-(void)setFromBehindLength:(NSInteger)fromBehindLength {
    _fromBehindLength = fromBehindLength;
    for (int i = 0; i<self.buttonTitleArray.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:250 + i];
        [btn setAttributedTitle:[self attributedStringChangeColorWithStr:self.buttonTitleArray[i]] forState:UIControlStateNormal];
    }
}
-(void)setFromBehindLengthTextColor:(UIColor *)fromBehindLengthTextColor {
    _fromBehindLengthTextColor = fromBehindLengthTextColor;
    for (int i = 0; i<self.buttonTitleArray.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:250 + i];
        [btn setAttributedTitle:[self attributedStringChangeColorWithStr:self.buttonTitleArray[i]] forState:UIControlStateNormal];
    }
}
-(void)setCornerRadius:(NSInteger)cornerRadius {
    _cornerRadius = cornerRadius;
    for (int i = 0; i<self.buttonTitleArray.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:250 + i];
        btn.layer.cornerRadius = cornerRadius;
    }
    if (self.isHaveTextFiled == YES) {
        self.textField.layer.cornerRadius = cornerRadius;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
