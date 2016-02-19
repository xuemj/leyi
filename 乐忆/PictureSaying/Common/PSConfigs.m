//
//  PSConfigs.m
//  PictureSaying
//
//  Created by shixy on 15/1/8.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "PSConfigs.h"
#import <sys/utsname.h>
#import "UIView+Additions.h"
#import "AppDelegate.h"
//#import "JSONKit.h"
#import "NSString+Additions.h"
#import "MainViewController.h"
NSString *const kPSLikeStatusChangeNotification = @"kPSLikeStatusChangeNotification";

static PSConfigs *_configs = nil;

@implementation PSConfigs

+(PSConfigs *)shareConfigs
{
    if (!_configs)
    {
        _configs = [[PSConfigs alloc] init];
    }
    return _configs;
}

+(enum IphoneType)getIphoneType
{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([machineName rangeOfString:@"iPhone"].length > 0)
    {
        return [machineName substringWithRange:NSMakeRange(6, 1)].intValue;
    }
    else
    {
        return IphoneType_4s;
    }
}

-(void)loadUserInfo
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:kMyUserInfo];
        if (tempUserData != nil)
        {
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
         //   ITLog(tempDic);
            self.userid = tempDic[kId];
            self.usn = tempDic[kUsn];
            self.nickname = tempDic[kNickname];
            self.image = tempDic[kImage];
        }
    });
}

+(UIView *)lineViewWithWidth:(CGFloat)width withY:(CGFloat)y
{
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 0.5)];
    lineV.backgroundColor = rgb1(221, 221, 221);
    return lineV;
}

+(BOOL)showProgressWithError:(NSError *)error withView:(UIView *)view operationResponseString:(NSString *)responseString delayShow:(BOOL)delayShow isImage:(BOOL)isImage
{
    [view hideProgressHUDWithAnimated:YES];
    [view hideLoading];
    NSString *showString = @"请确认网络连接";
    if ([error.localizedDescription respondsToSelector:@selector(rangeOfString:)])
    {
        if ([error.localizedDescription rangeOfString:@"网络连接已中断"].location != NSNotFound
            || [error.localizedDescription rangeOfString:@"请求超时"].location != NSNotFound)
        {
            [view showProgressHUDSuccessWithLabelText:error.localizedDescription withAfterDelayHide:1.0];
            return YES;
        }
        else if ([error.localizedDescription rangeOfString:@"似乎已断开与互联网的连接"].location != NSNotFound || [error.localizedDescription rangeOfString:@"国际漫游目前已关闭"].location != NSNotFound || [error.localizedDescription rangeOfString:@"未能找到使用指定主机名的服务器"].location != NSNotFound)
        {
            if (delayShow)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [view showProgressHUDSuccessWithLabelText:showString withAfterDelayHide:1.0];
                });
            }
            else
            {
                [view showProgressHUDSuccessWithLabelText:showString withAfterDelayHide:1.0];
            }
            
            return YES;
        }
        else if ([error.localizedDescription rangeOfString:@"The operation couldn’t be completed"].location != NSNotFound)
        {
           showString = @"操作不能完成";
            if (isImage)
            {
               showString = @"图片加载失败";
            }
            if (delayShow)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [view showProgressHUDSuccessWithLabelText:showString withAfterDelayHide:1.0];
                });
            }
            else
            {
                [view showProgressHUDSuccessWithLabelText:showString withAfterDelayHide:1.0];
            }
            
            return YES;
        }
    }
    return NO;
}

#pragma mark -shareAction
-(void)shareActionWithFromViewController:(UIViewController *)viewController withObject:(NSObject *)obj
{
    self.obj = obj;
    _shareViewController = viewController;
    self.url = [NSString stringWithFormat:@"http://share.wetime.cn/story.html?storyId=%@&",self.sid];
    NSLog(@"%@",self.url);
    UIView *shareSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    shareSuperView.backgroundColor = [UIColor clearColor];
    shareSuperView.tag = kShareSuperViewTag;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    bgView.backgroundColor = [UIColor darkGrayColor];
    bgView.alpha = 0.3;
    UIWindow *window = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
    [window addSubview:shareSuperView];
    [shareSuperView addSubview:bgView];
    
    //1.  创建手势对象
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cacel:)];
    //2. 设置相关属性
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    //3. 将手势对象加入到需要识别手势的视图
    [bgView addGestureRecognizer:tapGR];
    
    NSArray *imageNames = @[@"微信",@"朋友圈",@"QQ",@"空间",@"微博",@"信息",@"复制链接",@"广场"];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight,KScreenWidth , 220)];
    shareView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    float lineWith = KScreenWidth/13;
    float lineHeight = 30;
     MainModel *shareModol = (MainModel *)self.obj;
    for (int i1 = 0; i1<8; i1++) {
        if (i1<4) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((lineWith*i1)*3+lineWith, lineHeight*0.7,lineWith*2 ,lineHeight*2.1);
            [but setImage:[UIImage imageNamed:imageNames[i1]] forState:UIControlStateNormal];
            but.tag = i1+1;
            [but addTarget:self action:@selector(line1:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:but];
            
        }else{
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((lineWith*(i1-4))*3+lineWith,lineHeight*3.1 ,lineWith*2 ,lineHeight*2.1);
            [but setImage:[UIImage imageNamed:imageNames[i1]] forState:UIControlStateNormal];
            but.tag = i1+1;
            if (but.tag == 8) {
                if ([shareModol.visible isEqual:@0]) {
                    but.enabled = NO;
                }
            }
            [but addTarget:self action:@selector(line2:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:but];
        }
        
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    shareView.frame = CGRectMake(0,KScreenHeight-220 , KScreenWidth, 220);
    [UIView commitAnimations];
    shareView.tag = kShareViewTag;
    [window addSubview:shareView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,170 , KScreenWidth, 0.5)];
    imageView.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    [shareView addSubview:imageView];
    
    UIButton *cacelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cacelButton.frame = CGRectMake(0,190 ,KScreenWidth , lineHeight*0.6);
    
    [cacelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cacelButton setTitleColor:[UIColor colorWithRed:35/255.0 green:180/255.0 blue:238/255.0 alpha:1] forState:UIControlStateNormal];
    [cacelButton addTarget:self action:@selector(cacel:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cacelButton];
}
-(void)shareActionWithFromViewController:(UIViewController *)viewController
{
   self.url = [NSString stringWithFormat:@"http://share.wetime.cn/index.html?itemId=%@&",self.sid];
    _shareViewController = viewController;
    UIView *shareSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    shareSuperView.backgroundColor = [UIColor clearColor];
    shareSuperView.tag = kShareSuperViewTag;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    bgView.backgroundColor = [UIColor darkGrayColor];
    bgView.alpha = 0.3;
    UIWindow *window = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
    [window addSubview:shareSuperView];
    [shareSuperView addSubview:bgView];
    
    //1.  创建手势对象
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cacel:)];
    //2. 设置相关属性
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    //3. 将手势对象加入到需要识别手势的视图
    [bgView addGestureRecognizer:tapGR];
    NSArray *imageNames = @[@"微信",@"朋友圈",@"QQ",@"空间",@"微博",@"信息",@"复制链接"];
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight,KScreenWidth , 220)];
    shareView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    float lineWith = KScreenWidth/13;
    float lineHeight = 30;
    for (int i1 = 0; i1<7; i1++) {
        if (i1<4) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((lineWith*i1)*3+lineWith, lineHeight*0.7,lineWith*2 ,lineHeight*2.1);
            [but setImage:[UIImage imageNamed:imageNames[i1]] forState:UIControlStateNormal];
            but.tag = i1+1;
            [but addTarget:self action:@selector(line1:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:but];
                
        }else{
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((lineWith*(i1-4))*3+lineWith,lineHeight*3.1 ,lineWith*2 ,lineHeight*2.1);
            [but setImage:[UIImage imageNamed:imageNames[i1]] forState:UIControlStateNormal];
            but.tag = i1+1;
            [but addTarget:self action:@selector(line2:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:but];
            }
            
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
        shareView.frame = CGRectMake(0,KScreenHeight-220 , KScreenWidth, 220);
        [UIView commitAnimations];
        shareView.tag = kShareViewTag;
        [window addSubview:shareView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,170, KScreenWidth, 0.5)];
        imageView.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        [shareView addSubview:imageView];
        
        UIButton *cacelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cacelButton.frame = CGRectMake(0,190 ,KScreenWidth , lineHeight*0.6);
        
        [cacelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cacelButton setTitleColor:[UIColor colorWithRed:35/255.0 green:180/255.0 blue:238/255.0 alpha:1] forState:UIControlStateNormal];
        [cacelButton addTarget:self action:@selector(cacel:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:cacelButton];


}
-(void)cacel:(UIButton*)sender
{
    [self viewDown];
}
-(void)viewDown
{

    UIWindow *window = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
    UIView *shareSuperView = [window viewWithTag:kShareSuperViewTag];
    
    UIView *shareView = [window viewWithTag:kShareViewTag];
    [UIView animateWithDuration:0.35 animations:^{
        shareView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 220);
    } completion:^(BOOL finished) {
        [shareSuperView removeFromSuperview];
        [shareView removeFromSuperview];
    }];
    self.obj = nil;

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
      
        MainViewController *mainVC = (MainViewController *)_shareViewController.parentViewController.parentViewController;
        mainVC.selectedIndex = 3;
        [self viewDown];
    }
    else  {
        [self viewDown];
    }
}

-(void)line1:(UIButton*)sender
{
    switch (sender.tag ) {
        case 1:{
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                               defaultContent:@""
                                                        image:[ShareSDK imageWithUrl:self.image]
                                                        title:self.title
                                                          url:self.url
                                               description:NSLocalizedString(@"一起分享吧", @"乐忆")
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            ///////////////////////
            //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
            
            //定制微信好友信息
            [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                                 content:INHERIT_VALUE
                                                   title:NSLocalizedString(self.title, @"乐忆")
                                                     url:INHERIT_VALUE
                                                   image:INHERIT_VALUE
                                            musicFileUrl:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil];
            
            //结束定制信息
            ////////////////////////
            
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeWeixiSession
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      
                                      if (state == SSPublishContentStateSuccess)
                                      {
                                
                                      }
                                      else if (state == SSPublishContentStateFail)
                                      {
                                        
                                      }
                                  }];
        }
            
            break;
        case 2:
            //定制微信朋友圈空间信息
        {
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                               defaultContent:@""
                                                        image:[ShareSDK imageWithUrl:self.image]
                                                        title:self.title
                                                          url:self.url
                                                  description:NSLocalizedString(@"我正在使用乐忆分享,很方便,你也试试吧", @"乐忆")
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSShareViewStyleAppRecommend]
                                                  content:INHERIT_VALUE
                                                    title:NSLocalizedString(self.title, @"乐忆")
                                                      url:self.url
                                               thumbImage:[ShareSDK imageWithUrl:self.image]
                                                    image:INHERIT_VALUE
                                             musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
                                                  extInfo:nil
                                                 fileData:nil
                                             emoticonData:nil];
            
            
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeWeixiTimeline
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      
                                      if (state == SSPublishContentStateSuccess)
                                      {
                                         
                                      }
                                      else if (state == SSPublishContentStateFail)
                                      {
                                       
                                      }
                                  }];
        }
            
            break;
        case 3:
        {
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                               defaultContent:@""
                                                        image:[ShareSDK imageWithUrl:self.image]
                                                        title:self.title
                                                          url:self.url
                                                  description:NSLocalizedString(@"一起分享吧", @"乐忆")
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            ///////////////////////
            //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
            
            //定制QQ分享信息
            [publishContent addQQUnitWithType:INHERIT_VALUE
                                      content:INHERIT_VALUE
                                        title:self.title
                                          url:INHERIT_VALUE
                                        image:INHERIT_VALUE];
            
            
            //        //结束定制信息
            //        ////////////////////////
            
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeQQ
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      
                                      if (state == SSPublishContentStateSuccess)
                                      {
                                    
                                      }
                                      else if (state == SSPublishContentStateFail)
                                      {
                            
                                      }
                                  }];
        }
            
            break;
        case 4:
        {
        
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                               defaultContent:@""
                                                        image:[ShareSDK imageWithUrl:self.image]
                                                        title:self.title
                                                          url:self.url
                                                  description:NSLocalizedString(@"我正在使用乐忆分享,很方便,你也来试试吧", @"乐忆分享")
                                                    mediaType:SSPublishContentMediaTypeNews];
            [publishContent addQQSpaceUnitWithTitle:NSLocalizedString(self.title, @"乐忆")
                                                url:INHERIT_VALUE
                                               site:nil
                                            fromUrl:nil
                                            comment:INHERIT_VALUE
                                            summary:INHERIT_VALUE
                                              image:INHERIT_VALUE
                                               type:INHERIT_VALUE
                                            playUrl:nil
                                               nswb:nil];
            
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeQQSpace
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      
                                      if (state == SSPublishContentStateSuccess)
                                      {
            
                                      }
                                      else if (state == SSPublishContentStateFail)
                                      {
                                        
                                      }
                                  }];
            
        }
            
            break;
        default:
            break;
    }
    
}
-(void)line2:(UIButton*)sender
{
     NSString *content = [NSString stringWithFormat:@"%@%@",self.title,self.url];
   
    switch (sender.tag) {
        case 5:
        {
            [self cacel:nil];
//            MyViewController *mvc = [[MyViewController alloc] init];
//            [_shareViewController.navigationController pushViewController:mvc animated:YES];
           
            
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:@"分享"
                                                        image:[ShareSDK imageWithUrl:self.image]
                                                        title:self.title
                                                          url:@"https://api.weibo.com/oauth2/default.html"
                                                  description:@"我的分享"
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent type:ShareTypeSinaWeibo authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            }];
            
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"分享微博成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case 6:{
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:@"www.wetime.cn"
                                                        image:[ShareSDK imageWithUrl:self.image]
                                                        title:self.title
                                                          url:self.url
                                                  description:NSLocalizedString(@"一起来分享吧", @"乐忆")
                                                    mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK shareContent:publishContent type:ShareTypeSMS authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            }];
        }
            break;
        case 7:{
            
//            NSString *content = [NSString stringWithFormat:@"%@%@",self.title,self.url];
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:content
                                               defaultContent:@"www.wetime.cn"
                                                        image:[ShareSDK imageWithPath:self.image]
                                                        title:self.title
                                                          url:@"www.wetime.cn"
                                                  description:NSLocalizedString(@"我正在使用乐忆分享", @"乐忆")
                                                    mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK shareContent:publishContent type:ShareTypeCopy authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                
            }];
        }
            break;
          case 8:
            if (self.obj) {
                {
                   MainModel *shareModol = (MainModel *)self.obj;
                    NSString *urlString = @"/WeiXiao/api/v1/story/edit";
                    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
                    [dicc setObject:shareModol.image forKey:@"image"];
                    [dicc setObject:shareModol.sid forKey:@"id"];
                    [dicc setObject:shareModol.originalTime forKey:@"time"];
                    [dicc setObject:@0 forKey:@"newFlag"];
                    [dicc setObject:@0 forKey:@"visible"];
                    [dicc setObject:shareModol.descrip forKey:@"description"];
                    [dicc setObject:_nickname forKey:@"nickname"];
                    [dicc setObject:@0 forKey:@"source"];
                    [dicc setObject:@0 forKey:@"status"];
                   // [dicc setObject:shareModol.i forKey:@"templateId"];
                    [dicc setObject:shareModol.title forKey:@"title"];
                    [dicc setObject:_userid forKey:@"userId"];
                    [dicc setObject:_usn forKey:@"usn"];
                    [dicc setObject:@0 forKey:@"visible"];
                    
                    NSDictionary *headerDic = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json; encoding=utf-8",@"Content-Type",@"application/json",@"Accept", nil];
                    
                    [DataService requestWithURL:urlString params:dicc requestHeader:headerDic httpMethod:@"POST" block:^(NSObject *result) {
                        
                        
                    } failLoad:^(id result) {
                        
                    }];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲,发布成功" message:@"快去广场看看吧~" delegate:self cancelButtonTitle:@"前往广场" otherButtonTitles:@"留在这里",nil];
                    [alert show];
                    
                }
                break;
            }
        default:
            
            break;
    }
    
    
    
}

#pragma mark -likeAction
//-(void)likeActionWithType:(enum likeType)type withZanButton:(UIButton *)zanButton withZanLabel:(UILabel *)zanLabel withIndexModel:(IndexModel *)indexModel withEventModel:(EventModel *)eventModel
//{
//    NSString *urlstring = nil;
//    
//    NSString *storyId = indexModel.sid;
//    if (indexModel.sid.length == 0)
//    {
//        storyId = indexModel.storyId;
//    }
//    
//    switch (type)
//    {
//        case likeType_Story:
//        {
//            if ([indexModel.isZan isEqualToString:@"0"])
//            {
//                indexModel.isZan = @"-1";
//                
//                NSInteger zanCount = [zanLabel.text integerValue];
//                indexModel.zanCount = [NSString stringWithFormat:@"%d",zanCount-1];
//                
//                zanLabel.text = [NSString stringWithFormat:@"%d",zanCount-1];
//                zanButton.selected = NO;
//                
//            }
//            else
//            {
//                indexModel.isZan = @"0";
//                
//                NSInteger zanCount = [zanLabel.text integerValue];
//                indexModel.zanCount = [NSString stringWithFormat:@"%d",zanCount+1];
//                
//                zanLabel.text = [NSString stringWithFormat:@"%d",zanCount+1];
//                zanButton.selected = YES;
//            }
//            urlstring = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@%@",storyId,[indexModel.isZan isEqualToString:@"0"]?@"":_usn,[indexModel.isZan isEqualToString:@"0"]?@"":@"/del"];
//        }
//            break;
//        case likeType_Event:
//        {
//            if ([eventModel.isZan isEqualToString:@"0"])
//            {
//                eventModel.isZan = @"-1";
//                
//                NSInteger zanCount = [zanLabel.text integerValue];
//                eventModel.favNum = [NSString stringWithFormat:@"%d",zanCount-1];
//                
//                zanLabel.text = [NSString stringWithFormat:@"%d",zanCount-1];
//                zanButton.selected = NO;
//                
//            }
//            else
//            {
//                eventModel.isZan = @"0";
//                
//                NSInteger zanCount = [zanLabel.text integerValue];
//                eventModel.favNum = [NSString stringWithFormat:@"%d",zanCount+1];
//                
//                zanLabel.text = [NSString stringWithFormat:@"%d",zanCount+1];
//                zanButton.selected = YES;
//            }
//            urlstring = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav/%@%@",storyId,eventModel.eventId,[eventModel.isZan isEqualToString:@"0"]?@"":_usn,[eventModel.isZan isEqualToString:@"0"]?@"":@"/del"];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    k.values = @[@(0.1),@(1.0),@(2.0),@(3.0),@(4.0)];
//    k.keyTimes = @[@(0.0),@(0.5),@(1.0),@(1.5),@(2.0)];
//    k.calculationMode = kCAAnimationLinear;
//    [zanButton.layer addAnimation:k forKey:@"SHOW"];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:_usn forKey:@"accountUsn"];
//    [DataService requestWithURL:urlstring params:params httpMethod:@"POST" block1:^(id result) {
//        
////        NSString *isZan = [[result objectForKey:@"value"] stringValue];
////        switch (type)
////        {
////            case likeType_Story:
////            {
////                if (![isZan isEqualToString:indexModel.isZan])
////                {
////                    
////                }
////            }
////                break;
////            case likeType_Event:
////            {
////                
////            }
////                break;
////                
////            default:
////                break;
////        }
//        
//        NSArray *array = [NSArray arrayWithObjects:indexModel,((eventModel == nil)?[NSNull null]:eventModel),[NSNumber numberWithInt:type], nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kPSLikeStatusChangeNotification object:array];
//    } failLoad:^(id result) {
//        
//    }];
//}

-(void)likeActionWithType:(enum likeType)type withZanButton:(UIButton *)zanButton withIndexModel:(MainModel *)indexModel withEventModel:(EventModel *)eventModel
{
    NSString *urlstring = nil;
    
    NSString *storyId = indexModel.sid;
    if (indexModel.sid.length == 0)
    {
        storyId = indexModel.storyId;
    }
    
    switch (type)
    {
        case likeType_Story:
        {
            if ([indexModel.isZan isEqualToString:@"0"])
            {
                indexModel.isZan = @"-1";
                
                NSInteger zanCount = [[zanButton titleForState:UIControlStateSelected] integerValue];
                indexModel.zanCount = [NSString stringWithFormat:@"%d",zanCount-1];
                if ([indexModel.zanCount isEqualToString:@"0"]) {
                    [zanButton setTitle:@"" forState:UIControlStateNormal];

                }else{
                    [zanButton setTitle:[NSString stringWithFormat:@" %d",zanCount-1] forState:UIControlStateNormal];
                }
                zanButton.selected = NO;
                
            }
            else
            {
                indexModel.isZan = @"0";
                
                NSInteger zanCount = [[zanButton titleForState:UIControlStateNormal] integerValue];
                indexModel.zanCount = [NSString stringWithFormat:@"%d",zanCount+1];
                
                [zanButton setTitle:[NSString stringWithFormat:@" %d",zanCount+1] forState:UIControlStateSelected];
                zanButton.selected = YES;
            }
            urlstring = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@%@",storyId,[indexModel.isZan isEqualToString:@"0"]?@"":_usn,[indexModel.isZan isEqualToString:@"0"]?@"":@"/del"];
        }
            break;
        case likeType_Event:
        {
            if (indexModel != nil) {
                if ([indexModel.isZan isEqualToString:@"0"])
                {
                    indexModel.isZan = @"-1";
                    NSInteger zanCount = [[zanButton titleForState:UIControlStateSelected] integerValue];
                    indexModel.zanCount = [NSString stringWithFormat:@"%d",zanCount-1];
                    if ([indexModel.zanCount isEqualToString:@"0"]) {
                        [zanButton setTitle:@"" forState:UIControlStateNormal];
                    }else{
                        [zanButton setTitle:[NSString stringWithFormat:@" %d",zanCount-1] forState:UIControlStateNormal];
                    }
                    
                    zanButton.selected = NO;
                    
                }
                else
                {
                    indexModel.isZan = @"0";
                    NSInteger zanCount = [[zanButton titleForState:UIControlStateNormal] integerValue];
                    eventModel.favNum = [NSString stringWithFormat:@"%d",zanCount+1];
                    
                    [zanButton setTitle:[NSString stringWithFormat:@" %d",zanCount+1] forState:UIControlStateSelected];
                    zanButton.selected = YES;
                }
            }else{
                if ([eventModel.isZan isEqualToString:@"0"])
                {
                    eventModel.isZan = @"-1";
                    NSInteger zanCount = [[zanButton titleForState:UIControlStateSelected] integerValue];
                    eventModel.favNum = [NSString stringWithFormat:@"%d",zanCount-1];
                    if ([eventModel.favNum isEqualToString:@"0"]) {
                        [zanButton setTitle:@"" forState:UIControlStateNormal];
                    }else{
                        [zanButton setTitle:[NSString stringWithFormat:@" %d",zanCount-1] forState:UIControlStateNormal];
                    }                    zanButton.selected = NO;
                    
                }
                else
                {
                    eventModel.isZan = @"0";
                    NSInteger zanCount = [[zanButton titleForState:UIControlStateNormal] integerValue];
                    eventModel.favNum = [NSString stringWithFormat:@"%d",zanCount+1];
                    
                    [zanButton setTitle:[NSString stringWithFormat:@" %d",zanCount+1] forState:UIControlStateSelected];
                    zanButton.selected = YES;
                }
            }
            
            if (indexModel != nil) {
                urlstring = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav/%@%@",indexModel.storyId,indexModel.itemId,[indexModel.isZan isEqualToString:@"0"]?@"":_usn,[indexModel.isZan isEqualToString:@"0"]?@"":@"/del"];
            }else{
                urlstring = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav/%@%@",eventModel.storyId,eventModel.eventId,[eventModel.isZan isEqualToString:@"0"]?@"":_usn,[eventModel.isZan isEqualToString:@"0"]?@"":@"/del"];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(2.0),@(3.0),@(4.0)];
    k.keyTimes = @[@(0.0),@(0.5),@(1.0),@(1.5),@(2.0)];
    k.calculationMode = kCAAnimationLinear;
    [zanButton.layer addAnimation:k forKey:@"SHOW"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_usn forKey:@"accountUsn"];
    [DataService requestWithURL:urlstring params:params httpMethod:@"POST" block1:^(id result) {
        NSArray *array = [NSArray arrayWithObjects:indexModel,((eventModel == nil)?[NSNull null]:eventModel),[NSNumber numberWithInt:type], nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPSLikeStatusChangeNotification object:array];
    } failLoad:^(id result) {
        
    }];
}

+(UIImage *)getImageWithRemark:(NSString *)remark
{
    NSArray *array = [NSArray arrayWithObjects:@"爸爸",@"妈妈",@"姥姥",@"姥爷",@"爷爷",@"奶奶", nil];
    for (NSString *tmp in array)
    {
        if ([remark isEqualToString:tmp])
        {
            return [UIImage imageNamed:remark];
        }
    }
    return nil;
}

+(NSString *)getImageUrlPrefixWithSourcePath:(NSString *)path
{
    NSString *item1 = @".png";
    NSString *item2 = @".jpg";
    NSString *item3 = @".jpeg";
    NSString *item4 = @".gif";
    if ([path rangeOfString:item1].length > 0)
    {
        return [path substringToIndex:[path rangeOfString:item1].location];
    }
    else if ([path rangeOfString:item2].length > 0)
    {
        return [path substringToIndex:[path rangeOfString:item2].location];
    }
    else if ([path rangeOfString:item3].length > 0)
    {
        return [path substringToIndex:[path rangeOfString:item3].location];
    }else if ([path rangeOfString:item4].length > 0)
    {
        return [path substringToIndex:[path rangeOfString:item4].location];
    }
    return nil;
}

@end
