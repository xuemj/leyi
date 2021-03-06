//
//  WanShanDetalViewController.m
//  PictureSaying
//
//  Created by fulei on 15/1/26.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "WanShanDetalViewController.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "AppDelegate.h"
#import "PSConfigs.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "ZHPickView.h"
@interface WanShanDetalViewController ()<ZHPickViewDelegate>
@property(nonatomic,strong)ZHPickView *pickview;
//13439885473
@end

@implementation WanShanDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善个人信息";
   
    KongLable  = [[UILabel alloc]init];
    KongLable.frame = CGRectMake(0, 0, 200, 2);
    KongLable.text =  _textNsstr;
    KongLable.hidden  = YES;
    [self.view addSubview:KongLable];
    
    wanchengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wanchengButton.frame = CGRectMake(10, 150, KScreenWidth -20, 50);
    [wanchengButton setTitle:@"完成" forState:UIControlStateNormal];
    wanchengButton.backgroundColor = CommonBlue;
    wanchengButton.layer.cornerRadius = 3;
    [wanchengButton addTarget:self action:@selector(FinishAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: wanchengButton];
    
    
     self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self bianjiCeng];
    // Do any additional setup after loading the view.
}

-(void)bianjiCeng{
    
    BianjiView = [[UIView alloc]init];
    BianjiView.backgroundColor = rgb(255, 255, 255, 1);
    BianjiView.frame  =CGRectMake(0, 20, KScreenWidth, 100);
    [self.view addSubview:BianjiView];
    
    //第一行处理 头像大按钮
    SexLabel  = [[UILabel alloc]init];
    SexLabel.frame = CGRectMake(15, 0, 50, 50);
    SexLabel.text = @"性别";
    SexLabel.font = [UIFont systemFontOfSize:20];
    [BianjiView  addSubview:SexLabel];
    [self addLineWithWidth:0 withHeight:0 toView:BianjiView];
    
    [self addLineWithWidth:0 withHeight:50 toView:BianjiView];
    
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame  =CGRectMake(0, 51,KScreenWidth , 50);
//    [butt setImage:[UIImage imageNamed:@"c1"] forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(Diqu:) forControlEvents:UIControlEventTouchUpInside];
    [BianjiView addSubview:butt];
    
    jianTou1 = [UIButton buttonWithType:UIButtonTypeCustom];
    jianTou1.frame = CGRectMake(KScreenWidth-30, 15, 20, 20);
    [jianTou1 setImage:[UIImage imageNamed:@"c1.png"] forState:UIControlStateNormal];
    [jianTou1 addTarget:self action:@selector(Diqu:) forControlEvents:UIControlEventTouchUpInside];
    [butt addSubview:jianTou1];
    
    MingziLable = [[UILabel alloc]init];
    MingziLable.frame = CGRectMake(15, 51, 50, 50);
    MingziLable.text = @"地区";
    MingziLable.font = [UIFont systemFontOfSize:20];
    [BianjiView addSubview:MingziLable];
    
    AreaName  = [[UILabel alloc]init];
    AreaName.frame  =CGRectMake(130, 51, 130, 50);
    [BianjiView addSubview:AreaName];
    
    [self addLineWithWidth:0 withHeight:50 toView:BianjiView];
    
    [self addLineWithWidth:0 withHeight:100 toView:BianjiView];
    
    
    UIButton  *secImageChoose  = [UIButton buttonWithType:UIButtonTypeCustom];
    secImageChoose.frame = CGRectMake(65, 0, 50, 50);
    secImageChoose.layer.cornerRadius= 25;
    [secImageChoose setImage:[UIImage imageNamed:@"chose"] forState:UIControlStateNormal];
//    [secImageChoose setSelected:YES];
    [secImageChoose setImage:[UIImage imageNamed:@"yesCheck"] forState:UIControlStateSelected];
    secImageChoose.tag = 100;
    [secImageChoose addTarget:self action:@selector(xuanZe:) forControlEvents: UIControlEventTouchUpInside];
    [BianjiView addSubview:secImageChoose];
    
    sexImageMan = [[UIImageView alloc]init];
    sexImageMan.frame = CGRectMake(110, 16, 40, 20);
    [sexImageMan setImage:[UIImage imageNamed:@"nan.png"]];
    [BianjiView addSubview:sexImageMan];
    
    
    UIButton *secImageChoose1  = [UIButton buttonWithType:UIButtonTypeCustom];
    secImageChoose1.frame = CGRectMake(200, 0, 50, 50);
    secImageChoose1.layer.cornerRadius= 25;
    [secImageChoose1 setImage:[UIImage imageNamed:@"chose"] forState:UIControlStateNormal];
    [secImageChoose1 setImage:[UIImage imageNamed:@"yesCheck"] forState:UIControlStateSelected];
     secImageChoose1.tag = 200;
    [secImageChoose1 addTarget:self action:@selector(xuanZe:) forControlEvents: UIControlEventTouchUpInside];
    [BianjiView addSubview:secImageChoose1];
    
    sexImageWomen = [[UIImageView alloc]init];
    sexImageWomen.frame = CGRectMake(240, 16, 40, 20);
    [sexImageWomen setImage:[UIImage imageNamed:@"women.png"]];
    [BianjiView addSubview:sexImageWomen];
    
}

-(void)Diqu:(UIButton *)bttt{
    _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:YES];
    _pickview.delegate=self;
    [self.view addSubview:_pickview];
}

#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    AreaName.text = resultString;
}

-(void)xuanZe:(UIButton *)bud{
   bud.selected = !bud.selected;
    if (bud.selected) {
        if (bud.tag == 100) {
            UIButton *bu = (UIButton *)[BianjiView viewWithTag:200];
            bu.selected = NO;
        }else{
            UIButton *bu = (UIButton *)[BianjiView viewWithTag:100];
            bu.selected = NO;
        }
    }else{
        if (bud.tag == 100) {
            UIButton *bu = (UIButton *)[BianjiView viewWithTag:200];
            bu.selected = YES;
        }else{
            UIButton *bu = (UIButton *)[BianjiView viewWithTag:100];
            bu.selected = YES;
        }
    }
   
}
-(void)FinishAction:(UIButton *)fni{
    
    if (netStatus == 0) {
        UIAlertView *NetAalt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没网络请检查您的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [NetAalt show];
    }else{
    {
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        [tempDic setObject:AreaName.text forKey:@"address"];
        [tempDic setObject:_textNsstr forKey:@"nickname"];
        [tempDic setObject:@0 forKey:@"status"];
        UIButton *manButton = (UIButton *)[BianjiView viewWithTag:100];
        NSNumber *sex = manButton.selected?@1:@0;
        NSLog(@"%@",sex);
        [tempDic setObject:sex forKey:@"sex"];
        [DataService requestWithURL:@"/WeiXiao/api/v1/user/edit" params:tempDic requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
            NSDictionary *userResult = (NSDictionary *)result;
            if ([[userResult objectForKey:@"result"] isEqual:@0]) {
                NSData *tempUserData1 = [NSJSONSerialization dataWithJSONObject:tempDic options:NSJSONWritingPrettyPrinted error:nil];
                [[NSUserDefaults standardUserDefaults] setObject:tempUserData1 forKey:kMyUserInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithObject:@YES forKey:@"LOGIN"];
                    [defaults setObject:loginDic forKey:@"LoginDic"];
                    [[PSConfigs shareConfigs] loadUserInfo];
                    LeftViewController * leftVC = [[LeftViewController alloc] init];
                    
                    MainViewController * mainVC = [[MainViewController alloc] init];
                    mainVC.fromAlbum = @"yes";
                    MMDrawerController *drawerController = [[MMDrawerController alloc]
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
            
        }];
      }
   }
}



//线条处理
-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, KScreenWidth, 0.5)];
    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [parentView addSubview:lineIV];
    [parentView bringSubviewToFront:lineIV];
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
