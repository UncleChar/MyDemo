//
//  MyDemo.h
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//
#import "ConfigUITools.h"
#import "XHLDBManager.h"
#import "TestModel.h"



#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#define UMENGAPPKEY @"55795b6567e58e05e8000191"


#import "SVProgressHUD.h"
#ifdef DEBUG
#define TestLog(...) NSLog(__VA_ARGS__)
#else
#define TestLog(...)
#endif

//获取屏幕 宽度、高度
#define SCREEN_FRAME [UIScreen mainScreen].applicationFrame


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


