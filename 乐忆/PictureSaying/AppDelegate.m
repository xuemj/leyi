
//
//  AppDelegate.m
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "BaseNaviagtionViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "FLViewController.h"
#import <UIKit/UIKit.h>
#import "GuideView.h"
#import "PSConfigs.h"
#import "MobClick.h"
#import "APService.h"
#import "DiscoveryViewController.h"
@interface AppDelegate ()<UIAlertViewDelegate>
{
    MainViewController *mainVC;
    NSDictionary *dic;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Add a custom read-only cache path
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CustomPathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] == 0) {
        
    }

    [self _initShare];
    BOOL BL = [self _judgeLogin];
   
    if(BL){
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/registerAndLogin/%@/%@",[tempDic objectForKey:@"usn"],@0];
        
        [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
            NSDictionary *dic1 = (NSDictionary *)result;
            if (dic1.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户信息更新失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                LeftViewController *leftVC = [[LeftViewController alloc] init];
                mainVC = [[MainViewController alloc] init];
                
                MMDrawerController *drawerController = [[MMDrawerController alloc]
                                                        initWithCenterViewController:mainVC
                                                        leftDrawerViewController:leftVC
                                                        rightDrawerViewController:nil];
                
                //设置左右菜单的宽度
                [drawerController setMaximumRightDrawerWidth:1];
                [drawerController setMaximumLeftDrawerWidth:240];
                
                //设置手势操作的有效区域MMOpenDrawerGestureModeAll：所有区域
                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                
                //配置管理动画的block
                [drawerController
                 setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                     MMDrawerControllerDrawerVisualStateBlock block;
                     block = [[MMExampleDrawerVisualStateManager sharedManager]
                              drawerVisualStateBlockForDrawerSide:drawerSide];
                     if(block){
                         block(drawerController, drawerSide, percentVisible);
                     }
                 }];
                
                self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                // Override point for customization after application launch.
                self.window.backgroundColor = [UIColor whiteColor];
                [self.window makeKeyAndVisible];
                self.window.rootViewController = drawerController;
            }else{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *userData = [NSJSONSerialization dataWithJSONObject:dic1 options:NSJSONWritingPrettyPrinted error:nil];
                [defaults setObject:userData forKey:@"MyUserInfo"];
                [[PSConfigs shareConfigs] loadUserInfo];
                LeftViewController *leftVC = [[LeftViewController alloc] init];
                
                mainVC = [[MainViewController alloc] init];
                
                MMDrawerController *drawerController = [[MMDrawerController alloc]
                                                        initWithCenterViewController:mainVC
                                                        leftDrawerViewController:leftVC
                                                        rightDrawerViewController:nil];
                
                //设置左右菜单的宽度
                [drawerController setMaximumRightDrawerWidth:1];
                [drawerController setMaximumLeftDrawerWidth:240];
                
                //设置手势操作的有效区域MMOpenDrawerGestureModeAll：所有区域
                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                
                //配置管理动画的block
                [drawerController
                 setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                     MMDrawerControllerDrawerVisualStateBlock block;
                     block = [[MMExampleDrawerVisualStateManager sharedManager]
                              drawerVisualStateBlockForDrawerSide:drawerSide];
                     if(block){
                         block(drawerController, drawerSide, percentVisible);
                     }
                 }];
                
                self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                // Override point for customization after application launch.
                self.window.backgroundColor = [UIColor whiteColor];
                [self.window makeKeyAndVisible];
                self.window.rootViewController = drawerController;
            }
        } failLoad:^(id result) {
            LeftViewController *leftVC = [[LeftViewController alloc] init];
            
            mainVC = [[MainViewController alloc] init];
            
            MMDrawerController *drawerController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:mainVC
                                                    leftDrawerViewController:leftVC
                                                    rightDrawerViewController:nil];
            
            //设置左右菜单的宽度
            [drawerController setMaximumRightDrawerWidth:1];
            [drawerController setMaximumLeftDrawerWidth:240];
            
            //设置手势操作的有效区域MMOpenDrawerGestureModeAll：所有区域
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            
            //配置管理动画的block
            [drawerController
             setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                 MMDrawerControllerDrawerVisualStateBlock block;
                 block = [[MMExampleDrawerVisualStateManager sharedManager]
                          drawerVisualStateBlockForDrawerSide:drawerSide];
                 if(block){
                     block(drawerController, drawerSide, percentVisible);
                 }
             }];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            // Override point for customization after application launch.
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
            self.window.rootViewController = drawerController;
        }];
    }else{
        FLViewController *flVC = [[FLViewController alloc] init];
        BaseNaviagtionViewController *nav = [[BaseNaviagtionViewController alloc] initWithRootViewController:flVC];
        self.window.rootViewController = nav;
        
    }
    [MobClick startWithAppkey:@"5504f742fd98c557c00004d4" reportPolicy:BATCH   channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    UIImage *theImage = [UIImage imageNamed:@"app.jpg"];
    [self saveImage:theImage WithName:@"app.jpg"];
    return YES;
}
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
   NSDictionary * userInfo = [notification userInfo];
   // NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
  //  NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的

    
    dic = extras;

}
-(BOOL)_judgeLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *loginDic = [defaults objectForKey:@"LoginDic"];
    if ([[loginDic allValues] count] == 0) {
        return YES;
    }else if([[loginDic objectForKey:@"LOGIN"] isEqual:@1]){
        return YES;
    }else{
        return YES;
     }
 
}

-(void)_initShare{
    [ShareSDK registerApp:@"4b2d9a4f1b3e"];
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    //连接微信
    [ShareSDK connectWeChatSessionWithAppId:@"wxf551d6b0b4995f75" appSecret:@"07b88fb89d66bf4e8297ff97deb86b7e" wechatCls:[WXApi class]];
    //连接微信朋友圈
//    [ShareSDK connectWeChatTimelineWithAppId:@"wxf551d6b0b4995f75" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatTimelineWithAppId:@"wxf551d6b0b4995f75" appSecret:@"07b88fb89d66bf4e8297ff97deb86b7e" wechatCls:[WXApi class]];
    //连接qq
    [ShareSDK connectQQWithQZoneAppKey:@"1103987471" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
   
    //连接qq空间
    [ShareSDK connectQZoneWithAppKey:@"1103987471" appSecret:@"axM1t2pSLsdJmXeE" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"1074777335"
                               appSecret:@"64ed752fb0e50e05be1db46e5010f92f"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"1074777335"
                                appSecret:@"64ed752fb0e50e05be1db46e5010f92f"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
    //连接短信
    [ShareSDK connectSMS];
    //连接复制
    [ShareSDK connectCopy];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

//UIApplication:setApplicationIconBadgeNumber

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    
}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (dic.count>0) {
    NSString *s = [dic objectForKey:@"value"];
    if ([s isEqualToString:@"eventId"] || [s isEqualToString:@"storyId"]) {
        mainVC.selectedIndex = 3;
        NSString *num = [dic objectForKey:@"type"];
        int a = [num intValue];
        DiscoveryViewController *controller =  [mainVC.childViewControllers objectAtIndex:3];
        controller.mainSV.contentOffset = CGPointMake(KScreenWidth*a, 0);

    }
    else if([[dic objectForKey:@"type"] isEqualToString:@"100"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"因违反用户协议并遭到用户举报,你的设备已被封禁,请到 http://immomo.com/my 自助查询并申请解封." delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
       
    }
    }
    callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"canceling" object:nil];
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
         
            [[NSNotificationCenter defaultCenter] postNotificationName:@"calling" object:nil];
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
          
            [[NSNotificationCenter defaultCenter] postNotificationName:@"calling" object:nil];
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
         
            [[NSNotificationCenter defaultCenter] postNotificationName:@"calling" object:nil];
        }
        else  
        {  
         
            [[NSNotificationCenter defaultCenter] postNotificationName:@"canceling" object:nil];
        }
    };
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginDic"]];
      
        [loginDic setObject:@NO forKey:@"LOGIN"];
        [defaults setObject:loginDic forKey:@"LoginDic"];
        FLViewController *FLDENGLU = [[FLViewController alloc] init];
        FLDENGLU.isFirstIn = @"no";
        BaseNaviagtionViewController *NAV = [[BaseNaviagtionViewController alloc] initWithRootViewController:FLDENGLU];
        self.window.rootViewController = NAV;
    }

}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
