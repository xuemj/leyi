//
//  AppDelegate.h
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "Reachability.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NetworkStatus networkStatus;
    CTCallCenter *callCenter;
}

@property (strong, nonatomic) UIWindow *window;

@end

