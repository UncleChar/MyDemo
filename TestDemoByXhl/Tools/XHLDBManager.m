//
//  XHLDBManager.m
//  CacheFmdb
//
//  Created by LingLi on 15/11/20.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "XHLDBManager.h"
#import "FMDB.h"

@interface XHLDBManager ()

{

    FMDatabase     *_fmdb;//数据库成员变量
    NSLock         *_lock;
    NSMutableArray *_modelDataArr;
}

@end


@implementation XHLDBManager

static XHLDBManager *_db;

+(instancetype)shareManager {

    static dispatch_once_t predicate;//谓词
    dispatch_once(&predicate, ^{
        
        _db = [[XHLDBManager alloc]init];
    });
    return _db;
}

- (instancetype)initDBWithPath:(NSString *)path {

    if (self = [super init]) {
        
        _lock = [[NSLock alloc]init];
        
        _fmdb = [FMDatabase databaseWithPath:path];
        
        BOOL isOpen = [_fmdb open];
        if (isOpen) {
            
            TestLog(@"数据库打开成功");
            
        }else {
        
            TestLog(@"数据库打开失败");
        
        }
   
    }
    return self;

}

- (BOOL)isExistTableName:(NSString *)tableName {

    return [_fmdb tableExists:tableName];
    
}

- (void)createDBTableWithName:(NSString *)tableName { //这里封装一个属性，方便同一个方法创建多个表

    BOOL isExist = [self isExistTableName:tableName];
    
    if (!isExist) {
        

        if ([tableName isEqualToString:@"ModelInfo"]) {
            
            NSString *sqlStr =[NSString stringWithFormat:@"create table if not exists %@(name text ,account text,isFromChina text ,ppp text ,biggerData blod)",tableName] ;
            
            BOOL isSuccess = [_fmdb executeUpdate:sqlStr];
            if (isSuccess) {
                
                TestLog(@"创建成功modelTable表");
            }else {
            
                TestLog(@"创建modelTable表失败");
            }
        }
        
    }else    //用于数据库的升级（字段里可能有增减）
    {
        
        
        if ([tableName isEqualToString:@"ModelInfo"])
        {
            
            if ([_fmdb columnExists:@"ppp" inTableWithName:@"ModelInfo"] == YES)
            {
                NSLog(@"task表中存在ppp这个字段");
            }
            else
            {
                NSString *addStr =@"ALTER TABLE ModelInfo ADD COLUMN ppp text";
                [_fmdb executeUpdate:addStr];
            }
            
            
            
            if ([_fmdb columnExists:@"biggerData" inTableWithName:@"ModelInfo"] == YES)
            {
                NSLog(@"task表中存在biggerData这个字段");
            }
            else
            {
                NSString *addStr =@"ALTER TABLE ModelInfo ADD COLUMN biggerData blod";
                [_fmdb executeUpdate:addStr];
            }
        }
        
        
        
    }
    
    //设缓存 ，提效率
    [_fmdb setShouldCacheStatements:YES];

    
}

- (void)insertDBWithData:(id)data withTableName:(NSString *)tableName {

    
    [_lock lock];
    
    if ([tableName isEqualToString:@"ModelInfo"]) {
        
        TestModel *model = (TestModel *)data;
        NSString *insertSqlStr =[NSString stringWithFormat:@"insert into %@ values(?,?,?,?,?)",tableName] ;
        BOOL isSuccess = [_fmdb executeUpdate:insertSqlStr,model.name,model.account,model.isFromChina,model.ppp,model.biggerData];
        if (isSuccess) {
            
            TestLog(@"insert success");
        }else {
        
            TestLog(@"insert Faile");
        }
    }
    [_lock unlock];
   
}

- (TestModel *)searchDBWithModeID:(NSString *)ID withTableName:(NSString *)tableName {


    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where name = ?",tableName];
    
    FMResultSet *set = [_fmdb executeQuery:sqlStr,ID];

    while ([set next]) {
        
        TestModel *model = [[TestModel alloc]init];
        model.name = [set stringForColumnIndex:0];
        model.account = [set stringForColumnIndex:1];
        model.isFromChina = [set stringForColumnIndex:2];
        model.ppp = [set stringForColumnIndex:3];
        model.biggerData = [set dataForColumnIndex:4];
        
        return model;

    }
    
    
    return nil;

}
- (NSArray *)searchAllDataWithTableName:(NSString *)tableName {

   
    if (!_modelDataArr) {
        
        _modelDataArr = [NSMutableArray arrayWithCapacity:0];
        
    }else {
    
        [_modelDataArr removeAllObjects];
    }
    
    NSString *searchAllDataSqlStr =[NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet *set = [_fmdb executeQuery:searchAllDataSqlStr];
    while ([set next]) {
        
        TestModel *model = [[TestModel alloc]init];
        model.name = [set stringForColumnIndex:0];
        model.account = [set stringForColumnIndex:1];
        model.isFromChina = [set stringForColumnIndex:2];
        model.ppp = [set stringForColumnIndex:3];
        model.biggerData = [set dataForColumnIndex:4];
        
        [_modelDataArr addObject:model];
        
    }
    return _modelDataArr;
    

}

- (void)updataDBWithModel:(TestModel *)model withTableName:(NSString *)tableName {


    [_lock lock];
    
    NSString *sqlStr = [NSString stringWithFormat:@"update %@ set name = ? where account = ?",tableName];
    
    BOOL isSuccess = [_fmdb executeUpdate:sqlStr,@"我靠，我修改了",model.account];
    
    TestLog(@"%@",isSuccess ? @"成功":@"失败");
    
    [_lock unlock];
    
}

- (void)deleteDBWithSingleModelId:(NSString *)modelId withTableName:(NSString *)tableName {

    [_lock lock];
    
    NSString *deleSingleSqlStr = [NSString stringWithFormat:@"delete  from %@ where name = ?",tableName];
    
    BOOL isSuccess = [_fmdb executeUpdate:deleSingleSqlStr,modelId];
    
    TestLog(@"%@",isSuccess ? @"delete成功":@"delete失败");
    
    [_lock unlock];
    

}

- (void)clearBDWithTableName:(NSString *)tableName {

    [_lock lock];
    
    NSString *clearAllSqlStr = [NSString stringWithFormat:@"delete from %@",tableName];
    
    BOOL isSuccess = [_fmdb executeUpdate:clearAllSqlStr];
    
    TestLog(@"%@",isSuccess ? @"celar成功":@"clear失败");
    
    [_lock unlock];

}













@end
