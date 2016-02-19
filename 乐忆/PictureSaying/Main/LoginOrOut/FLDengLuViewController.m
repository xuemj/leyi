//
//  FLDengLuViewController.m
//  Tushuo
//
//  Created by tutu on 14-12-3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "FLDengLuViewController.h"

#import "MMExampleDrawerVisualStateManager.h"
#import "LeftViewController.h"
#import "BaseNaviagtionViewController.h"
#import "AppDelegate.h"
#import "PSConfigs.h"
#import "WanShanSingerInfermaionViewController.h"
#import "APService.h"
#define SOURCE 0
@interface FLDengLuViewController (){

 int seconds;
}

@end

@implementation FLDengLuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//登录UI界面处理
- (void)viewDidLoad
{
    [super viewDidLoad];
    seconds = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [timer fire];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.title = @"填写动态密码";
    [self NewView];
    [self textViewInPut];
    zhuCeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuCeButton.frame = CGRectMake(10, textInput.bottom+10 , KScreenWidth-20, 50);
    zhuCeButton.backgroundColor = CommonBlue;
    zhuCeButton.layer.cornerRadius = 5;
    zhuCeButton.layer.masksToBounds = YES;
    [zhuCeButton setTitle:@"下一步" forState:UIControlStateNormal];
    [zhuCeButton addTarget:self action:@selector(GerenShezhiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuCeButton];
    [self Zhuce];
}

#pragma mark NewView


-(void)NewView{
     UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 10, KScreenWidth, 60);
    [self.view addSubview:view];
    
    UILabel *Pass = [[UILabel alloc]init];
    Pass.frame = CGRectMake(KScreenWidth/4+20, 5, KScreenWidth/4 - 6, 30);
    Pass.text = @"动态密码";
    Pass.textColor = CommonBlue;
    [view addSubview:Pass];
    
    UILabel *Send= [[UILabel alloc]init];
    Send.frame = CGRectMake(KScreenWidth/2 + 10, 5, KScreenWidth/4, 30);
    Send.text = @"已发送到";
    [view addSubview:Send];
    
    
    TelePhoneLabel = [[UILabel alloc]init];
    TelePhoneLabel.frame = CGRectMake(KScreenWidth/3+8, Send.bottom, KScreenWidth/3, 30);
    TelePhoneLabel.text = __telePhon;
    [view addSubview:TelePhoneLabel];
    [self yanZhengMa];
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //NSString * phoneRegex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * phoneRegex = @"^1(3[0-9]|5[0-9]|8[0-9]|4[0-9]|7[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}



-(void)yanZhengMa{
    
}

//登录失败


//验证码错误的时候
-(void)showAlertYanzheng{
    [self hideHud];
    UIAlertView *Alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码错误,请重新输入..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [Alter show];
}

//验证手机号码正确与错误的时候
-(void)showAlertShouji{
    UIAlertView *Alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [Alter show];
}



-(void)textViewInPut{
    textInput = [[UIView alloc]init];
    textInput.backgroundColor = [UIColor whiteColor];
    textInput.frame = CGRectMake((KScreenWidth - 20)/3, TelePhoneLabel.bottom+20, (KScreenWidth - 40)/2, (KScreenWidth  - 40)/8);
    [self.view addSubview:textInput];
 
    first = [[UITextField alloc]init];
    first.frame = CGRectMake(0, 0, (KScreenWidth - 40)/8, (KScreenWidth - 40)/8);
    first.tag = 100;
    [first becomeFirstResponder];
    first.delegate = self;
    first.returnKeyType = UIReturnKeyNext;
    first.layer.borderWidth  = 0.3;
    first.keyboardType = UIKeyboardTypeNumberPad;
    first.textAlignment = 1;
    [textInput addSubview:first];
    
    
    second = [[UITextField alloc]init];
    second.frame  = CGRectMake(first.right, 0, (KScreenWidth - 40)/8, (KScreenWidth - 40)/8);
    second.tag = 200;
    second.delegate =self;
    second.textAlignment = 1;
    second.returnKeyType = UIReturnKeyNext ;
    second.layer.borderWidth = 0.3;
    second.keyboardType = UIKeyboardTypeNumberPad;
    [textInput addSubview:second];
    
    third  = [[UITextField alloc]init];
    third.frame = CGRectMake(second.right, 0, (KScreenWidth - 40)/8, (KScreenWidth - 40)/8);
    third.tag = 300;
    third.returnKeyType = UIReturnKeyNext ;
    third.layer.borderWidth = 0.3;
    third.keyboardType = UIKeyboardTypeNumberPad;
    third.delegate = self;
    third.textAlignment = 1;
    [textInput addSubview:third];
    
    fourth  = [[UITextField alloc]init];
    fourth.frame  =CGRectMake(third.right, 0, (KScreenWidth - 40)/8, (KScreenWidth - 40)/8);
    fourth.tag = 400;
    fourth.returnKeyType = UIReturnKeyDone ;
    fourth.layer.borderWidth = 0.3;
    fourth.keyboardType = UIKeyboardTypeNumberPad;
    fourth.textAlignment = 1;
    fourth.delegate  =self;
    [textInput addSubview:fourth];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 100 && string.length == 1) {
        first.text = string;
        [second becomeFirstResponder];
        second.text = @"";
    }else if(textField.tag == 200 && string.length == 1) {
        second.text = string;
        [third becomeFirstResponder];
    }else if (textField.tag == 300 && string.length == 1){
        third.text =string;
        [fourth becomeFirstResponder ];
    }else  if (textField.tag == 400 && string.length == 1) {
        fourth.text = string;
    }
    else if([string isEqualToString:@""] && textField.tag == 400) {
        [third becomeFirstResponder];
        fourth.text = string;
    }else  if([string isEqualToString:@""] && textField.tag == 300) {
        [second becomeFirstResponder];
        third.text = string;
    }else if ([string isEqualToString:@""]&& textField.tag == 200 ){
        
        [first becomeFirstResponder];
        second.text = string;
    }else{
        first.text = string;
    }
    return  NO;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [first resignFirstResponder];
    [second resignFirstResponder];
    [third resignFirstResponder];
    [fourth resignFirstResponder];
}
-(void)Zhuce{
        zcView = [[UIView alloc]init];
        zcView.frame = CGRectMake(KScreenWidth/2, zhuCeButton.bottom+10 , KScreenWidth/2.5, 40);
        zcView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:zcView];
        zcView.autoresizesSubviews = NO;
       
        yanzhengButton = [UIButton buttonWithType:UIButtonTypeCustom];
        yanzhengButton.frame = CGRectMake(0,0, KScreenWidth/2.5, 40);
        yanzhengButton.backgroundColor = rgb(186, 186, 186, 1);
        yanzhengButton.layer.cornerRadius = 3;
        yanzhengButton.titleLabel.font = [UIFont systemFontOfSize:15];
        yanzhengButton.layer.masksToBounds = YES;
        yanzhengButton.enabled = NO;
        [yanzhengButton setTitle:@"获取动态密码"  forState:UIControlStateNormal];
        [yanzhengButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [yanzhengButton addTarget:self action:@selector(yanzheng:) forControlEvents:UIControlEventTouchUpInside];
        [zcView addSubview:yanzhengButton];
    
}

#pragma mark - Button
-(void)yanzheng:(UIButton *)but{
    
    if (netStatus == 0) {
        UIAlertView *NetAalt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没网络请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [NetAalt show];
    }else{
    
    seconds = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [timer fire];
    NSString *urlstring1 = [NSString stringWithFormat:@"/WeiXiaoVCK/api/v1/vck/sms/%@",[TelePhoneLabel text]];
    [self showHud:@"正在发送动态码..."];
    [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
        NSDictionary *dic = (NSDictionary *)result;
        if (dic != nil) {
            if ([[dic objectForKey:@"result"] isEqual:@0]) {
                [self completeHud:@"动态码已发出"];
            }else{
                [self completeHud:@"动态码发送失败"];
                [yanzhengButton setBackgroundColor:CommonBlue];
                yanzhengButton.enabled = YES;
            }
        }else{
            [self completeHud:@"动态码发送失败"];
            [yanzhengButton setBackgroundColor:CommonBlue];
            yanzhengButton.enabled = YES;
        }
    } failLoad:^(id result) {
        
    }];

    }
}
-(void)GerenShezhiAction:(UIButton *)bt{
    if (netStatus == 0) {
        UIAlertView *NetAalt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没网络请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [NetAalt show];
    }else{
        YanzhengMaHeji = [NSString stringWithFormat:@"%@%@%@%@",first.text,second.text,third.text,fourth.text];
        NSString *urlstring1 = [NSString stringWithFormat:@"/WeiXiaoVCK/api/v1/vck/check/%@/%@",[TelePhoneLabel text],YanzhengMaHeji];
        [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
        NSDictionary *dic = (NSDictionary *)result;
            if ([[dic objectForKey:@"result"] isEqual:@0]) {
                [self userLogining];
            }else{
                [self showAlertYanzheng];
            }
        
    } failLoad:^(id result) {
    }];
    
    }
}

-(void)userLogining{
    if (netStatus == 0) {
        UIAlertView *NetAalt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没网络请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [NetAalt show];
    }else {
        NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/registerAndLogin/%@/%@",TelePhoneLabel.text,@0];
        [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
            NSDictionary *dic = (NSDictionary *)result;

      [APService setTags:nil alias:[dic objectForKey:@"usn"] callbackSelector:nil target:nil];

            if ([[dic objectForKey:@"nickname"] isEqualToString:@""]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *userData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                [defaults setObject:userData forKey:@"MyUserInfo"];
                [[PSConfigs shareConfigs] loadUserInfo];
                WanShanSingerInfermaionViewController *wanShanVc = [[WanShanSingerInfermaionViewController alloc]init];
                wanShanVc.ShoujiTele = TelePhoneLabel.text;
                [self.navigationController pushViewController:wanShanVc animated:YES];
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSData *userData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    [defaults setObject:userData forKey:@"MyUserInfo"];
                    NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithObject:@YES forKey:@"LOGIN"];
                  //  NSData *ttt = [[NSUserDefaults standardUserDefaults] objectForKey:kMyUserInfo];
                   // NSDictionary *dddd = [NSJSONSerialization JSONObjectWithData:ttt options:NSJSONReadingMutableContainers error:nil];
                    //NSLog(@"TTTT====%@",dddd);
                    [defaults setObject:loginDic forKey:@"LoginDic"];
                   // NSLog(@"LOGIN%@",loginDic);
                    [[PSConfigs shareConfigs] loadUserInfo];
                    LeftViewController *leftVC = [[LeftViewController alloc] init];
                    MainViewController *mainVC = [[MainViewController alloc] init];
                    mainVC.fromAlbum = @"yes";
                    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                             initWithCenterViewController:mainVC
                                                             leftDrawerViewController:leftVC
                                                             rightDrawerViewController:nil];
                    
                    //设置左右菜单的宽度
                    [drawerController setMaximumRightDrawerWidth:1];
                    [drawerController setMaximumLeftDrawerWidth:240];
                    
                    //设置手势操作的有效区域MMOpenDrawerGestureModeAll：所有区域
                    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                    
                    //配置管理动画的block
                    [drawerController
                     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                         MMDrawerControllerDrawerVisualStateBlock block;
                         block = [[MMExampleDrawerVisualStateManager sharedManager]
                                  drawerVisualStateBlockForDrawerSide:drawerSide];
                         if(block){
                             block(drawerController, drawerSide, percentVisible);
                         }
                     }];
                    AppDelegate *dl = [UIApplication sharedApplication].delegate;
                    dl.window.rootViewController = drawerController;
            });
                
            }
    }  failLoad:^(id result) {
        
    }];
    }
}

#pragma mark - yanzhengma
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        timer = nil;
        seconds = 60;
        [yanzhengButton setTitle:@"获取验证码" forState: UIControlStateNormal];
        [yanzhengButton setBackgroundColor:CommonBlue];
        [yanzhengButton setEnabled:YES];
    }else{
        seconds--;
        //        NSString *title = [NSString stringWithFormat:MSG_DYNAMIC_CODE_WAIT,seconds];
        [yanzhengButton setBackgroundColor:rgb(186, 186, 186, 1)];
        [yanzhengButton setEnabled:NO];
        NSString *btnTitle = [NSString stringWithFormat:@"%ds后重新获取",seconds];
        [yanzhengButton setTitle:btnTitle forState:UIControlStateNormal];
    }
}
//    [self createNavItem];
//    [self dengLu];
//    [self qitaChuli];
//    //登录按钮
//    dengLuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    dengLuButton.frame = CGRectMake(10, DengLuView.bottom+20, KScreenWidth-20, 50);
//    dengLuButton.backgroundColor = [UIColor colorWithRed:252/255.0 green:181/255.0 blue:58/255.0 alpha:1];
//    [dengLuButton setTitle:@"登录"  forState:UIControlStateNormal];
//    [dengLuButton addTarget:self action:@selector(dengLuAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:dengLuButton];
//    
//    //忘记密码按钮
//    WangJiMima = [UIButton buttonWithType:UIButtonTypeCustom];
//    WangJiMima.frame = CGRectMake(210, dengLuButton.bottom+20, 100, 40);
//    //WangJiMima.backgroundColor = [UIColor colorWithRed:252/255.0 green:181/255.0 blue:58/255.0 alpha:1];
//    WangJiMima.right = dengLuButton.right;
//    [WangJiMima setTitle:@"忘记密码?"  forState:UIControlStateNormal];
//    [WangJiMima setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [WangJiMima addTarget:self action:@selector(WangjiAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:WangJiMima];
    // Do any additional setup after loading the view from its nib.


//-(void)createNavItem{
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 60, 44);
//    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
//}

//-(void)jump:(UIButton *)btn{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
////线条处理
//-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
//    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, KScreenWidth, 0.5)];
//    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
//    [parentView addSubview:lineIV];
//    [parentView bringSubviewToFront:lineIV];
//}
//
////登录界面处理
//-(void)dengLu{
//    DengLuView  = [[UIView alloc]init];
//    DengLuView.frame = CGRectMake(0, 20, KScreenWidth, 120);
//    DengLuView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:DengLuView];
//    //输入手机号码
//    ShuruShouji = [[UITextField alloc]init];
//    ShuruShouji.frame = CGRectMake(20, 0, KScreenWidth-20, 60);
//    ShuruShouji.placeholder =@"请输入您的手机号码";
//    ShuruShouji.backgroundColor = [UIColor whiteColor];
//    ShuruShouji.tag = 100;
//    ShuruShouji.delegate = self;
//    ShuruShouji.keyboardType = UIKeyboardTypeNumberPad;
//    [DengLuView addSubview:ShuruShouji];
//    [self addLineWithWidth:0 withHeight:0 toView:DengLuView];
//    [self addLineWithWidth:0 withHeight:60 toView:DengLuView];
//    //输入密码
//    ShuruMima = [[UITextField alloc]init];
//    ShuruMima.frame = CGRectMake(20, 59, KScreenWidth-20, 60);
//    ShuruMima.placeholder =@"请输入密码";
//    ShuruMima.secureTextEntry =YES;
//    [DengLuView addSubview:ShuruMima];
//     [self addLineWithWidth:0 withHeight:120 toView:DengLuView];
//}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [ShuruMima resignFirstResponder];
//    [ShuruShouji resignFirstResponder];
//
//}
//
////登录功能实现方法
//-(void)getRequest:(NSArray*)arr
//{
//    [self showHud:@"正在登陆..."];
//    NSString *urlstring = [NSString stringWithFormat:@"http://123.56.101.168/WeiXiao/api/v1/user/public/%@/%@/%@",arr[0],arr[1],arr[2]];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"Get"];
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"%@",received);
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
//        NSLog(@"dic == %@",dic);
//        
//        if ([[dic allKeys]count] == 0) {
//            [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self hideHud];
//                LeftViewController * leftVC = [[LeftViewController alloc] init];
//                
//                MainViewController * mainVC = [[MainViewController alloc] init];
//                //        BaseNaviagtionViewController *mainNav = [[BaseNaviagtionViewController alloc] initWithRootViewController:indexVC];
//                MMDrawerController * drawerController = [[MMDrawerController alloc]
//                                                         initWithCenterViewController:mainVC
//                                                         leftDrawerViewController:leftVC
//                                                         rightDrawerViewController:nil];
//                
//                //设置左右菜单的宽度
//                [drawerController setMaximumRightDrawerWidth:1];
//                [drawerController setMaximumLeftDrawerWidth:240];
//                
//                //设置手势操作的有效区域MMOpenDrawerGestureModeAll：所有区域
//                [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//                [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//                
//                //配置管理动画的block
//                [drawerController
//                 setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//                     MMDrawerControllerDrawerVisualStateBlock block;
//                     block = [[MMExampleDrawerVisualStateManager sharedManager]
//                              drawerVisualStateBlockForDrawerSide:drawerSide];
//                     if(block){
//                         block(drawerController, drawerSide, percentVisible);
//                     }
//                 }];
//                AppDelegate *dl = [UIApplication sharedApplication].delegate;
//                dl.window.rootViewController = drawerController;
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithObject:@YES forKey:@"LOGIN"];
//                [defaults setObject:loginDic forKey:@"LoginDic"];
//                NSLog(@"LOGIN%@",loginDic);
//                NSData *userData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//                [defaults setObject:userData forKey:@"MyUserInfo"];
//                [[PSConfigs shareConfigs] loadUserInfo];
//            });
//        }
//    }];
//}
//
//-(void)showAlert{
//    [self hideHud];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//    [alertView show];
//}
//
//-(void)dengLuAction:(UIButton *)dlAction{
//    NSLog(@"15143154564denglu");
//    NSArray *a = @[ShuruShouji.text,ShuruMima.text,@SOURCE];
//    [self getRequest:a];
//   
//}
//
////忘记密码事件处理
//-(void)WangjiAction:(UIButton *)butt{
//    FLWangJiViewController *wj = [[FLWangJiViewController alloc]init];
//    [self.navigationController pushViewController:wj animated:YES];
//    //[self presentViewController:wj animated:YES completion:nil];
//}
//
////手机校验合不合格处理
//-(BOOL) isValidateMobile:(NSString *)mobile
//{
//    NSString * phoneRegex = @"^1(3[0-9]|5[0-9]|8[0-9]|4[0-9]|7[0-9])\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag == 100) {
//        [self jiaoyan];
//    }
//}
//
//-(void)jiaoyan{
//    if ([self isValidateMobile:[ShuruShouji text]]) {
//    }else
//    {
//        alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alt show];
//    }
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        [ShuruShouji becomeFirstResponder];
//    }
//}

//其他方式登录处理
//-(void)qitaChuli{

//    qTaDengLu = [[UIView alloc]init];
//    qTaDengLu.frame =  CGRectMake(0, 360, 320, 160);
//    [self.view addSubview:qTaDengLu];
//    imgQita = [[UIImageView alloc]init];
//    imgQita.frame = CGRectMake(10, 5, 300, 15);
//    [imgQita setImage:[UIImage imageNamed:@"qitafangshi.png"]];
//    [qTaDengLu addSubview:imgQita];
    
    
    //微信登录方式
//    weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    weixinButton.frame = CGRectMake(40, 60, 40, 55);
//    weixinButton.layer.cornerRadius = 5;
//    [weixinButton setTitle:@"微信"  forState:UIControlStateNormal];
//    [weixinButton setImage:[UIImage imageNamed:@"weixin.png"] forState:UIControlStateNormal];
//    [weixinButton addTarget:self action:@selector(WeiDenglu:) forControlEvents:UIControlEventTouchUpInside];
//    [qTaDengLu addSubview:weixinButton];
//    
//    //微博登录方式
//    xinlangButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    xinlangButton.frame = CGRectMake(135, 60, 40, 55);
//    xinlangButton.layer.cornerRadius = 5 ;
//    [xinlangButton setTitle:@"新浪"  forState:UIControlStateNormal];
//    [xinlangButton setImage:[UIImage imageNamed:@"xinlang.png"] forState:UIControlStateNormal];
//    [xinlangButton addTarget:self action:@selector(SinaDenglu:) forControlEvents:UIControlEventTouchUpInside];
//    [qTaDengLu addSubview:xinlangButton];
//    //QQ登录方式
//    qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    qqButton.frame = CGRectMake(230, 60, 40, 55);
//    qqButton.layer.cornerRadius = 5;
//    [qqButton setTitle:@"QQ"  forState:UIControlStateNormal];
//    [qqButton setImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
//    [qqButton addTarget:self action:@selector(QDengLu:) forControlEvents:UIControlEventTouchUpInside];
//    [qTaDengLu addSubview:qqButton];

//}

//微信登录事件
//-(void)WeiDenglu:(UIButton *)bttt{
//  
//    NSLog(@"微信");
//
//}
//
////新浪登录事件
//-(void)SinaDenglu:(UIButton *)bttt{
//    
//    NSLog(@"新浪");
//    
//}
//
////QQ登录事件
//-(void)QDengLu:(UIButton *)bttt{
//    
//    NSLog(@"QQ");
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
}

@end
