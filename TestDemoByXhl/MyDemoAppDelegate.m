//
//  MyDemoAppDelegate.m
//  TestDemoByXhl
//
//  Created by LingLi on 15/11/24.
//  Copyright © 2015年 LingLi. All rights reserved.
//  umeng apppkey: c9f9363ffc1a

#import "MyDemoAppDelegate.h"
#import "CJNavigationController.h"//这里若是想要侧滑返回控制的效果需要window的跟控制器设置成此
#import "IndexViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"



#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

@interface MyDemoAppDelegate ()

@end


@implementation MyDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[CJNavigationController alloc]initWithRootViewController:[[IndexViewController alloc]init]];
    
    [self.window makeKeyAndVisible];
    
    [UMSocialData setAppKey:UMENGAPPKEY];
    [UMSocialWechatHandler setWXAppId:@"wx9eb43ab961821fa6" appSecret:@"8b8c24eda255105d4e27f8c03c7d2d0a" url:nil];
    [UMSocialQQHandler setQQWithAppId:@"100497871" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"www.baidu.com"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    
    
    
    
    
    
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    
    [ShareSDK registerApp:@"c9f9363ffc1a"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {

             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;

             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1985933773"
                                           appSecret:@"5b9dac3272c2b4314d39a82e139a9326"
                                         redirectUri:@"http://www.baidu.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
    
    
    return YES;




}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
