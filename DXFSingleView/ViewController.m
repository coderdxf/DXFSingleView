//
//  ViewController.m
//  DXFSingleView
//
//  Created by duanxuefang on 2017/6/16.
//  Copyright © 2017年 duanxuefang. All rights reserved.
//

#import "ViewController.h"
#import "DXFSingleView.h"
@interface ViewController ()<DXFSingleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    DXFSingleView *singleView = [[DXFSingleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180) buttonTitleArray:@[@"兔子",@"小狗",@"大象",@"猫",@"长颈鹿",@"羊驼",@"大熊猫",@"老虎",@"狮子",@"老鹰"] rowCount:3 columnCount:4 BtnWidth:48 BtnHeight:23  delegate:self];
//    singleView.selecteTextColor = [UIColor greenColor];
//    singleView.selecteBorderColor = [UIColor greenColor];
    singleView.backgroundColor = [UIColor blackColor];
    singleView.defaultIndex = 1;
    [self.view addSubview:singleView];
    
    DXFSingleView *textView = [[DXFSingleView alloc] initWithFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, 66) buttonTitleArray:@[@"10元",@"20元",@"50元",@"100元"] rowCount:1 columnCount:5 BtnWidth:48 BtnHeight:23 textFiledWidth:106 textFieldRightText:@"元" textFieldRightTextFont: [UIFont systemFontOfSize:16] textFieldRightTextColor: [UIColor grayColor] delegate:self];
//    textView.backgroundColor = [UIColor yellowColor];
    textView.textField.placeholder = @"其他金额";
    textView.defaultIndex = 3;
    [self.view addSubview:textView];
    
    
}
-(void)DXFSingleView:(UIView *)DXFSingleView selectedView:(UIView *)selectedView andSelectedContent:(NSString *)selectedContent {

    NSLog(@"%@",selectedContent);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
