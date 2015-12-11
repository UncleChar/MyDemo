//
//  TestShareController.m
//  TestDemoByXhl
//  http://wiki.mob.com/ios简洁版快速集成/
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//

#import "TestShareController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "UMSocial.h"
//#import "UMSocial.h"

@interface TestShareController ()

@end

@implementation TestShareController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [
    self.view.backgroundColor = [UIColor greenColor];
    UIButton *shareBtn = [ConfigUITools configButtonWithTitle:@"share分享" color:[UIColor whiteColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 50, 100, 100, 40) superView:self.view];
    shareBtn.tag = 100 + 1;
    [shareBtn addTarget:self action:@selector(beginShare:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *umengBtn = [ConfigUITools configButtonWithTitle:@"uMeng分享" color:[UIColor whiteColor] fontSize:14 frame:CGRectMake(SCREEN_WIDTH / 2 - 50, 160, 100, 40) superView:self.view];
    umengBtn.tag = 100 + 2;
    [umengBtn addTarget:self action:@selector(beginShare:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)beginShare:(UIButton *)sender {


    switch (sender.tag - 100) {
        case 1:
        {
        
            //1、创建分享参数
            
            NSArray* imageArray = @[[UIImage imageNamed:@"icon.png"]];
            // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:@"http://mob.com"]
                                                  title:@"分享标题"
                                                   type:SSDKContentTypeAuto];
                //2、分享（可以弹出我们的分享菜单和编辑界面）
                [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                         items:nil
                                   shareParams:shareParams
                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                               
                               switch (state) {
                                   case SSDKResponseStateSuccess:
                                   {
                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                           message:nil
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"确定"
                                                                                 otherButtonTitles:nil];
                                       [alertView show];
                                       break;
                                   }
                                   case SSDKResponseStateFail:
                                   {
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil, nil];
                                       [alert show];
                                       break;
                                   }
                                   default:
                                       break;
                               }
                               
                           }];
                
            }

        }
            break;
        case 2:
        {
            [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
            

            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UMENGAPPKEY
                                              shareText:@"你要分享的文字"
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                               delegate:self];
        }
            break;
            
        default:
            break;
    }
            
    

}
@end
