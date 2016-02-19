//
//  BigImageController.m
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "BigImageController.h"
#import "ImageDescCollectionView.h"
#import "EventModel.h"
#import "ImageCollectionViewCell.h"
#import "CommentViewController.h"

@interface BigImageController ()<CommentViewControllerDelegate>

@end

@implementation BigImageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"故事详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviItem];
    self.view.backgroundColor = [UIColor colorWithRed:251/255.0 green:248/255.0 blue:241/255.0 alpha:1.0];
    NSInteger height = ios7?0:0;
    photoCV = [[ImageDescCollectionView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, KScreenHeight-64)];
    [self.view addSubview:photoCV];
    if (![self.isOrder isEqualToString:@"yes"]) {
        NSMutableArray *allPics = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        for (EventModel *model in self.data) {
            
//            [allPics addObjectsFromArray:model.pics];
            [allPics addObject:model.pics];
            [titles addObject:model.title];
            
        }
        photoCV.urlsArr = allPics;
        photoCV.titles = titles;
//    photoCV.urlsArr = self.urlsArr;
        [photoCV scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    self.title = [NSString stringWithFormat:@"%d/%d",self.indexPath.row+1,self.urlsArr.count];
    }
    if (netStatus == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
    }else{
        [self requestAllData];
    }
    UIView *changeBG = [[UIView alloc] initWithFrame:CGRectMake(0, photoCV.height-40, KScreenWidth, 40)];
    changeBG.backgroundColor = [UIColor blackColor];
    changeBG.alpha = 0.5;
    [self.view addSubview:changeBG];
    UIButton *changeModel = [UIButton buttonWithType:UIButtonTypeCustom];
    changeModel.frame = CGRectMake(KScreenWidth-35,photoCV.height-30, 20, 20);
    [changeModel setBackgroundImage:[UIImage imageNamed:@"changeModel"] forState:UIControlStateNormal];
    [changeModel addTarget:self action:@selector(changeModelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeModel];

}

-(void)changeModelAction:(UIButton *)btn{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能尚未开通,敬请期待!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    [alert show];
    
//    BaseViewController *vc= [[BaseViewController alloc] init];
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
//        [self.navigationController pushViewController:vc animated:YES];
//
//    } completion:^(BOOL finished) {
//        
//    }];
    CommentViewController *myEventComment = [[CommentViewController alloc] init];
    myEventComment.fromEvent = @"yes";
    if ([self.isMine isEqualToString:@"yes"]) {
        myEventComment.isMine = @"yes";
    }else{
        myEventComment.isMine = @"no";
    }
    NSArray *cells = photoCV.visibleCells;
    ImageCollectionViewCell *cell = cells[0];
    NSInteger section = 0;
    for (int i = 0; i<self.data.count; i++) {
        EventModel *small = self.data[i];
        for (int j = 0; j<small.pics.count; j++) {
            NSDictionary *dic = small.pics[j];
            if ([dic isEqual:cell.url]) {
                section = i;
            }
        }
    }
    myEventComment.delegate = self;
    EventModel *model = self.data[section];
    model.accountAva = self.mmodel.accountAva;
    model.accountNickName = self.mmodel.accountNickName;
    myEventComment.storyId = model.storyId;
    myEventComment.eventId = model.eventId;
    myEventComment.emodel = model;
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:myEventComment animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
    
}

-(void)requestAllData{
    if ([self.isOrder isEqualToString:@"yes"]) {
        [self showHud:@"精彩马上开始,请稍等..."];
    }
        NSString *strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/0/10000",[self.data[0] storyId]];
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
        [DataService requestWithURL:strUrl params:params httpMethod:@"GET" block1:^(id result) {
            NSArray *tempArray = (NSArray *)result;
            if (tempArray.count>0) {
                NSMutableArray *allPics = [NSMutableArray array];
                NSMutableArray *titles = [NSMutableArray array];
                for (NSDictionary *model in tempArray) {
                    [allPics addObject:[model objectForKey:@"pics"]];
                    [titles addObject:[model objectForKey:@"title"]];
                }
                photoCV.urlsArr = allPics;
                photoCV.titles = titles;
                if ([self.isOrder isEqualToString:@"yes"]) {
                    NSMutableArray *allPics1 = [NSMutableArray array];
                    for (int i = allPics.count-1; i>=0; i--) {
                        [allPics1 addObject:allPics[i]];
                    
                    }
                    photoCV.urlsArr = allPics1;
                    
                }
                [photoCV reloadData];
                [self hideHud];
            }
        } failLoad:^(id result) {
            [self hideHud];
        }];
    
}

-(void)setNaviItem{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 48, 20);
    leftBtn.showsTouchWhenHighlighted = YES;
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

-(void)leftAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showOrHiddenNavigationBarAndStatusBar{
    if (ios7) {
        /*在ios7上
         setNeedsStatusBarAppearanceUpdate:刷新状态栏的显示
         此方法会触发调用当前控制器的
         - (BOOL)prefersStatusBarHidden 显示/隐藏电池条
         - (UIStatusBarStyle)preferredStatusBarStyle方法，
         */
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO animated:NO];
    self.navigationController.navigationBarHidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
