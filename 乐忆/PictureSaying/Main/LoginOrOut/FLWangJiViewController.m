//
//  FLWangJiViewController.m
//  Tushuo
//
//  Created by tutu on 14-12-3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "FLWangJiViewController.h"

@interface FLWangJiViewController ()

@end

@implementation FLWangJiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";
      self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    [self findMima];
    
    queDing = [UIButton buttonWithType:UIButtonTypeCustom];
    queDing.frame = CGRectMake(10, xinMima.bottom+40, KScreenWidth-20, 50);
    queDing.backgroundColor = [UIColor colorWithRed:252/255.0 green:181/255.0 blue:58/255.0 alpha:1];
    [queDing setTitle:@"找回密码"  forState:UIControlStateNormal];
    [queDing addTarget:self action:@selector(queding:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queDing];

    //self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view from its nib.
}

-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, KScreenWidth, 0.5)];
    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [parentView addSubview:lineIV];
    [parentView bringSubviewToFront:lineIV];
}
//找到密码界面处理
-(void)findMima{
    findMima = [[UIView alloc]init];
    findMima.frame = CGRectMake(0, 20, KScreenWidth, 180);
    findMima.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:findMima];
    
    //手机号码
    sjHaoma = [[UITextField alloc]init];
    sjHaoma.frame = CGRectMake(20, 0, KScreenWidth-20, 60);
    sjHaoma.placeholder = @"请输入您的手机号码";
    sjHaoma.keyboardType = UIKeyboardTypeNumberPad;
    [findMima addSubview:sjHaoma];
    [self addLineWithWidth:0 withHeight:0 toView:findMima];
    [self addLineWithWidth:0 withHeight:60 toView:findMima];
    
    //验证码
    yzHaoma = [[UITextField alloc]init];
    yzHaoma.frame = CGRectMake(20, 59, KScreenWidth-20, 60);
    yzHaoma.placeholder = @"请输入验证码";
    yzHaoma.keyboardType = UIKeyboardTypeNumberPad;
    huoquYzheng = [UIButton buttonWithType:UIButtonTypeCustom];
    huoquYzheng.frame = CGRectMake(200, 10, 100, 40);
    huoquYzheng .backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [huoquYzheng setTitle:@"获取验证码"  forState:UIControlStateNormal];
    [huoquYzheng setTitleColor:[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
    [huoquYzheng addTarget:self action:@selector(yanzhengHao:) forControlEvents:UIControlEventTouchUpInside];
    [yzHaoma addSubview:huoquYzheng];
    [findMima addSubview:yzHaoma];
    [self addLineWithWidth:0 withHeight:120 toView:findMima];
    
    // 新密码
    xinMima = [[UITextField alloc]init];
    xinMima.frame = CGRectMake(20, 118, KScreenWidth-20, 60);
    xinMima.placeholder = @"请输入密码";
    xinMima.secureTextEntry = YES;
    [findMima addSubview:xinMima];
    [self addLineWithWidth:0 withHeight:179 toView:findMima];
}
-(void)yanzhengHao:(UIButton *)butt{

}

//手机号码是不是正确
-(void)queding:(UIButton *)bttt{
    
    if ([self isValidateMobile:[sjHaoma text]]) {
        
    }else
    {
        alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alt show];
    }
}

//手机号码正则表达式
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //    NSString * phoneRegex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * phoneRegex = @"^1(3[0-9]|5[0-9]|8[0-9]|4[0-9]|7[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self jiaoyan];
}

//手机号码校验处理
-(void)jiaoyan{
    if ([self isValidateMobile:[sjHaoma text]]) {
        
    }else
    {
        alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alt show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [yzHaoma resignFirstResponder];
    [xinMima resignFirstResponder];
    [sjHaoma resignFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        findMima = nil;
        sjHaoma = nil;
        yzHaoma = nil;
        xinMima = nil;
        huoquYzheng = nil;
        queDing = nil;
        alt = nil;
        self.view = nil;
    }
}

@end
