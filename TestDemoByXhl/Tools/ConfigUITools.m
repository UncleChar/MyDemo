//
//  ConfigUITools.m
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "ConfigUITools.h"

@implementation ConfigUITools

//初始化index控制器的诸多按钮
+ (UIButton *)configButtonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)size frame:(CGRect)frame superView:(UIView *)superView {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = color;
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:0];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = 1;
    [superView addSubview:btn];
    
    return btn;


}

@end
