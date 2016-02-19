//
//  WhoCanLookViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/27.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  谁可以看

#import "WhoCanLookViewController.h"
#import "MyFamilyViewController.h"

@interface WhoCanLookViewController ()

@end

@implementation WhoCanLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"谁可以看";
    [self _createNavItems];
    [self _initViews];
}

-(void)_createNavItems{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,60, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0,0,60, 44);
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)_initViews{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, 45*4)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.tag = 100;
    [self.view addSubview:bgView];
    
    [self addLineWithWidth:0 withHeight:0 toView:bgView];
    
    UIButton *ownCanLook = [UIButton buttonWithType:UIButtonTypeCustom];
    ownCanLook.frame = CGRectMake(15, 0.5, KScreenWidth-20, 44);
    [ownCanLook setTitleColor:rgb(57, 57, 57, 1) forState:UIControlStateNormal];
    [ownCanLook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [ownCanLook setTitle:@"公开(所有好友可见)" forState:UIControlStateNormal];
    [ownCanLook addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:ownCanLook];
    
    UIImageView *checkIV1 = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-30, (ownCanLook.height-18)/2, 18, 18)];
    checkIV1.tag = 101;
    checkIV1.image = [UIImage imageNamed:@"yesCheck.png"];
    [bgView addSubview:checkIV1];
    [self addLineWithWidth:0 withHeight:ownCanLook.bottom toView:bgView];
    
    UIButton *allfriendCanLook = [UIButton buttonWithType:UIButtonTypeCustom];
    allfriendCanLook.frame = CGRectMake(15, 45, KScreenWidth-20, 44);
    [allfriendCanLook setTitleColor:rgb(57, 57, 57, 1) forState:UIControlStateNormal];
    [allfriendCanLook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [allfriendCanLook setTitle:@"对所有好友可见" forState:UIControlStateNormal];
    [allfriendCanLook addTarget:self action:@selector(allfriendAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:allfriendCanLook];
    UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(allfriendCanLook.width-20, (allfriendCanLook.height-15)/2, 18, 18)];
    check.image = [UIImage imageNamed:@"yesCheck.png"];
    [allfriendCanLook addSubview:check];
    check.tag = 103;
    check.hidden = YES;
    [self addLineWithWidth:0 withHeight:allfriendCanLook.bottom toView:bgView];
    
    UIButton *someoneCanLook = [UIButton buttonWithType:UIButtonTypeCustom];
    someoneCanLook.frame = CGRectMake(15, 45+44.5, KScreenWidth-20, 44);
    [someoneCanLook setTitleColor:rgb(57, 57, 57, 1) forState:UIControlStateNormal];
    [someoneCanLook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [someoneCanLook setTitle:@"指定好友可见" forState:UIControlStateNormal];
    [someoneCanLook addTarget:self action:@selector(someoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:someoneCanLook];
    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(someoneCanLook.width-20, (someoneCanLook.height-15)/2, 15, 15)];
    arrowIV.image = [UIImage imageNamed:@"c1.png"];
    [someoneCanLook addSubview:arrowIV];
    [self addLineWithWidth:0 withHeight:someoneCanLook.bottom toView:bgView];
    
    UIButton *openCanLook = [UIButton buttonWithType:UIButtonTypeCustom];
    openCanLook.frame = CGRectMake(15, 45+44.5+44.5, KScreenWidth-20, 44);
    [openCanLook setTitleColor:rgb(57, 57, 57, 1) forState:UIControlStateNormal];
    [openCanLook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [openCanLook setTitle:@"仅自己可见" forState:UIControlStateNormal];
    [openCanLook addTarget:self action:@selector(ownAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:openCanLook];
    UIImageView *checkIV3 = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-30, someoneCanLook.bottom+(openCanLook.height-18)/2, 18, 18)];
    checkIV3.tag = 102;
    checkIV3.image = [UIImage imageNamed:@"yesCheck.png"];
    [bgView addSubview:checkIV3];
    checkIV3.hidden = YES;
    [self addLineWithWidth:0 withHeight:bgView.height-0.5 toView:bgView];
    
    if ([self.isOpen isEqualToString:@"公开"]) {
        checkIV1.hidden = NO;
        checkIV3.hidden = YES;
        check.hidden = YES;
    }else if ([self.isOpen isEqualToString:@"所有好友"]){
        checkIV1.hidden = YES;
        checkIV3.hidden = YES;
        check.hidden = NO;
    }else if ([self.isOpen isEqualToString:@"私密"]){
        checkIV1.hidden = YES;
        checkIV3.hidden = NO;
        check.hidden = YES;
    }else{
        checkIV1.hidden = YES;
        checkIV3.hidden = YES;
        check.hidden = YES;
    }
}

-(void)allfriendAction:(UIButton *)sender{

    
    UIView *bgView = [self.view viewWithTag:100];
    UIImageView *checkIV1 = (UIImageView *)[bgView viewWithTag:101];
    checkIV1.hidden = YES;
    UIImageView *checkIV2 = (UIImageView *)[bgView viewWithTag:102];
    checkIV2.hidden = YES;
    UIImageView *check = (UIImageView *)[bgView viewWithTag:103];
    check.hidden = NO;
}

-(void)ownAction:(UIButton *)btn{
    
    UIView *bgView = [self.view viewWithTag:100];
    UIImageView *checkIV2 = (UIImageView *)[bgView viewWithTag:102];
    checkIV2.hidden = NO;
    UIImageView *checkIV1 = (UIImageView *)[bgView viewWithTag:101];
    checkIV1.hidden = YES;
    UIImageView *check = (UIImageView *)[bgView viewWithTag:103];
    check.hidden = YES;
    
}

-(void)someoneAction:(UIButton *)btn{
//    UIView *bgView = [self.view viewWithTag:100];
//    UIImageView *checkIV1 = (UIImageView *)[bgView viewWithTag:101];
//    checkIV1.hidden = YES;
//    UIImageView *checkIV2 = (UIImageView *)[bgView viewWithTag:102];
//    checkIV2.hidden = YES;
//    UIImageView *check = (UIImageView *)[bgView viewWithTag:103];
//    check.hidden = YES;
    MyFamilyViewController *myFamily = [[MyFamilyViewController alloc] init];
    myFamily.isInvite = @"yes";
    myFamily.storyId = self.sssid;
    UIView *bgView = [self.view viewWithTag:100];
    UIImageView *checkIV2 = (UIImageView *)[bgView viewWithTag:102];
    checkIV2.hidden = YES;
    UIImageView *checkIV1 = (UIImageView *)[bgView viewWithTag:101];
    checkIV1.hidden = YES;
    UIImageView *check = (UIImageView *)[bgView viewWithTag:103];
    check.hidden = YES;
    [self.navigationController pushViewController:myFamily animated:YES];
}

-(void)openAction:(UIButton *)btn{
    UIView *bgView = [self.view viewWithTag:100];
    UIImageView *checkIV1 = (UIImageView *)[bgView viewWithTag:101];
    checkIV1.hidden = NO;
    UIImageView *checkIV2 = (UIImageView *)[bgView viewWithTag:102];
    checkIV2.hidden = YES;
    UIImageView *check = (UIImageView *)[bgView viewWithTag:103];
    check.hidden = YES;
}

-(void)cancelAction:(UIButton *)btn{
    if (self.navigationController.viewControllers.count>2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.navigationController.viewControllers.count == 2){
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    UIView *bgView = [self.view viewWithTag:100];
//    UIImageView *checkIV2 = (UIImageView *)[bgView viewWithTag:102];
//    UIImageView *checkIV1 = (UIImageView *)[bgView viewWithTag:101];
//    if (self.isOpen.length>0) {
//        if ([self.isOpen isEqualToString:@"私密"]) {
//            checkIV2.hidden = NO;
//            checkIV1.hidden = YES;
//        }else if ([self.isOpen isEqualToString:@"公开"]){
//            checkIV2.hidden = YES;
//            checkIV1.hidden = NO;
//        }else{
//            checkIV2.hidden = YES;
//            checkIV1.hidden = YES;
//        }
//    }
}

-(void)doneAction:(UIButton *)btn{
    UIView *bgView = [self.view viewWithTag:100];
    UIImageView *checkIV2 = (UIImageView *)[bgView viewWithTag:102];
    UIImageView *checkIV1 = (UIImageView *)[bgView viewWithTag:101];
    UIImageView *check = (UIImageView *)[bgView viewWithTag:103];
    if (!checkIV1.hidden) {
        self.str = @"公开";
    }else if (!checkIV2.hidden){
        self.str = @"私密";
    }else if(!check.hidden){
        self.str = @"所有好友";
    }else{
        self.str = @"指定好友";
    }
    if (self.navigationController.viewControllers.count>2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.navigationController.viewControllers.count == 2){
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }

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
