
//
//  MyLibraryDetailVC.m
//  PictureSaying
//
//  Created by tutu on 14/12/30.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  我的相册明细

#import "MyLibraryDetailVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DataService.h"
#import "MyLibraryDetailItem.h"
#import "UIImageView+WebCache.h"
#import "DoImagePickerController.h"
#import "AssetHelper.h"
#import "UIImage+Compress.h"
#import "BigPicViewController.h"
#import "BaseNaviagtionViewController.h"
#import "CameraViewController.h"
#import "PressViewController.h"
#import "LeftViewController.h"
#import "AppDelegate.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+Additions.h"
#import "PSConfigs.h"
static NSString *identifier;

#define ORIGINAL_MAX_WIDTH 640.0f
@interface MyLibraryDetailVC ()
{
    NSMutableArray *arr ;
    MBProgressHUD *_hud;
    UILabel *tipLabel;
}
@property (nonatomic, strong) UIImageView *portraitImageView;
@end

@implementation MyLibraryDetailVC

#pragma mark LoadView
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_kongZhi isEqualToString:@"YES"]) {
        UIAlertView *altt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加了新的相册，赶紧添加新照片吧~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        altt.tag = 600;
        [altt show];
    }else{
       
    }
    for (int i = 0; i<10000; i++) {
        cls[i] = YES;
    }
    if (self.albumName.length>0) {
        self.title = self.albumName;
    }else{
        self.title = @"相册";
    }
    //collectionView创建
    self.view.backgroundColor = [UIColor clearColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(93*KScreenWidth/320, 93*KScreenWidth/320);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    collectionViewXiang = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)collectionViewLayout:flowLayout];
    [collectionViewXiang registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Identifierhehe"];
    flowLayout.headerReferenceSize = CGSizeMake(0, 50);
    identifier = @"mycell";
    collectionViewXiang.backgroundColor = [UIColor whiteColor];
    [collectionViewXiang registerClass:[MyLibraryDetailItem class] forCellWithReuseIdentifier:identifier];
    collectionViewXiang.dataSource = self;
    collectionViewXiang.delegate = self;
    [self.view addSubview:collectionViewXiang];
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, KScreenHeight+50, KScreenWidth-40, 30)];
    tipLabel.alpha = .75;
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.textAlignment = 1;
    tipLabel.font = [UIFont systemFontOfSize:16.0];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.layer.cornerRadius = 5;
    tipLabel.layer.masksToBounds = YES;
    [self.view addSubview:tipLabel];
    [self _creatNewViewButton];
    [self _createNavItem];
    if (![self.kongZhi isEqualToString:@"YES"]) {
        if (netStatus != 0) {
            [self requestNewData:YES];
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    __weak MyLibraryDetailVC *viewC = self;
    [collectionViewXiang addHeaderWithCallback:^{
      [viewC requestNewData:YES];
    }];
    [collectionViewXiang addFooterWithCallback:^{
      [viewC requestNewData:NO];
    
    }];
    selectedImages = [NSArray array];
    dicArray = [NSMutableArray array];
    photoDelet  = [NSMutableArray array];
        //获取相册里面详细信息
}

-(void)requestNewData:(BOOL)new{
    if(self.Jieshou.length>0){
        [self showHud:@"正在加载..."];
        
        NSUInteger count = 0;
        for (NSDictionary *dic in dicArray)
        {
            count += ((NSArray *)(dic[kPhotos])).count;
        }
        NSString *use = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photo/day/%lu/50",_Jieshou,(new?0:count)];
        [DataService requestWithURL:use params:nil httpMethod:@"GET" block1:^(id result) {
            [self hideHud];
            NSMutableArray  *Pathdaaaaa = [NSMutableArray array];
            NSMutableArray  *imageUrls = [NSMutableArray array];
            PhotoIdAll =[NSMutableArray array];
            NSArray *resultArray = (NSArray *)result;
            if (resultArray.count>0) {
            for (NSDictionary *zidian in result) {
                if (!new) {
                    NSString *newTime = [zidian objectForKey:@"time"];
                    for (NSDictionary *dicc in dicArray) {
                        NSString *hadTime = [dicc objectForKey:@"time"];
                        if ([hadTime isEqualToString:newTime]) {
                            NSMutableArray *oldPhotos = [dicc objectForKey:@"photos"];
                            [oldPhotos addObjectsFromArray:[zidian objectForKey:@"photos"]];
                        }
                    }
                }
                [Pathdaaaaa addObject:zidian];
                NSArray *arrrrr = [zidian objectForKey:@"photos"];
                for (NSDictionary *diiiii in arrrrr) {
                    //我的相册页面所有的ID
                    NSString *PhotoId = [diiiii objectForKey:@"id"];
                    [PhotoIdAll addObject:PhotoId];
                }
            }
                
                if (new)
                {
                    dicArray = Pathdaaaaa;
                }
                
                for (NSDictionary *tempDic in dicArray) {
                    NSArray *arrrrr = [tempDic objectForKey:@"photos"];
                    for (NSDictionary *diiiii in arrrrr) {
                        NSString *strdfghjkl = [diiiii objectForKey:@"path"];
                        //我的相册页面所有的ID
                        [imageUrls addObject:strdfghjkl];
                        
                    }
                }
                selectedImages = imageUrls;
            }else{
                if (new)
                {
                    [QuanxuanButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
                    QuanxuanButton.enabled = NO;
                    [ShanChuButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
                    ShanChuButton.enabled = NO;
                    [TianjiaButton setTitleColor:CommonBlue forState:UIControlStateNormal];
                    TianjiaButton.enabled = YES;
                    tipLabel.hidden = NO;
                    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        tipLabel.text = @"这个相册是空的哦！点击编辑添加吧";
                        CGRect rect = tipLabel.frame;
                        rect.origin.y = KScreenHeight-180;
                        tipLabel.frame = rect;
                    } completion:nil];
                    [self performSelector:@selector(hideTip) withObject:nil afterDelay:3];
                }
                
            }
            [collectionViewXiang headerEndRefreshing];
            [collectionViewXiang footerEndRefreshing];
            [collectionViewXiang hideLoading];
            [collectionViewXiang reloadData];
        } failLoad:^(id result) {
            [collectionViewXiang headerEndRefreshing];
            [collectionViewXiang footerEndRefreshing];
            [collectionViewXiang hideLoading];
        }];
    }

}
-(void)hideTip{
    [UIView animateWithDuration:1.0 animations:^{
        tipLabel.hidden = YES;
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}
#pragma mark - CollecTionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (writeAble) {
        MyLibraryDetailItem *cell = (MyLibraryDetailItem *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isCheck = !cell.isCheck;
        cls[indexPath.row] = cell.isCheck;
        NSString  *sdddID =  [[[dicArray[indexPath.section] objectForKey:@"photos"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        if (!cell.isCheck) {
            [photoDelet addObject:sdddID];
        }else{
            isAll = @"no";
            [photoDelet removeObject:sdddID];
        }
        if (photoDelet.count>0) {
            [ShanChuButton setTitleColor:CommonBlue forState:UIControlStateNormal];
            ShanChuButton.enabled = YES;
            
            [TianjiaButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
            TianjiaButton.enabled = NO;
        }else{
            [ShanChuButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
            ShanChuButton.enabled = NO;
            
            [TianjiaButton setTitleColor:CommonBlue forState:UIControlStateNormal];
            TianjiaButton.enabled = YES;
        }
    }else{
        BigPicViewController *lookVC = [[BigPicViewController alloc] init];
        if (indexPath.section == 0) {
            lookVC.indexPath = indexPath;
        }else{
            NSInteger nextRow = 0;
            for (int i = 0; i<indexPath.section; i++) {
             NSInteger tempCount = [[dicArray[i] objectForKey:@"photos"] count];
             nextRow += tempCount;
            }
            NSIndexPath *ip = [NSIndexPath indexPathForItem:nextRow+indexPath.row inSection:0];
            lookVC.indexPath = ip;
        }
            lookVC.urlsArr = selectedImages;
            BaseNaviagtionViewController *lookNav = [[BaseNaviagtionViewController alloc] initWithRootViewController:lookVC];
            
            [self presentViewController:lookNav animated:YES completion:nil];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array =  [dicArray[section] objectForKey:@"photos"];
    return array.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierhehe" forIndexPath:indexPath];
    UILabel *lab= [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:20.0];
    lab.frame = CGRectMake(15, 0, 200, 50);
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = [dicArray[indexPath.section] objectForKey:@"time"];
    [headView addSubview:lab];
    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        MyLibraryDetailItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        NSArray *array =  [dicArray[indexPath.section] objectForKey:@"photos"];
        cell.path = [array[indexPath.row] objectForKey:@"path"];
        cell.isCheck = cls[indexPath.row];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  dicArray.count;
}

#pragma mark -ScrollView
-(void)showScrollView{
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenHeight-20)];
    theView.alpha = 1;
    theView.tag = 100;
    theView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view.window addSubview:theView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    topLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:180/255.0 blue:58/255.0 alpha:1];
    topLabel.font = [UIFont systemFontOfSize:25.0];
    topLabel.textAlignment = 1;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"预览";
    [theView addSubview:topLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 12, 48, 20);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton addTarget:self action:@selector(removeTheViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:backButton];
    
    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    delButton.frame = CGRectMake(KScreenWidth-50, 12, 40, 20);
    [delButton setTitle:@"删除" forState:UIControlStateNormal];
    [delButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    delButton.showsTouchWhenHighlighted = YES;
    [delButton addTarget:self action:@selector(delViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:delButton];
    
    UIScrollView *theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topLabel.frame), 320, CGRectGetHeight(theView.frame)-44)];
    theScrollView.contentSize = CGSizeMake(320*selectedImages.count, CGRectGetHeight(theScrollView.frame));
    theScrollView.tag = 500;
    theScrollView.pagingEnabled = YES;
    theScrollView.delegate = self;
    theScrollView.backgroundColor = [UIColor clearColor];
    theScrollView.showsHorizontalScrollIndicator = NO;
    theScrollView.showsVerticalScrollIndicator = NO;
    [theView addSubview:theScrollView];

    for (int i = 0; i < selectedImages.count; i++) {
    
        UIScrollView *scrollIV = [[UIScrollView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, CGRectGetHeight(theScrollView.frame))];
        scrollIV.showsHorizontalScrollIndicator = NO;
        scrollIV.delegate = self;
        scrollIV.maximumZoomScale = 3;
        scrollIV.minimumZoomScale = 1;
        scrollIV.tag = 300+i;
        [theScrollView addSubview:scrollIV];
        
        NSString *ig = selectedImages[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-50);
        imageView.tag = 400+i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:ig]];
        [scrollIV addSubview:imageView];
    }
    theScrollView.contentOffset = CGPointMake(KScreenWidth*index, 0);
}

#pragma mark - AlertAction
-(void)showAlert{
    UIAlertView *alttt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alttt show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 600) {
        if (buttonIndex == 1) {
            [self editPortrait];
        }
    }
    else{
        if (buttonIndex == 0) {
            
        }else{
            [self showHud:@"小乐正在删除,不要着急哦..."];
            //网络请求让服务器知道
            NSString *strURlPhotoDeletdd = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v2/album/%@/photo/del",_Jieshou];
            NSArray *keys = @[@"accountUsn",@"photos"];
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            NSArray *vlues = @[[tempDic objectForKey:@"usn"],photoDelet];
            NSMutableDictionary *dicD = [NSMutableDictionary dictionaryWithObjects:vlues forKeys:keys];
            NSDictionary *DICH = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
            [DataService requestWithURL:strURlPhotoDeletdd params:dicD requestHeader:DICH httpMethod:@"POST" block:^(NSObject *result) {
                [self requestNewData];
            } failLoad:^(id result) {
                [self hideHud];
            }];
        }
    }
}
#pragma mark - NewView
//新建三个编辑按钮；
-(void)_creatNewViewButton{
    
        bianjiView  = [[UIView alloc]init];
        bianjiView.frame = CGRectMake(0, KScreenHeight-44-64, KScreenWidth, 44);
        bianjiView.hidden = YES;
        
        bianjiView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bianjiView];
        [self addLineWithWidth:0 withHeight:0 toView:bianjiView];
        
        //全选按钮处理
        QuanxuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        QuanxuanButton.frame =CGRectMake(0, 0, self.view.bounds.size.width/3, 44);
        [QuanxuanButton addTarget: self action:@selector(QuanxuanAction:) forControlEvents:UIControlEventTouchUpInside];
        [QuanxuanButton setTitle:@"全选" forState:UIControlStateNormal];
        [QuanxuanButton setTitleColor:CommonBlue forState:UIControlStateNormal];
        [bianjiView addSubview:QuanxuanButton];
        
        //添加按钮处理
        TianjiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        TianjiaButton.frame =CGRectMake(self.view.bounds.size.width/3,0,self.view.bounds.size.width/3, 44);
        [TianjiaButton setTitle:@"添加" forState:UIControlStateNormal];
        [TianjiaButton setTitleColor:CommonBlue forState:UIControlStateNormal];
        [TianjiaButton addTarget: self action:@selector(TianjiaAction:) forControlEvents:UIControlEventTouchUpInside];
        [bianjiView addSubview:TianjiaButton];
        
        //删除按钮处理
        ShanChuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ShanChuButton.frame =CGRectMake((self.view.bounds.size.width/3)*2, 0, self.view.bounds.size.width/3, 44);
        [ShanChuButton addTarget: self action:@selector(ShanchuAction:) forControlEvents:UIControlEventTouchUpInside];
        [ShanChuButton setTitle:@"删除" forState:UIControlStateNormal];
        [ShanChuButton setTitleColor:CommonBlue forState:UIControlStateNormal];
        [bianjiView addSubview:ShanChuButton];
        
}
#pragma mark - ButtonAction

//编辑按钮处理事件
-(void)rightAction:(UIButton *)rg{
    bianjiView.hidden = !bianjiView.hidden;
    if (bianjiView.hidden) {
        writeAble = NO;
        collectionViewXiang.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
        for (int i = 0; i<PhotoIdAll.count; i++) {
            cls[i] = YES;
        }
        [collectionViewXiang reloadData];
    }else{
        writeAble = YES;
        [ShanChuButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
        ShanChuButton.enabled = NO;
        collectionViewXiang.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-44);
    }
}



/*.......................................................点击出现大图返回按钮处理.....................................................*/
-(void)removeTheViewAction:(UIButton *)btn{
        UIView *theView = btn.superview;
        [theView removeFromSuperview];
        theView = nil;
}

//点击大图出现删除按钮处理
-(void)delViewAction:(UIButton *)bt{
    [self showAlert];
}

//全选处理事件
-(void)QuanxuanAction:(UIButton *)bt{
    bt.selected = !bt.selected;
    if (bt.selected) {
        for (int i = 0; i<PhotoIdAll.count; i++) {
            cls[i] = NO;
        }
        isAll = @"yes";
        [collectionViewXiang reloadData];
        [ShanChuButton setTitleColor:CommonBlue forState:UIControlStateNormal];
        ShanChuButton.enabled = YES;
        [TianjiaButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
        TianjiaButton.enabled = NO;
        photoDelet = PhotoIdAll;
    }else{
        for (int i = 0; i<PhotoIdAll.count; i++) {
            cls[i] = YES;
        }
        isAll = @"no";
        [collectionViewXiang reloadData];
        [ShanChuButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
        ShanChuButton.enabled = NO;
        [TianjiaButton setTitleColor:CommonBlue forState:UIControlStateNormal];
        TianjiaButton.enabled = YES;
        photoDelet = [NSMutableArray array];
    }
    
}

//添加处理事件
-(void)TianjiaAction:(UIButton *)bt{
    [self editPortrait];
}

//编辑全选删除按钮处理事件
-(void)ShanchuAction:(UIButton *)bt{
    if ([isAll isEqualToString:@"yes"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定删除所有照片么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];

    }else{
        if (photoDelet.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有选择要删除的照片哦~" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }else{
            UIAlertView *delAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定删除这些照片么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [delAlert show];
            
        }

    }
}
#pragma mark - RequestNewDate
-(void)requestNewData{
        NSString *use = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photo/day/0/50",_Jieshou];
        [DataService requestWithURL:use params:nil httpMethod:@"GET" block1:^(id result) {
            NSMutableArray  *Pathdaaaaa = [NSMutableArray array];
            NSMutableArray  *imageUrls = [NSMutableArray array];
            PhotoIdAll =[NSMutableArray array];
            NSArray *resultArray = (NSArray *)result;
            if (resultArray.count>0) {
                for (NSDictionary *zidian in resultArray) {
                    [Pathdaaaaa addObject:zidian];
                    NSArray *arrrrr = [zidian objectForKey:@"photos"];
                    for (NSDictionary *diiiii in arrrrr) {
                        NSString *strdfghjkl = [diiiii objectForKey:@"path"];
                        //我的相册页面所有的ID
                        NSString *PhotoId = [diiiii objectForKey:@"id"];
                        [PhotoIdAll addObject:PhotoId];
                        [imageUrls addObject:strdfghjkl];
                    }
                }
                for (int i = 0; i<PhotoIdAll.count; i++) {
                    cls[i] = YES;
                }
                selectedImages = imageUrls;
                dicArray = Pathdaaaaa;
                [QuanxuanButton setTitleColor:CommonBlue forState:UIControlStateNormal];
                QuanxuanButton.enabled = YES;
                [ShanChuButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
                ShanChuButton.enabled = NO;
                [TianjiaButton setTitleColor:CommonBlue forState:UIControlStateNormal];
                TianjiaButton.enabled = YES;
            }else{
                dicArray = [NSMutableArray array];
                [QuanxuanButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
                QuanxuanButton.enabled = NO;
                [ShanChuButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
                ShanChuButton.enabled = NO;
                [TianjiaButton setTitleColor:CommonBlue forState:UIControlStateNormal];
                TianjiaButton.enabled = YES;
                tipLabel.hidden = NO;
                [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    tipLabel.text = @"这个相册是空的哦！点击编辑添加吧";
                    CGRect rect = tipLabel.frame;
                    rect.origin.y = KScreenHeight-180;
                    tipLabel.frame = rect;
                } completion:nil];
                [self performSelector:@selector(hideTip) withObject:nil afterDelay:3];
            }
            [collectionViewXiang reloadData];

            [self hideHud];
    } failLoad:^(id result) {
     
    }];
}

#pragma mark - HudProgress
-(void)showHud:(NSString *)title{
        if (_hud == Nil) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        _hud.labelText = title;
        _hud.dimBackground  =YES;
}

-(void)hideHud{
    [_hud hide:YES];
    _hud= nil;
}

//现实加载完成的hud
-(void)completeHud:(NSString *)title{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1];
}


- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                UIAlertView *cameraUnable = [[UIAlertView alloc] initWithTitle:@"无法启动相机" message:@"请为乐忆开放相机权限:设置-隐私-相机-乐忆时光-打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [cameraUnable show];
                return;
                
            }
            CameraViewController *cameraVC = [[CameraViewController alloc] init];
            [self presentViewController:cameraVC animated:YES completion:^{
            }];
        }
        
    } else if (buttonIndex == 1) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            UIAlertView *photoUnable = [[UIAlertView alloc] initWithTitle:@"无法打开相册" message:@"请为乐忆开放照片权限:设置-隐私-照片-乐忆时光-打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [photoUnable show];
            return;
        }
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 9;
        if ([PSConfigs getIphoneType] < IphoneType_6)
        {
            cont.nColumnCount = 3;
        }else{
            cont.nColumnCount = 4;
        }
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showHud:@"小乐正在努力上传,请稍等..."];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
        for (int i=0; i<aSelected.count; i++) {
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            UIImage *aimage = [aSelected[i] compressedImage];
            NSString *savename = [NSString stringWithFormat:@"Documents/picture%d.jpg",i+1];
            //Create paths to output images
            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:savename];
            //Write image to jpg
            [UIImageJPEGRepresentation(aimage, 0.8) writeToFile:jpgPath atomically:YES];
//            [parmas setObject:imagedata forKey:[NSString stringWithFormat:@"path%d",i+1]];
            [parmas setObject:jpgPath forKey:[NSString stringWithFormat:@"path%d",i+1]];
            [parmas setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
//            NSLog(@"daxiao =========== %f",imagedata.length/1024.0);
        }
        NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photof",_Jieshou];
        [DataService rrequestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
            [self hideHud];
            [self requestNewData];
        } failLoad:^(id result) {
            
        }];
        
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        [ASSETHELPER clearData];
    }
}


#pragma mark - UINavigationControllerDelegate
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
    {
    }
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 200, 100)];
        _portraitImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editImage =[info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imagedata = UIImageJPEGRepresentation(editImage, 1);
    [collectionViewXiang reloadData];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:imagedata forKey:@"path1"];
    NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photof",_Jieshou];
    [DataService requestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
        [self reloadC];
        [collectionViewXiang reloadData];
    } failLoad:^(id result) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^()
     {
     }];
}

-(void)reloadC{
    NSString *use = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photo/day/0/1000",_Jieshou];
    [DataService requestWithURL:use params:nil httpMethod:@"GET" block1:^(id result) {
        NSArray *result1 = (NSArray *)result;
        NSMutableArray  *Pathdaaaaa = [NSMutableArray array];
        NSMutableArray  *imageUrls = [NSMutableArray array];
        PhotoIdAll =[NSMutableArray array];
        if (result1.count>0) {
            [QuanxuanButton setTitleColor:CommonBlue forState:UIControlStateNormal];
            QuanxuanButton.enabled = YES;
            [ShanChuButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
            ShanChuButton.enabled = YES;
            [TianjiaButton setTitleColor:CommonBlue forState:UIControlStateNormal];
            TianjiaButton.enabled = YES;
            for (NSDictionary *zidian in result) {
                [Pathdaaaaa addObject:zidian];
                NSArray *arrrrr = [zidian objectForKey:@"photos"];
                for (NSDictionary *diiiii in arrrrr) {
                    NSString *strdfghjkl = [diiiii objectForKey:@"path"];
                    //我的相册页面所有的ID
                    NSString *PhotoId = [diiiii objectForKey:@"id"];
                    [PhotoIdAll addObject:PhotoId];
                    [imageUrls addObject:strdfghjkl];
                }
            }
            selectedImages = imageUrls;
            dicArray = Pathdaaaaa;
            [collectionViewXiang reloadData];
        }

    } failLoad:^(id result) {
        
    }];
}

//添加按钮事件处理
-(void)_createNavItem{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 44);
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    leftButton.showsTouchWhenHighlighted = YES;
    [leftButton setTitle:@"编辑" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tightItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = tightItem;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 48, 20);
    //        leftBtn.backgroundColor = [UIColor orangeColor];
    leftBtn.showsTouchWhenHighlighted = YES;
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
}

-(void)backAction{
    
    if (self.navigationController.viewControllers.count>2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.navigationController.viewControllers.count == 2){
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            LeftViewController *leftVC = [[LeftViewController alloc] init];
            
            MainViewController *mainVC = [[MainViewController alloc] init];
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
            mainVC.selectedIndex = 1;
            AppDelegate *dl = [UIApplication sharedApplication].delegate;
            dl.window.rootViewController = drawerController;
            
        });
    }
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}

@end

