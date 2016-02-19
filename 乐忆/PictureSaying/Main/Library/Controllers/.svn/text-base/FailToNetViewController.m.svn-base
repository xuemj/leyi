//
//  FailToNetViewController.m
//  PictureSaying
//
//  Created by tutu on 15/1/9.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "FailToNetViewController.h"

@interface FailToNetViewController ()

@end

@implementation FailToNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"网络设置";
    [self _initVies];
}

-(void)_initVies{
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth-15, 40)];
    lab1.text = @"建议按照以下方式检查网络连接";
    lab1.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, lab1.bottom+20, KScreenWidth - 30, 60)];
    lab2.font = [UIFont systemFontOfSize:17];
    lab2.numberOfLines = 0;
    lab2.textColor = rgb(160, 160, 160, 1);
    lab2.text = @"1.打开手机“设置”并把“WI—FI”开关保持开启状态";
    [self.view addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(15, lab2.bottom+20, KScreenWidth - 30, 100)];
    lab3.textColor = rgb(160, 160, 160, 1);
    lab3.font = [UIFont systemFontOfSize:17];
    lab3.numberOfLines = 0;
    lab3.text = @"2.打开手机“设置”-“通用”—“蜂窝移动网络”并把“蜂窝移动数据”开关保持开启状态";
    [self.view addSubview:lab3];
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
