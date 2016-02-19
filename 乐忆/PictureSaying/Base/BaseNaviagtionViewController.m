//
//  BaseNaviagtionViewController.m
//  SnsSend
//
//  Created by tutu on 14-10-29.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseNaviagtionViewController.h"
#import "MainViewController.h"
#import "CreateStoryViewController.h"
#import "CameraViewController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

@interface BaseNaviagtionViewController ()
{
//    CGPoint startTouch;
//    BOOL isMoving;
//    
//    UIImageView *backImageView;
}

@property (nonatomic,strong) NSMutableArray *backImages;

@end

@implementation BaseNaviagtionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //监听主题切换的通知
//        self.backImages = [[NSMutableArray alloc] init];
//        self.canDragBack = YES;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //7.0设置导航栏不透明
    self.navigationBar.translucent = NO;
}



@end
