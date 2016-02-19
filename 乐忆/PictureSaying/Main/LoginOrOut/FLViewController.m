//
//  FLViewController.m
//  Tushuo
//
//  Created by tutu on 14-12-3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "FLViewController.h"
#import "FLDengLuViewController.h"
#import "DataService.h"
#import "MyMD5.h"
#import "AppDelegate.h"
#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "GuideView.h"
#import "PSConfigs.h"
/*
 DAO = "<null>";
 dataSource = "";
 email = "";
 id = 8a2a4f254ab92126014ab934f5b30003;
 image = "";
 loginTime = "2015-01-05 19:16:24";
 nickname = "";
 number = 13521191186;
 password = 123456;
 qq = "";
 registerTime = "2015-01-05 16:27:43";
 source = 0;
 status = "<null>";
 username = "";
 usn = 13521191186;
 weibo = "";
 weixin = "";
 */

@interface FLViewController ()
{
    int seconds;
}
@end

@implementation FLViewController

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
    seconds = 60;
    /*验证码60秒处理功能*/
    self.title = @"登陆/注册";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self Zhuce];
    [[UIApplication sharedApplication]setStatusBarHidden:YES animated:YES];
    self.navigationController.navigationBarHidden = YES;
    if (![self.isFirstIn isEqualToString:@"no"]) {
        [self _createGuideView];
    }else{
        [self showNavAndStutas];
    }
    // Do any additional setup after loading the view from its nib.
}


-(void)showNavAndStutas{
    [[UIApplication sharedApplication]setStatusBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [self.telPhone becomeFirstResponder];
}


-(void)_createGuideView{
    GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:guideView];
    [self.view bringSubviewToFront:guideView];

}

 //验证码60秒处理功能
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

#pragma mark - InitViews
//注册界面处理
-(void)Zhuce{
    zcView = [[UIView alloc]init];
    zcView.frame = CGRectMake(0, 20, KScreenWidth, 60);
    zcView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:zcView];
    zcView.autoresizesSubviews = NO;
    
    UILabel *laBel = [[UILabel alloc]init];
    laBel.frame = CGRectMake(20, 0, KScreenWidth - 200, 60);
    laBel.text = @"手机号码";
    [zcView addSubview:laBel];
    
    //手机号码
    _telPhone = [[UITextField alloc]init];
    _telPhone.frame = CGRectMake(KScreenWidth-200, 0, KScreenWidth-laBel.right, 60);
    _telPhone.placeholder = @"请输入您的手机号码";
    _telPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telPhone.backgroundColor = [UIColor whiteColor];
    _telPhone.delegate = self;
    _telPhone.tag = 101;
    _telPhone.keyboardType = UIKeyboardTypeNumberPad;
    [zcView addSubview:_telPhone];
    [self addLineWithWidth:0 withHeight:0 toView:zcView];
    [self addLineWithWidth:0 withHeight:60 toView:zcView];


    zhuCeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuCeButton.frame = CGRectMake(10, zcView.bottom+20, KScreenWidth-20, 50);
    zhuCeButton.backgroundColor = CommonBlue;
    zhuCeButton.layer.cornerRadius = 5;
    zhuCeButton.layer.masksToBounds = YES;

    [zhuCeButton setTitle:@"下一步" forState:UIControlStateNormal];
    [zhuCeButton addTarget:self action:@selector(zhuceXinXi:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:zhuCeButton];
//    zhuCeButton.enabled = NO;
}

//注册功能校验处理
-(void)zhuceXinXi:(UIButton *)zc{
    if (netStatus == 0) {
        UIAlertView *NetAalt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没网络请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [NetAalt show];
    }else{
    
        if ([self isValidateMobile:[_telPhone text]]){
            FLDengLuViewController *flDengLuVc = [[FLDengLuViewController alloc]init];
            flDengLuVc._telePhon = _telPhone.text;
            [self.navigationController pushViewController:flDengLuVc animated:YES];
            NSString *urlstring1 = [NSString stringWithFormat:@"/WeiXiaoVCK/api/v1/vck/sms/%@",[_telPhone text]];
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
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)userLogining{
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/registerAndLogin/%@/%@",_telPhone.text,@0];
    [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
        NSDictionary *dic = (NSDictionary *)result;
        if ([[dic allKeys]count] == 0) {
            [self hideHud];
            [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithObject:@YES forKey:@"LOGIN"];
                [defaults setObject:loginDic forKey:@"LoginDic"];
                
                LeftViewController * leftVC = [[LeftViewController alloc] init];
                
                MainViewController * mainVC = [[MainViewController alloc] init];
                mainVC.fromAlbum = @"yes";
                //        BaseNaviagtionViewController *mainNav = [[BaseNaviagtionViewController alloc] initWithRootViewController:indexVC];
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
    } failLoad:^(id result) {
        [self showAlert];
    }];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"Get"];
   // NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
        
        if ([[dic allKeys]count] == 0) {
            [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                LeftViewController * leftVC = [[LeftViewController alloc] init];
                
                MainViewController * mainVC = [[MainViewController alloc] init];
                //        BaseNaviagtionViewController *mainNav = [[BaseNaviagtionViewController alloc] initWithRootViewController:indexVC];
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
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithObject:@YES forKey:@"LOGIN"];
                [defaults setObject:loginDic forKey:@"LoginDic"];
                NSData *userData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                [defaults setObject:userData forKey:@"MyUserInfo"];
            });
        }
    }];
}

#pragma mark - isValidateMobile
//手机校验是不是合格功能处理
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //NSString * phoneRegex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * phoneRegex = @"^1(3[0-9]|5[0-9]|8[0-9]|4[0-9]|7[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {//检测到“完成”
        [textField resignFirstResponder];//释放键盘
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:11];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark - TouchEvent
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_telPhone resignFirstResponder];
}

#pragma mark - AlertAction
//登录失败
-(void)showAlert{
    UIAlertView *Alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [Alter show];
    [self hideHud];
}

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

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex) {
//        case 0:
//        {
//            [self presentVC];
//        }
//            break;
//            
//        case 1:
//        {
//            NSLog(@"baoliu");
//        }
//            break;
//            
//        default:
//            break;
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        zcView = nil;
        _telPhone = nil;
        YanZheng = nil;
        yanzhengButton = nil;
        PassWord = nil;
        zhuCeButton = nil;
        alt = nil;
        self.view = nil;
    }
}

@end
