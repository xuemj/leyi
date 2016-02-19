//
//  PictureViewController.m
//  UIPicture
//
//  Created by tutu on 14/12/9.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  意见反馈

#import "PictureViewController.h"
#import "FLSheZHiViewController.h"
#import "PSConfigs.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ios7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define kMaxLength 70
@interface PictureViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *tv;
@property(nonatomic,strong)UILabel *labeltext;
@end

@implementation PictureViewController

//意见反馈信息功能处理
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    device = [[UIDevice alloc] init];
    //获取device
    strModel  = [UIDevice currentDevice].model ;
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/version/getLastVersion/%@",@2];
    [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
        VersionId = [result objectForKey:@"version"];
    } failLoad:^(id result) {
        
    }];
 
    if (ios7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green: 240/255.0 blue:240/255.0 alpha:1];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0,20, kScreenWidth,kScreenHeight*0.25)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    self.tv = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-20,kScreenHeight*0.2)];
    self.tv.backgroundColor = [UIColor whiteColor];
    self.tv.textColor = [UIColor blackColor];
    self.tv.selectedRange = NSMakeRange(0, 0);
    self.tv.font = [UIFont systemFontOfSize:18];
    self.tv.delegate = self;
    [v addSubview:self.tv];
    
    self.labeltext = [[UILabel alloc]initWithFrame:CGRectMake(5,8, 150, 20)];
    self.labeltext.text = @"请提出您宝贵的意见";
    self.labeltext.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
    [self.tv addSubview:self.labeltext];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, v.bottom+5, 140, 20)];
    label1.textColor = [UIColor darkGrayColor];
    label1.text = @"欢迎加入乐忆QQ群:";
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(160, v.bottom+5,100, 20)];
    label2.text = @"426247935";
    label2.textColor = CommonBlue;
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,60, 44);
    rightBtn.showsTouchWhenHighlighted = YES;
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal ];
    [rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 210, kScreenWidth, 40);

}

-(void)backAction{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//-(void)QQlianxi:(UIButton *)ttt{
//    NSLog(@"QQ联系方式");
//}

//推向上一个页面
-(void)click:(UIButton*)sender
{
    [self.tv resignFirstResponder];
//    [self jiekouQingqiu];
    if (self.tv.text.length>0) {
        if (netStatus == 0) {
            UIAlertView *NetAalt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络链接异常,请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [NetAalt show];
        }else{
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定提出您宝贵的意见吗？"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }else{
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有填写意见哦~"delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alt show];
    }
        
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            
        }else {
            [self jiekouQingqiu];
        }
    }else if(alertView.tag == 200){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (buttonIndex == 0) {
            
        }else {
            [self jiekouQingqiu];
        }
    }
   
}
//意见反馈功能处理
-(void)jiekouQingqiu{
    if (netStatus == 0) {
        UIAlertView *NetAalt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络链接异常,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [NetAalt show];
    }else{
        [self showHud:@"正在发送..."];
        NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/suggest/add"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //反馈的内容
        [dic setObject:[self.tv text] forKey:@"content"];
        //当前软件的版本号
        [dic setObject:VersionId   forKey:@"version"];
        //当前手机的操作系统
        [dic setObject:device.systemVersion forKey:@"phoneOs"];
        //当前设备的类别
        [dic setObject:device.model forKey:@"phoneType"];
        //当前手机的ID
        [dic setObject:device.identifierForVendor.UUIDString forKey:@"phoneSn"];
        [DataService requestWithURL:url params:dic requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
            [self hideHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *altFinish = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的宝贵意见我们已收到~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                altFinish.tag = 200;
                [altFinish show];
            });
        } failLoad:^(id result) {
            [self hideHud];
            NSString *failString = (NSString *)result;
            if ([failString rangeOfString:@"Connection refused"].location == NSNotFound) {
                UIAlertView *ALERT = [CommonAlert showAlertWithTitle:@"提示" withMessage:@"Don't worry!Be happy~请稍后重试!" withDelegate:YES withCancelButton:@"取消" withSure:@"重新发送" withOwner:nil];
                ALERT.tag = 100;
            }
        }];

    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.labeltext.hidden = YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > kMaxLength && range.length!=1){
        textView.text = [toBeString substringToIndex:kMaxLength];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最大输入长度不能超过70个字符" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (self.tv.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.labeltext.hidden=NO;
        }else{
            self.labeltext.hidden=YES;
        }
    }else{//textview长度不为0
        if (self.tv.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.labeltext.hidden=NO;
            }else{//不是删除
                self.labeltext.hidden=YES;
            }
        }else{//长度不为1时候
            self.labeltext.hidden=YES;
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tv resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
        label = nil;
        button = nil;
        self.view = nil;
    }
}

@end