//
//  TestModel.h
//  CacheFmdb
//
//  Created by LingLi on 15/11/20.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, strong)   NSString *name;
@property (nonatomic, strong)   NSString *account;
@property (nonatomic, assign)   NSString *isFromChina;
@property (nonatomic, assign)   NSString *ppp;
@property (nonatomic, strong)   NSData   *biggerData;


@end
