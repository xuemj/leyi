//
//  PSPhotoController.m
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "PSPhotoController.h"
#import "PSPhotoInfo.h"
#import "PSPhotoCell.h"
#import "NSArray+Additions.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "NSString+Additions.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+Additions.h"
#import "PSConfigs.h"
#import "FailToNetViewController.h"

#define kPhotoDataLimit 10

@interface PSPhotoController ()
{
    UIButton *unableToConnect;
}
@end

@implementation PSPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"亲人照片";

  
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 20);
    [leftButton setImage:[UIImage imageNamed:@"slide.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    unableToConnect = [UIButton buttonWithType:UIButtonTypeCustom];
    if (netStatus != 0) {
        unableToConnect.frame = CGRectMake(0, 0, KScreenWidth, 0);
    }else{
        unableToConnect.frame = CGRectMake(0, 0, KScreenWidth, 40);
    }
    unableToConnect.alpha = 0.7;
    [unableToConnect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    unableToConnect.backgroundColor = [UIColor colorWithRed:1.000 green:0.969 blue:0.653 alpha:1.000];
    [unableToConnect setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [unableToConnect setTitle:@"  小乐没有连上网哦-->检查设置" forState:UIControlStateNormal];
    [unableToConnect addTarget:self action:@selector(connectToFail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unableToConnect];
    [self.view bringSubviewToFront:unableToConnect];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, unableToConnect.bottom, KScreenWidth, KScreenHeight-64-44-5-unableToConnect.height) style:UITableViewStyleGrouped];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    
    _fileCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"PhotoContent.json"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_fileCachePath])
    {
        NSString *jsonString = [NSString stringWithContentsOfFile:_fileCachePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *cacheArray = [jsonString objectFromJSONString];
        self.photoInfoArray = [PSPhotoInfo photoInfosWithPhotoDicArray:cacheArray];
        [_mainTableView reloadData];
    }
    
    [_mainTableView showLoadingWithLabelText:@"正在加载中"];
    [self getDataPhotoFromNetwork:NO];

    __weak PSPhotoController *viewC = self;
    [_mainTableView addHeaderWithCallback:^{
        if (netStatus != 0) {
            [viewC getDataPhotoFromNetwork:NO];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [_mainTableView headerEndRefreshing];
            [_mainTableView hideLoading];

        }
    }];
    [_mainTableView addFooterWithCallback:^{
        if (netStatus != 0) {
            [viewC getDataPhotoFromNetwork:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [_mainTableView footerEndRefreshing];
            [_mainTableView hideLoading];

        }
        
    }];
}

#pragma mark - fail to connectNet
-(void)connectToFail:(UIButton *)btn{
    FailToNetViewController *failVC = [[FailToNetViewController alloc] init];
    [self.navigationController pushViewController:failVC animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
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
        unableToConnect.hidden = NO;
        unableToConnect.frame = CGRectMake(0, 0, KScreenWidth, 40);
        _mainTableView.frame = CGRectMake(0, unableToConnect.bottom, KScreenWidth, KScreenHeight-64-44-5-unableToConnect.height);
        
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        netStatus = 2;
        unableToConnect.frame = CGRectMake(0, 0, KScreenWidth, 0);
        unableToConnect.hidden = YES;
        _mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-44-5-unableToConnect.height);
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        netStatus = 1;
        unableToConnect.hidden = YES;
        unableToConnect.frame = CGRectMake(0, 0, KScreenWidth, 0);
        _mainTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-44-5-unableToConnect.height);
    }
}

#pragma mark leftAction
-(void)leftAction:(UIButton *)btn{
    [self.mmDrawViewController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
    }];
}

#pragma mark - getNetwork
-(void)getDataPhotoFromNetwork:(BOOL)isLoadMore
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        [param setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
        NSString *urlstring = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/shared/%lu/%d/",(isLoadMore?_photoInfoArray.count:0),kPhotoDataLimit];
        
        [DataService requestWithURL:urlstring params:param httpMethod:@"GET" block1:^(id result) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                ITLog([result JSONString]);
//                NSLog(@"%@",result);
                NSArray *arrrA = result;
                
                if (!isLoadMore)
                {
                    if (arrrA.count > 0)
                    {
                        NSString *jsonString = [arrrA JSONString];
                        NSError *error = nil;
                        [jsonString writeToFile:_fileCachePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                    }
                    else
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:_fileCachePath error:nil];
                    }
                }
                
                if (isLoadMore)
                {
                    NSMutableArray *array = [PSPhotoInfo photoInfosWithPhotoDicArray:arrrA];
                    for (int i = 0; i < array.count; i++)
                    {
                        BOOL isHaveDuplicate = NO;
                        PSPhotoInfo *photoInfo1 = array[i];
                        for (int j = 0; j < _photoInfoArray.count; j++)
                        {
                            PSPhotoInfo *photoInfo2 = _photoInfoArray[j];
                            if ([photoInfo1.photoId isEqualToString:photoInfo2.photoId])
                            {
                                isHaveDuplicate = YES;
                                break;
                            }
                        }
                        if (!isHaveDuplicate)
                        {
                            [_photoInfoArray addObject:photoInfo1];
                        }
                    }
                }
                else
                {
                    self.photoInfoArray = [PSPhotoInfo photoInfosWithPhotoDicArray:arrrA];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_mainTableView headerEndRefreshing];
                    [_mainTableView footerEndRefreshing];
                    [_mainTableView hideLoading];
                    __weak PSPhotoController *viewC = self;
//                    [_mainTableView removeHeader];
//                    [_mainTableView removeFooter];
                    if (_photoInfoArray.count == 0)
                    {
                        if (!_backgroundImageView)
                        {
                            _backgroundImageView = [[MDMNoDataBackground alloc] initWithBackGroundImageName:@"smile.png" withTitle:@"还没有好友分享的照片,快去添加亲人吧!" withFrame:CGRectMake(0,self.view.height/2-100,self.view.width,150)];
                            [_mainTableView addSubview:_backgroundImageView];
                        }
                        [_mainTableView bringSubviewToFront:_backgroundImageView];
                        _backgroundImageView.hidden = NO;
                        
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [_mainTableView addHeaderWithCallback:^{
//                                [viewC getDataPhotoFromNetwork:NO];
//                            }];
//                        });
                    }
                    else
                    {
                        _backgroundImageView.hidden = YES;
                        
                        [_mainTableView addHeaderWithCallback:^{
                            [viewC getDataPhotoFromNetwork:NO];
                        }];
                        
                        {
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [_mainTableView addFooterWithCallback:^{
//                                    [viewC getDataPhotoFromNetwork:YES];
//                                }];
//                            });
                        }
                    }
                    
                    [_mainTableView reloadData];
                });
            });
            
        } failLoad:^(id result) {
            
        }];
    });
}

-(void)photoBrowserShowWithPhotoInfo:(PSPhotoInfo *)photoInfo withCurrentIndex:(NSInteger)currentIndex withSrcImageView:(UIImageView *)srcImageView
{
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    NSMutableArray *mjphotos = [NSMutableArray arrayWithCapacity:photoInfo.photoItemArray.count];
    
    NSArray *srcArray = [self getPhotoInfoSrcListWithPhotoInfo:photoInfo];
    for (int i = 0; i < photoInfo.photoItemArray.count; i++)
    {
        PSPhotoItem *item = photoInfo.photoItemArray[i];
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        
//        NSString *compressionString =  coppression;
//        if ([PSConfigs getIphoneType] <= IphoneType_6)
//        {
////            compressionString = kCompression_720;
//        }
//        else if ([PSConfigs getIphoneType] <= IphoneType_6plus)
//        {
////            compressionString = kCompression_1080;
//        }
//        
        NSString *path = [PSConfigs getImageUrlPrefixWithSourcePath:item.path];
        NSArray *pathArray = [path componentsSeparatedByString:@"_"];
        NSString *coppression = [NSString stringWithFormat:@"_compression_%@_%@.jpeg",pathArray[1],pathArray[2]];
        path = [path stringByAppendingString:coppression];
        mjphoto.url = [NSURL URLWithString:path];
//        if (i == currentIndex)
//        {
//            mjphoto.srcImageView = srcImageView;
//        }
        
        if (i < srcArray.count)
        {
            mjphoto.srcImageView = [srcArray objectAtIndex:i];
        }
        else
        {
            mjphoto.srcImageView = [srcArray lastObject];
        }
        if (i >= srcArray.count-1)
        {
            mjphoto.isMoreImage = YES;
        }
        else
        {
            mjphoto.isMoreImage = NO;
        }
        
        mjphoto.placeholder = mjphoto.srcImageView.image;
        [mjphotos addObject:mjphoto];
    }
    browser.photos = mjphotos;
    browser.currentPhotoIndex = currentIndex;
    [browser show];
}

-(NSArray *)getPhotoInfoSrcListWithPhotoInfo:(PSPhotoInfo *)photoInfo
{
    NSMutableArray *srcImageViews = [NSMutableArray arrayWithCapacity:photoInfo.photoItemArray.count];
    if (photoInfo.photoItemArray.count > 0)
    {
        for (int i = 0; i < photoInfo.photoItemArray.count; i += 3)
        {
            PSPhotoCell *cell = (PSPhotoCell *)[_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i/3 inSection:[_photoInfoArray indexOfObject:photoInfo]]];
            NSArray *imageViews = [cell getImageViews];
            [srcImageViews addObjectsFromArray:imageViews];
        }
    }
    return srcImageViews;
}

#pragma mark -UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const identifier = @"PSPhotoCell";
    PSPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PSPhotoCell" owner:nil options:nil];
        cell = [nib firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PSPhotoInfo *info = _photoInfoArray[indexPath.section];
    if (indexPath.row == 0)
    {
        PSPhotoItem *leftItem = [info.photoItemArray PSobjectAtIndex:0];
        PSPhotoItem *middleItem = [info.photoItemArray PSobjectAtIndex:1];
        PSPhotoItem *rightItem = [info.photoItemArray PSobjectAtIndex:2];
        [cell setLeftItem:leftItem withMiddleItem:middleItem withRightItem:rightItem isSectionTwo:NO superVC:self belongtoPhotoInfo:info];
    }
    else
    {
        PSPhotoItem *leftItem = [info.photoItemArray PSobjectAtIndex:3];
        PSPhotoItem *middleItem = [info.photoItemArray PSobjectAtIndex:4];
        PSPhotoItem *rightItem = [info.photoItemArray PSobjectAtIndex:5];
        [cell setLeftItem:leftItem withMiddleItem:middleItem withRightItem:rightItem isSectionTwo:YES superVC:self belongtoPhotoInfo:info];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PSPhotoInfo *info = _photoInfoArray[section];
    if (info.photoNum > 3)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _photoInfoArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
    
    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if(!myHeader) {
        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UIView *view = [[UIView alloc] initWithFrame:myHeader.bounds];
        view.backgroundColor = [UIColor whiteColor];
        myHeader.backgroundView = view;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 16, 300, 30)];
        label.font = [UIFont systemFontOfSize:20];
        label.tag = kHeaderTag;
        [myHeader addSubview:label];
        myHeader.backgroundColor = [UIColor whiteColor];
    }
    
    UILabel *label = (UILabel *)[myHeader viewWithTag:kHeaderTag];
    
    PSPhotoInfo *info = _photoInfoArray[section];
    if ([info.title length] > 0)
    {
        label.text = info.title;
    }
    else
    {
        label.text = @"";
    }
    
    return myHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *FooterIdentifier = @"footer";
    
    UITableViewHeaderFooterView *myFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FooterIdentifier];
    if(!myFooter) {
        myFooter = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:FooterIdentifier];
        
        UIView *view = [[UIView alloc] initWithFrame:myFooter.bounds];
        view.backgroundColor = [UIColor whiteColor];
        myFooter.backgroundView = view;
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 48, 30)];
//        label.font = [UIFont systemFontOfSize:15];
//        label.tag = kFooterTag1;
//        [myFooter addSubview:label];
//        label.text = @"来自于";
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 300, 30)];
        label2.font = [UIFont systemFontOfSize:15];
        label2.textColor = CommonBlue;
        label2.tag = kFooterTag2;
        [myFooter addSubview:label2];
        myFooter.backgroundColor = [UIColor whiteColor];
        
        [self addLineWithWidth:320 withHeight:49.5 toView:myFooter];
    }
    
    UILabel *label = (UILabel *)[myFooter viewWithTag:kFooterTag2];
    
    PSPhotoInfo *info = _photoInfoArray[section];
    if ([info.accountNickName length] > 0)
    {
        label.text = info.accountNickName;
    }
    else
    {
        label.text = info.accountUsn;
    }
    
    return myFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PSPhotoCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - ViewAction
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //开启MMDrawer菜单
    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //禁止MMDrawer菜单
    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
