//
//  BaseViewController.h
//  FirstPro
//
//  Created by tutu on 14/11/5.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MMDrawerController.h"
#import "MainViewController.h"
#import "Reachability.h"

@interface BaseViewController : UIViewController

{
    MBProgressHUD *_hud;
    int netStatus;
    CGFloat KScreenHeight1;
}
@property (strong, nonatomic)Reachability *reachability;

//显示正在加载的hud
-(void)showHud:(NSString *)title;
-(void)hideHud;

//现实加载完成的hud
-(void)completeHud:(NSString *)title;
- (MainViewController *)mainViewController;
- (MMDrawerController *)mmDrawViewController;
-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView;

-(void)addArrowWithHeight:(CGFloat)hei ToParentView:(UIView *)parentView;

@end
