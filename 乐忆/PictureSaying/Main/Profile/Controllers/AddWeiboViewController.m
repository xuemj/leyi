//
//  AddWeiboViewController.m
//  PictureSaying
//
//  Created by tutu on 15/1/5.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "AddWeiboViewController.h"

@interface AddWeiboViewController ()

@end

@implementation AddWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新浪微博";
    [self _initViews];
}

-(void)setWebString:(NSString *)webString{
    if(_webString!=webString)
    {
        _webString=webString;
        [self _initViews];
        NSURL *url = [NSURL URLWithString:webString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

-(void)_initViews{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _webView.delegate = self;
    
    //自适应屏幕尺寸
    //    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
}

#pragma mark -UIWebViewDelegate
//webView开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
 
}

//webView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    
}

//webView将要请求网络加载数据
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
