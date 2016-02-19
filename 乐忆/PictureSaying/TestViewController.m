//
//  TestViewController.m
//  PictureSaying
//
//  Created by tutu on 15/1/4.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "TestViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface TestViewController ()
{
    UIImage *image;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = rgb(248, 248, 248, 1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (KScreenHeight-350)/2, KScreenWidth, 200)];
    label.textAlignment = 1;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:22];
    label.textColor = [UIColor orangeColor];
    label.text = @"机主人品不够哦~此模块显示不出来了 ~ *_* ~ zan够人品再来吧！";
    [self.view addSubview:label];    
}


#pragma mark - ViewAction
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //开启MMDrawer菜单
    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //禁止MMDrawer菜单
    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
