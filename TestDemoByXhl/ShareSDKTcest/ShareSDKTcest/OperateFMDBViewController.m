//
//  OperateFMDBViewController.m
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "OperateFMDBViewController.h"

@interface OperateFMDBViewController ()<ASIHTTPRequestDelegate>

{
    
    UIImageView      *_imageFromNetwork;
    XHLDBManager     *_db;
    NSData           *_receiveDataFromNetW;
    ASINetworkQueue  *_requestQuene;
    UIProgressView   *_requestProgress;
    long long         _size;
    NSMutableArray   *_receiveDataFromNetworkArr;
}

@end

@implementation OperateFMDBViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    _requestProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, 80, 200, 4)];
    _requestProgress.backgroundColor = [UIColor redColor];
    [self.view addSubview:_requestProgress];
    
    UIButton *downloadBtn = [ConfigUITools configButtonWithTitle:@"下载图片并存储本地(非FMDB)" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 100, 100, 200, 40) superView:self.view];
    downloadBtn.tag = 100 + 1;
    [downloadBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton *openFmdbBtn = [ConfigUITools configButtonWithTitle:@"用数据库并存储图片(下载)" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 100, 160, 200, 40) superView:self.view];
    openFmdbBtn.tag = 100 + 2;
    [openFmdbBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _imageFromNetwork = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 220, 100, 120)];
    _imageFromNetwork.backgroundColor = [UIColor lightGrayColor];
    _imageFromNetwork.layer.cornerRadius = 5;
    _imageFromNetwork.layer.masksToBounds = 1;
    [self.view addSubview:_imageFromNetwork];
    

    
    UIButton *showImgBtn = [ConfigUITools configButtonWithTitle:@"读数据库图片" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 100, 360, 90, 40) superView:self.view];
    showImgBtn.tag = 100 + 7;
    [showImgBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIButton *refreshBtn = [ConfigUITools configButtonWithTitle:@"刷新读缓存" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 + 10, 360, 90, 40) superView:self.view];
    refreshBtn.tag = 100 + 8;
    [refreshBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIButton *searchSingleBtn = [ConfigUITools configButtonWithTitle:@"查找数据库单个数据模型" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 100, 420, 200, 40) superView:self.view];
    searchSingleBtn.tag = 100 + 3;
    [searchSingleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *searchAllBtn = [ConfigUITools configButtonWithTitle:@"查找数据库所有数据模型" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 100, 480, 200, 40) superView:self.view];
    searchAllBtn.tag = 100 + 4;
    [searchAllBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIButton *updateSingleBtn = [ConfigUITools configButtonWithTitle:@"更新一个数据模型写入数据库" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 100, 540, 200, 40) superView:self.view];
    updateSingleBtn.tag = 100 + 5;
    [updateSingleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    UIButton *deleteAllBtn = [ConfigUITools configButtonWithTitle:@"清空数据库所有数据模型" color:[UIColor grayColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 100, 600, 200, 40) superView:self.view];
    deleteAllBtn.tag = 100 + 6;
    [deleteAllBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
 
    
    

    
    
}

- (void)btnClicked:(UIButton *)sender {

    if ([self checkDBIsOpen]) {
        
        switch (sender.tag - 100) {
            case 1:
            {
                
                NSMutableArray *imgUrlArr = [[NSMutableArray alloc]initWithCapacity:0];
                [imgUrlArr addObject:@"http://d.3987.com/ssjbz_121203/012.jpg"];
                [imgUrlArr addObject:@"http://image.tianjimedia.com/uploadImages/2012/206/VO7156D96KI1.jpg"];
                [imgUrlArr addObject:@"http://www.33.la/uploads/20130523tpxh/6816.jpg"];
                
                _requestQuene = [[ASINetworkQueue alloc]init];
                [_requestQuene setRequestDidFinishSelector:@selector(requestFinished:)];
                [_requestQuene setRequestDidFailSelector:@selector(requestFailed:)];
                [_requestQuene setQueueDidFinishSelector:@selector(queueFinished:)];
                [_requestQuene setDownloadProgressDelegate:_requestProgress];
                [_requestQuene setShowAccurateProgress:YES];//进度条精确显示
                [_requestQuene setDelegate:self];
                
                for (int i=0; i<3; i++) {
                    
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imgUrlArr[i]]];
                    request.tag = i + 888;
                    [request setDownloadProgressDelegate:self];
                    [_requestQuene addOperation:request];
                    
                    
                }
                
                [_requestQuene go];
                
            }
                
                break;
            case 2:
            { //初始化数据库，并存储一个数据
                
               
                
                if (_receiveDataFromNetworkArr.count > 0) {
                    
                    for (int i = 0 ;i < _receiveDataFromNetworkArr.count;i++) {
                        
                        TestModel *model = [[TestModel alloc]init];
                        
                        model.name = [NSString stringWithFormat:@"file_0%d",i]; //唯一ID
                        model.account = @"NO.221520";
                        model.isFromChina = @"0";
                        model.ppp = @"test";
                        model.biggerData = _receiveDataFromNetworkArr[i];
                        
                        [_db createDBTableWithName:@"ModelInfo"];
                        [_db insertDBWithData:model withTableName:@"ModelInfo"];
                        
                    }
                }
                
                
                
                
            }
                
                break;
            case 3:
            { //查询单个数据
                
                
                TestModel *receiveModel = [[TestModel alloc]init];
                receiveModel = [_db searchDBWithModeID:@"file_01" withTableName:@"ModelInfo"];
                
                NSLog(@"name :%@ /n account %@/n",receiveModel.name,receiveModel.account);
                
                
            }
                
                break;
            case 4:
            { //获取所有的按钮
                
                NSArray *receiceAllData = [NSArray array];
                receiceAllData = [_db searchAllDataWithTableName:@"ModelInfo"];
                
                for (TestModel *model in receiceAllData) {
                    
                    NSLog(@"name :%@  data ： %@",model.name,model.account);
                    
                    
                }
                
                
            }
                
                break;
                
            case 5:
            {
                
                TestModel *model = [[TestModel alloc]init];
                model.account = @"NO.003";
                
                [_db updataDBWithModel:model withTableName:@"ModelInfo"];
                
            }
                
                break;
            case 6:
            {
                
                //    [_db deleteDBWithSingleModelId:@"10001" withTableName:@"ModelInfo"];
                [_db clearBDWithTableName:@"ModelInfo"];
            }
                
                
                break;
            case 7:
            {
                
                TestModel *model = [_db searchDBWithModeID:@"file_01" withTableName:@"ModelInfo"];
                
                _imageFromNetwork.image = [UIImage imageWithData:model.biggerData];
                
            }
                
                
                break;
            case 8:
            {   //模拟刷新读取缓存
                
                _imageFromNetwork.image = nil;
                [SVProgressHUD showWithStatus:@"正在读取缓存" maskType:1];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // something
                    [NSThread sleepForTimeInterval:2.0];
                    
                    // 主线程执行刷新：
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // something
                        [SVProgressHUD dismiss];
                        TestModel *model = [_db searchDBWithModeID:@"file_00" withTableName:@"ModelInfo"];
                        
                        _imageFromNetwork.image = [UIImage imageWithData:model.biggerData];
                    });
                    
                });
                
                
            }
                
                break;
                
            default:
                break;
        }

        
    }else {
    
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DB is not open" message:@"open now ？" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                _db = [[XHLDBManager shareManager]initDBWithPath:[self getDBPath]];//打开数据库
            
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];

        
    
    }
    
    
    
    
    
    
    
    
}


#pragma ASI请求数据


- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{

    NSLog(@"ssss   %lld",bytes);
    
}


- (void)requestFinished:(ASIHTTPRequest *)request { //获取网络并实现吧图片存入沙盒，接着想设计好数据库存取数据，包括视频图片之类的所有文件
    
    NSData  *receiveData = [request responseData];
    
    if (nil == _receiveDataFromNetworkArr) {
        
        _receiveDataFromNetworkArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    
    [self createDirWithData:receiveData withFileName:[NSString stringWithFormat:@"%ld",request.tag]]; //把数据直接写入沙盒

    [_receiveDataFromNetworkArr addObject:receiveData];
    _receiveDataFromNetW = receiveData;

      NSLog(@"Value: %f", [_requestProgress progress]);
    
    
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    TestLog(@"Failed");
}


- (void)queueFinished:(ASINetworkQueue *)requestQuene {

                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下载完成" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
}





//获取应用沙盒根路径
-(void)dirHome{
    NSString *dirHome=NSHomeDirectory();
    NSLog(@"app_home: %@",dirHome);
}

- (NSString *)getDBPath {
    
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"Base.sqlite"];
    
    return testDirectory;
    
    
    
}


-(void )createDirWithData:(NSData *)data withFileName:(NSString *)fileName{
    
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"testCache"];
    // 创建目录
    BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSLog(@"文件夹-创建成功");
        [self createFileWithData:data withFileName:fileName];
    }else{
        NSLog(@"文件夹-创建失败");
    }
}

//创建文件
-(void )createFileWithData:(NSData *)data withFileName:(NSString *)fileName{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"testCache/images_%@.png",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL res=[fileManager createFileAtPath:testDirectory contents:data attributes:nil];
    
    if (res) {
        NSLog(@"文件创建成功:" );
    }else{
        NSLog(@"文件创建失败");}
}




//获取Documents目录
-(NSString *)dirDoc{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"apphomedoc: %@",documentsDirectory);
    return documentsDirectory;
}

- (BOOL)checkDBIsOpen {

    if (_db) {
        
        return YES;
    }else {
    
        return NO;
    }
    
}

@end
