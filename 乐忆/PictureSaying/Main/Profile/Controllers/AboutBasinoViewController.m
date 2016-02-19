//
//  AboutBasinoViewController.m
//  PictureSaying
//
//  Created by tutu on 15/1/5.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "AboutBasinoViewController.h"
#import "AddWeiboViewController.h"
#import <MessageUI/MessageUI.h>

@interface AboutBasinoViewController ()

@end

@implementation AboutBasinoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    [self _initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)_initView{
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-120)/2, 50, 120, 50)];
    appName.textColor = CommonBlue;
    appName.font = [UIFont systemFontOfSize:45.0];
    appName.textAlignment = 1;
    appName.text = @"乐忆";
    [self.view addSubview:appName];
    
    UILabel *banbenLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-60)/2, appName.bottom, 60, 20)];
    banbenLabel.textColor = CommonGray;
    banbenLabel.textAlignment = 1;
    banbenLabel.font = [UIFont systemFontOfSize:15.0];
    banbenLabel.text = @"V1.0.0";
    [self.view addSubview:banbenLabel];
    
    UILabel *connectMail = [[UILabel alloc] initWithFrame:CGRectMake(15, banbenLabel.bottom+50, 80, 20)];
    connectMail.textColor = [UIColor blackColor];
    connectMail.font = [UIFont systemFontOfSize:15.0];
    connectMail.text = @"联系邮箱：";
    [self.view addSubview:connectMail];
    
    NSString *mailString = @"leyi@wetime.cn";
    UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize mailSize = [mailString sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 50)];
    mailButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    mailButton.frame = CGRectMake(connectMail.right, connectMail.top, mailSize.width+10, 20);
    [mailButton setTitleColor:CommonBlue forState:UIControlStateNormal];
    [mailButton setTitle:mailString forState:UIControlStateNormal];
    [mailButton addTarget:self action:@selector(showLocationAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mailButton];
    
    [self addLineWithWidth:0 withHeight:mailButton.height-0.5 toView:mailButton];
    
    UILabel *QQ = [[UILabel alloc] initWithFrame:CGRectMake(15, connectMail.bottom+15, 80, 20)];
    QQ.textColor = [UIColor blackColor];
    QQ.font = [UIFont systemFontOfSize:15.0];
    QQ.text = @"官方Q群：";
    [self.view addSubview:QQ];
    
    NSString *qString = @"426247935";
    UIButton *qButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize qSize = [qString sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 50)];
    qButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    qButton.frame = CGRectMake(QQ.right, QQ.top, qSize.width+10, 20);
    [qButton setTitleColor:CommonBlue forState:UIControlStateNormal];
    [qButton setTitle:qString forState:UIControlStateNormal];
    [qButton addTarget:self action:@selector(qqAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qButton];
    
    [self addLineWithWidth:0 withHeight:qButton.height-0.5 toView:qButton];
    
    UILabel *weibo = [[UILabel alloc] initWithFrame:CGRectMake(15, QQ.bottom+15, 80, 20)];
    weibo.textColor = [UIColor blackColor];
    weibo.font = [UIFont systemFontOfSize:15.0];
    weibo.text = @"官方微博：";
    [self.view addSubview:weibo];
    
    NSString *weiboString = @"乐忆时光(有问题随时@乐忆时光)";
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize weiboSize = [weiboString sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 50)];
    weiboButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    weiboButton.frame = CGRectMake(weibo.right, weibo.top, weiboSize.width+20, 20);
    [weiboButton setTitleColor:CommonBlue forState:UIControlStateNormal];
    [weiboButton setTitle:weiboString forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(weiboAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboButton];
    
    [self addLineWithWidth:0 withHeight:weiboButton.height-0.5 toView:weiboButton];
    
    NSString *copyRight1 = @"Copyright ©2013-2015 乐忆 版权所有";
    NSString *copyRight2 = @"京ICP备14058888号-1";
    
    UILabel *right1 = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight-100-64, KScreenWidth, 20)];
    right1.font = [UIFont systemFontOfSize:15.0];
    right1.textAlignment = 1;
    right1.textColor = rgb(167, 167, 167, 1);
    right1.text = copyRight1;
    [self.view addSubview:right1];
    
    UILabel *right2 = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight-70-64, KScreenWidth, 20)];
    right2.font = [UIFont systemFontOfSize:15.0];
    right2.textAlignment = 1;
    right2.textColor = rgb(167, 167, 167, 1);
    right2.text = copyRight2;
    [self.view addSubview:right2];
    
}
//跳转到邮箱
- (void)showLocationAlert {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://admin@hzlzh.com"]];

}

-(void)qqAction:(UIButton *)btn{

    UIAlertView *aaa = [[UIAlertView alloc]initWithTitle:@"提示" message:@"复制QQ号码，方便联系哦~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [aaa show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:
        {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"426247935";
        }
            break;
        case 1:
        {
        }
            break;
        default:
            break;
    }
}

-(void)weiboAction:(UIButton *)btn{

    AddWeiboViewController *addweiboVC = [[AddWeiboViewController alloc] init];
    addweiboVC.webString = @"http://weibo.com/u/5460423014?topnav=1&wvr=6&topsug=1";
    [self.navigationController pushViewController:addweiboVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
   
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, parentView.width-wid, 0.5)];
    lineIV.backgroundColor = CommonBlue;
    [parentView addSubview:lineIV];
    
}



@end
