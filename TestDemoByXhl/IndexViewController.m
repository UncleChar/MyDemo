//
//  IndexViewController.m
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "IndexViewController.h"
#import "ConfigUITools.h"
#import "TestShareController.h"
#import "OperateFMDBViewController.h"

#define kBtnColor [UIColor colorWithRed:103.0/255.0 green:203.0/255.0 blue:249.0/255.0 alpha:0.75]

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
      //测试分享功能的demo按钮
    UIButton *shareDemoBtn = [ConfigUITools configButtonWithTitle:@"shareDemo" color:kBtnColor fontSize:13 frame:CGRectMake(40, 100, 100, 40) superView:self.view];
    [shareDemoBtn addTarget:self action:@selector(testBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    shareDemoBtn.tag = 1000 + 1;

    //测试FMDB存储数据的demo按钮
    UIButton *storeDemoBtn = [ConfigUITools configButtonWithTitle:@"FMDBDemo" color:kBtnColor fontSize:13 frame:CGRectMake(40, 160, 100, 40) superView:self.view];
    [storeDemoBtn addTarget:self action:@selector(testBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    storeDemoBtn.tag = 1000 + 2;
    
}


#pragma mark - shareDemoBtnClicked
- (void)testBtnClicked:(UIButton *)sender {

    switch (sender.tag - 1000) {
        case 1:
        {
            TestShareController *testShareVC = [[TestShareController alloc]init];
            [self.navigationController pushViewController:testShareVC animated:YES];
            
        }
            break;
        case 2:
        {
            OperateFMDBViewController *testFMDBVC = [[OperateFMDBViewController alloc]init];
            [self.navigationController pushViewController:testFMDBVC animated:YES];
            
        }
            break;
        case 3:
        {
            TestShareController *testShareVC = [[TestShareController alloc]init];
            [self.navigationController pushViewController:testShareVC animated:YES];
            
        }
            break;
        default:
            break;
    }
    
    
    

}







@end
