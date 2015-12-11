//
//  XHLDBManager.h
//  CacheFmdb
//
//  Created by LingLi on 15/11/20.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TestModel;

@interface XHLDBManager : NSObject

+ (instancetype)shareManager;


- (instancetype)initDBWithPath:(NSString *)path;

- (BOOL)isExistTableName:(NSString *)tableName;

- (void)createDBTableWithName:(NSString *)tableName;

- (void)insertDBWithData:(id)data withTableName:(NSString *)tableName;

- (TestModel *)searchDBWithModeID:(NSString *)ID withTableName:(NSString *)tableName;

//searahAllData

- (NSArray *)searchAllDataWithTableName:(NSString *)tableName;

- (void)updataDBWithModel:(TestModel *)model withTableName:(NSString *)tableName;

- (void)deleteDBWithSingleModelId:(NSString *)modelId withTableName:(NSString *)tableName;

- (void)clearBDWithTableName:(NSString *)tableName;
@end
