
//
//  BaseViewController.m
//  FirstPro
//
//  Created by tutu on 14/11/5.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication
      sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callingAction:) name:@"calling" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelingAction:) name:@"canceling" object:nil];

    KScreenHeight1 = [UIScreen mainScreen].bounds.size.height;
    // 设置网络状态变化时的通知函数
    [self checkReachability];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:CommonBlue];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    //251/255.0 green:248/255.0 blue:241/255.0
    [[UIApplication
      sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //修改导航栏上的标题颜色
    NSDictionary *textAttr = @{
                               NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]
                               };
    self.navigationController.navigationBar.titleTextAttributes = textAttr;
    //导航控制器子控制器的个数
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 48, 20);
//        leftBtn.backgroundColor = [UIColor orangeColor];
        leftBtn.showsTouchWhenHighlighted = YES;
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    }
}

-(void)callingAction:(NSNotification *)note{
   
}

-(void)cancelingAction:(NSNotification *)note{
    
}

- (void)checkReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [self updateInterfaceWithReachability:self.reachability];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable)
    {
        //No internet
       
        netStatus = 0;
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        
        netStatus = 2;
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
    
        netStatus = 1;
    }
}

-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, parentView.width-wid, 0.5)];
    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [parentView addSubview:lineIV];
    
}

-(void)addArrowWithHeight:(CGFloat)hei ToParentView:(UIView *)parentView{
    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-30, hei, 15, 15)];
    arrowIV.image = [UIImage imageNamed:@"c1.png"];
    [parentView addSubview:arrowIV];
}

- (void)backAction
{
    if (self.navigationController.viewControllers.count>2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.navigationController.viewControllers.count == 2){
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
//    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
}

//显示正在加载的hud
-(void)showHud:(NSString *)title{
    if (_hud == Nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.labelText = title;
    _hud.dimBackground  =YES;
}

-(void)hideHud{
    [_hud hide:YES];
}

//现实加载完成的hud
-(void)completeHud:(NSString *)title{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1];
}

-(MainViewController *)mainViewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isMemberOfClass:[MainViewController class]]) {
            return (MainViewController *)next;
        }
        next = next.nextResponder;
    } while (next != Nil);
    return Nil;
}

- (MMDrawerController *)mmDrawViewController{
    UIResponder *next = self.nextResponder;
    do {
        //判断响应者是否为MainViewController类型
        if ([next isMemberOfClass:[MMDrawerController class]]) {
            return (MMDrawerController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
//    {
//        self.view = nil;
//    }
    
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
//=======
////
////  BaseViewController.m
////  FirstPro
////
////  Created by tutu on 14/11/5.
////  Copyright (c) 2014年 tutu. All rights reserved.
////
//
//#import "BaseViewController.h"
//
//@interface BaseViewController ()
//
//@end
//
//@implementation BaseViewController
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[UIApplication
//      sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶栏.png"] forBarMetrics:UIBarMetricsDefault];
//    self.view.backgroundColor = [UIColor colorWithRed:251/255.0 green:248/255.0 blue:241/255.0 alpha:1.0];
//    //251/255.0 green:248/255.0 blue:241/255.0
//    [[UIApplication
//      sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    
//    //修改导航栏上的标题颜色
//    NSDictionary *textAttr = @{
//                               NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:22]
//                               };
//    self.navigationController.navigationBar.titleTextAttributes = textAttr;
//    //导航控制器子控制器的个数
//    NSUInteger count = self.navigationController.viewControllers.count;
//    if (count > 1) {
//        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftBtn.frame = CGRectMake(0, 0, 48, 20);
////        leftBtn.backgroundColor = [UIColor orangeColor];
//        leftBtn.showsTouchWhenHighlighted = YES;
//    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    }
//}
//
//-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
//    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, parentView.width-wid, 0.5)];
//    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
//    [parentView addSubview:lineIV];
//    
//}
//
//-(void)addArrowWithHeight:(CGFloat)hei ToParentView:(UIView *)parentView{
//    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-30, hei, 15, 15)];
//    arrowIV.image = [UIImage imageNamed:@"c1.png"];
//    [parentView addSubview:arrowIV];
//}
//
//
//- (void)backAction
//{
//    if (self.navigationController.viewControllers.count>2) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else if(self.navigationController.viewControllers.count == 2){
//        [self.navigationController popViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
////    [self.navigationController popViewControllerAnimated:YES];
////    [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
//}
//
////显示正在加载的hud
//-(void)showHud:(NSString *)title{
//    if (_hud == Nil) {
//        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    }
//    _hud.labelText = title;
//    _hud.dimBackground  =YES;
//}
//
//-(void)hideHud{
//    [_hud hide:YES];
//}
//
////现实加载完成的hud
//-(void)completeHud:(NSString *)title{
//    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    _hud.mode = MBProgressHUDModeCustomView;
//    _hud.labelText = title;
//    [_hud hide:YES afterDelay:1];
//}
//
//-(MainViewController *)mainViewController{
//    UIResponder *next = self.nextResponder;
//    do {
//        if ([next isMemberOfClass:[MainViewController class]]) {
//            return (MainViewController *)next;
//        }
//        next = next.nextResponder;
//    } while (next != Nil);
//    return Nil;
//}
//
//- (MMDrawerController *)mmDrawViewController{
//    UIResponder *next = self.nextResponder;
//    do {
//        //判断响应者是否为MainViewController类型
//        if ([next isMemberOfClass:[MMDrawerController class]]) {
//            return (MMDrawerController *)next;
//        }
//        next = next.nextResponder;
//    } while (next != nil);
//    return nil;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
//    {
//        self.view = nil;
//    }
//    
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
//>>>>>>> .r10437
