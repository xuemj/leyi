//
//  RecordViewController.m
//  PictureSaying
//
//  Created by tutu on 15/1/26.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "RecordViewController.h"
#import "CreateViewController.h"
#import "DiscoveryViewController.h"
#import "CreateStoryViewController.h"
#import "MainModel.h"
#import "MobClick.h"
#import "MDMNoDataBackground.h"
//#import "IndexModel.h"

@interface RecordViewController ()<BaseTableViewDelegate,CommentViewControllerDelegate>
{
    NSTimer *timer1;
    NSTimer *timer2;
    //NSMutableArray *arrPublish;
    NSMutableArray *storys;
    MDMNoDataBackground     *_backgroundImageView;
}
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = rgb(240, 240, 240, 1);
    self.title = @"我的故事";
    
    //WeiXiao/api/v1/user/userSubscriber/{userId}/{subscriberId}
    
    //初始化数组
    //arrPublish = [NSMutableArray array];
    self.data = [NSMutableArray array];
    self.data1 = [NSMutableArray array];
    self.friendData = [NSMutableArray array];
    self.mineData = [NSMutableArray array];
    storys = [NSMutableArray array];
    [self _createNavItem];
    [self _initBehindTableView];
    [self _initFrontTableView];
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-200)/2, KScreenHeight+50, 200, 30)];
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.textAlignment = 1;
    tipLabel.font = [UIFont systemFontOfSize:16.0];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.layer.cornerRadius = 5;
    tipLabel.layer.masksToBounds = YES;
    [self.view addSubview:tipLabel];
    
    finishTipLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-200)/2, KScreenHeight+50, 200, 30)];
    finishTipLabel.backgroundColor = [UIColor blackColor];
    finishTipLabel.textAlignment = 1;
    finishTipLabel.font = [UIFont systemFontOfSize:16.0];
    finishTipLabel.textColor = [UIColor whiteColor];
    finishTipLabel.layer.cornerRadius = 5;
    finishTipLabel.layer.masksToBounds = YES;
    [self.view addSubview:finishTipLabel];
    if (netStatus != 0) {
        
        [self showHud:@"精彩马上开始..."];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接,请检查您的网络设置!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }

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
    _hud = nil;
}


-(void)reloadTableView:(BaseTableView *)tv{
    [tv reloadData];
}

-(void)_initTabBar{
    //    float y = ios7?KScreenHeight-49:KScreenHeight-49-20;
    _tabBarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, KScreenWidth, 49)];
    _tabBarImgView.backgroundColor = [UIColor whiteColor];
    _tabBarImgView.userInteractionEnabled = YES;
    _tabBarImgView.multipleTouchEnabled = YES;
    _tabBarImgView.alpha = 0.88;
    [self.view addSubview:_tabBarImgView];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self _loadNewFriendData];
    [self _loadNewMineData];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

-(void)_initFrontTableView{
    _tableView = [[RecordTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-44-5)];
    _tableView.tag = 101;
    _tableView.backgroundColor = rgb(240, 240, 240, 1);
    _tableView.refreshDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = (KScreenHeight-64)/3;
    [self.view addSubview:_tableView];
}

-(void)_initBehindTableView{
    _tableView1 = [[RecordTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-44-5)];
    _tableView1.tag = 100;
    _tableView1.backgroundColor = rgb(240, 240, 240, 1);
    _tableView1.refreshDelegate = self;
    [_tableView1 showLoadingView:NO];
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView1.rowHeight = (KScreenHeight-64)/3;
    [self.view addSubview:_tableView1];

}

-(void)_createNavItem{
    UIView *switchView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, KScreenWidth-200, 30)];
    switchView.backgroundColor = [UIColor clearColor];
    switchView.clipsToBounds = YES;
    switchView.layer.borderWidth = 1.5;
    switchView.layer.borderColor = [[UIColor whiteColor] CGColor];
    switchView.layer.cornerRadius = 5;
    self.navigationItem.titleView = switchView;
    
    UIButton *friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    friendButton.frame = CGRectMake(0, 1.5, (KScreenWidth-200)/2, 28);
    friendButton.backgroundColor = [UIColor whiteColor];
    [friendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [friendButton setTitleColor:CommonBlue forState:UIControlStateSelected];
    friendButton.selected = YES;
    friendButton.userInteractionEnabled = NO;
    friendButton.tag = 100;
    friendButton.titleLabel.textAlignment = 1;
    friendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [friendButton setTitle:@"动态" forState:UIControlStateNormal];
    [friendButton addTarget:self action:@selector(friendAction:) forControlEvents:UIControlEventTouchUpInside];
    [switchView addSubview:friendButton];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(friendButton.right, 1.5, (KScreenWidth-200)/2, 28);
    myButton.backgroundColor = CommonBlue;
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myButton setTitleColor:CommonBlue forState:UIControlStateSelected];
    myButton.tag = 101;
    myButton.titleLabel.textAlignment = 1;
    myButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [myButton setTitle:@"我" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
    [switchView addSubview:myButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0,0,60, 44);
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    rightButton.showsTouchWhenHighlighted = YES;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"创建" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)commentCountRefresh
{
    [_tableView reloadData];
    [_tableView1 reloadData];
}

#pragma mark - Action
-(void)friendAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    btn.selected = !btn.selected;
    UIView *view = btn.superview;
    UIButton *but = (UIButton *)[view viewWithTag:101];
    but.selected = NO;
    but.userInteractionEnabled = YES;
    if (btn.selected) {
        btn.backgroundColor = [UIColor whiteColor];
        but.backgroundColor = CommonBlue;
    }else{
        btn.backgroundColor = CommonBlue;
        but.backgroundColor = [UIColor whiteColor];
    }
    [self superView:self.view flag:btn.selected];
    [MobClick event:@"pengyougushi"];
}

-(void)myAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    btn.selected = !btn.selected;
    UIView *view = btn.superview;
    UIButton *but = (UIButton *)[view viewWithTag:100];
    but.selected = NO;
    but.userInteractionEnabled = YES;
    if (btn.selected) {
        btn.backgroundColor = [UIColor whiteColor];
        but.backgroundColor = CommonBlue;
    }else{
        btn.backgroundColor = CommonBlue;
        but.backgroundColor = [UIColor whiteColor];
    }
    [self superView:self.view flag:!btn.selected];
    [MobClick event:@"zijigushi"];
}

//翻转动画实现方法
-(void)superView:(UIView *)view flag:(BOOL)flag{
    UIViewAnimationOptions flip = flag?UIViewAnimationOptionCurveEaseIn:
    UIViewAnimationOptionCurveEaseOut;
    [UIView transitionWithView:view duration:0.8 options:flip animations:^{
        [view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:nil];
}

-(void)rightAction:(UIButton *)btn{
    CreateViewController *createVC = [[CreateViewController alloc] init];
    
    [self.navigationController pushViewController:createVC animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
    _imagePicker = nil;
    UIImage *theImage = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        }
//        NSLog(@"%@",theImage);
    }
    
}

#pragma mark camera utility
-(BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
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

-(void)pullDone:(BaseTableView *)tableView{
    if (tableView.tag == 100) {
        //me
        if (netStatus != 0) {
            [self _loadNewMineData];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [CommonAlert showAlertWithTitle:@"提示" withMessage:@"无网络连接,请 检查您的网络设置!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
                [self hiddenHeaderRefresh1:_tableView1];
            });
        }
    }else if(tableView.tag == 101){
        //friend
        if (netStatus != 0) {
            [self _loadNewFriendData];
        }else{
            [CommonAlert showAlertWithTitle:@"提示" withMessage:@"无网络连接,请 检查您的网络设置!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hiddenHeaderRefresh1:_tableView];
            });
        }
    }
}

-(void)_loadNewFriendData{
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSString *strUrling;

        strUrling = [NSString stringWithFormat:@"/WeiXiao/api/v1/event/userFriendEvent/list/%@/0/15",[tempDic objectForKey:@"usn"]];
    [DataService requestWithURL:strUrling params:params1 httpMethod:REQ_GET block1:^(id result) {
        [self hideHud];
        NSArray *array = (NSArray *)result;
        NSMutableArray *newFriendData = [NSMutableArray array];
        if(array.count>0){
            for (int i = 0;i<array.count;i++) {
                NSDictionary *dic = array[i];
                MainModel *model = [[MainModel alloc] initContentWithDic:dic];
                NSString *isodd = i%2 == 0?@"1":@"0";
                model.isOdd = isodd;
                model.descrip = [dic objectForKey:@"title"];
                model.accountNickName = @"高圆圆圆圆是个胖子~";
                model.usn = [dic objectForKey:@"accountUsn"];
                model.zanCount = [[dic objectForKey:@"favNum"] stringValue];
                model.commentCount = [[dic objectForKey:@"commentNum"] stringValue];
                model.pics = [dic objectForKey:@"pics"];
                    if (model.pics.count == 0) {
                        
                    }else{
                        [newFriendData addObject:model];
                    }
            }
            self.friendData = newFriendData;
            _tableView.indexData = _friendData;
            [_tableView reloadData];
            _tableView.data = newFriendData;
            
            if (_friendData.count<15) {
                [timer2 invalidate];
                timer2 = nil;
            }
            _backgroundImageView.hidden = YES;
        }else{
            if (!_backgroundImageView)
            {
                _backgroundImageView = [[MDMNoDataBackground alloc] initWithBackGroundImageName:@"smile.png" withTitle:@"还没有亲人的动态哦,快去添加亲人吧!" withFrame:CGRectMake(0,self.view.height/2-100,self.view.width,150)];
                [_tableView addSubview:_backgroundImageView];
            }
            [_tableView bringSubviewToFront:_backgroundImageView];
            _backgroundImageView.hidden = NO;
            tipLabel.hidden = NO;
            _tableView->upLoading = YES;
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                tipLabel.text = @"还没有好友给你分享故事哦！";
                CGRect rect = tipLabel.frame;
                rect.origin.y = KScreenHeight-180;
                tipLabel.frame = rect;
            } completion:nil];
            [self performSelector:@selector(hideTip) withObject:nil afterDelay:2];
        }
        [self hiddenHeaderRefresh1:_tableView];
    } failLoad:^(id result) {
        [self hideHud];
        [self hiddenHeaderRefresh1:_tableView];
    }];
}

-(void)hideTip{
    [UIView animateWithDuration:1.0 animations:^{
        tipLabel.hidden = YES;
    }];
}

-(void)_loadNewMineData{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    NSString *strUrl;
    strUrl = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/myList/%@/0/15",[tempDic objectForKey:@"usn"]];
    [DataService requestWithURL:strUrl params:params1 httpMethod:@"GET" block1:^(id result) {
        [self hideHud];

        NSArray *array = (NSArray *)result;
        NSLog(@"%@",array);
        NSMutableArray *newMineData = [NSMutableArray array];
        NSMutableArray *temp = [NSMutableArray array];
        if (array.count>0) {
            for (int i = 0;i<array.count;i++) {
                NSDictionary *dic = array[i];
                MainModel *model = [[MainModel alloc] initContentWithDic:dic];
                NSString *isodd = i%2 == 0?@"1":@"0";
                model.isOdd = isodd;
                model.usn = [dic objectForKey:@"usn"];
                model.descrip = [dic objectForKey:@"description"];
                [newMineData addObject:model];
                [temp addObject:dic];
            }
            storys = temp;
            self.mineData = newMineData;
            _tableView1.indexData = _mineData;
            _tableView1.storys = temp;
            [_tableView1 reloadData];
            _tableView1.data = newMineData;
            if (_mineData.count<15) {
                [timer1 invalidate];
                timer1 = nil;
            }

        }else{
            tipLabel.hidden = NO;
            _tableView1->upLoading = YES;
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                tipLabel.text = @"您还没有创建故事哦！";
                CGRect rect = tipLabel.frame;
                rect.origin.y = KScreenHeight-180;
                tipLabel.frame = rect;
            } completion:nil];
            [self performSelector:@selector(hideTip) withObject:nil afterDelay:2];
        }
        [self hiddenHeaderRefresh1:_tableView1];
    } failLoad:^(id result) {
        [self hiddenHeaderRefresh1:_tableView1];
        [self hideHud];
    }];
}

-(void)pullUp:(BaseTableView *)tableView{
    if (tableView.tag == 100) {
        //me
        if (netStatus != 0) {
            [self _loadOldMineData];
        }else{
            
        }
    }else if (tableView.tag == 101){
        //friend
        [self _loadOldFriendData];
    }
}

-(void)_loadOldMineData{
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/myList/%@/%d/15",[tempDic objectForKey:@"usn"],self.mineData.count];
    [DataService requestWithURL:urlstring params:params1 httpMethod:@"GET" block1:^(id result) {
        NSArray *array = (NSArray *)result;
        NSMutableArray *oldMineData = [NSMutableArray array];
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0;i<array.count;i++) {
            NSDictionary *dic = array[i];
            MainModel *model = [[MainModel alloc] initContentWithDic:dic];
            NSString *isodd = i%2 == 0?@"1":@"0";
            model.isOdd = isodd;
            model.usn = [dic objectForKey:@"usn"];
            model.descrip = [dic objectForKey:@"description"];
            [oldMineData addObject:model];
            [temp addObject:dic];
        }
        [storys addObjectsFromArray:temp];
        [self.mineData addObjectsFromArray:oldMineData];
        _tableView1.indexData = _mineData;
        _tableView1.storys = storys;
        [_tableView1 reloadData];
        _tableView1.data = oldMineData;
        if (array.count < 15) {
            finishTipLabel.hidden = NO;
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                finishTipLabel.text = @"已经到底啦 ~ ";
                CGRect rect = finishTipLabel.frame;
                rect.origin.y = KScreenHeight-180;
                finishTipLabel.frame = rect;
                [timer1 invalidate];
                timer1 = nil;
            } completion:nil];
            [self performSelector:@selector(hideFinishTip) withObject:nil afterDelay:2];
        }
//        NSArray *keys = @[@"tableView",@"array"];
//        NSArray *values = @[_tableView1,self.mineData];
//        NSDictionary *argDic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
//        [self performSelectorInBackground:@selector(requestZanAndComment:) withObject:argDic];
        //        [self hiddenFooterRefresh:_tableView1];
    } failLoad:^(id result) {
        
    }];
}

-(void)hideFinishTip{
    [UIView animateWithDuration:1.0 animations:^{
        finishTipLabel.hidden = YES;
    }];
}

-(void)_loadOldFriendData{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/event/userFriendEvent/list/%@/%d/%d",[tempDic objectForKey:@"usn"],(int)self.friendData.count,15];
    [DataService requestWithURL:urlstring params:params1 httpMethod:@"GET" block1:^(id result) {

        NSArray *array = (NSArray *)result;
        NSMutableArray *oldFriendData = [NSMutableArray array];
        for (int i = 0;i<array.count;i++) {
            NSDictionary *dic = array[i];
            MainModel *model = [[MainModel alloc] initContentWithDic:dic];
            NSString *isodd = i%2 == 0?@"1":@"0";
            model.isOdd = isodd;
            model.descrip = [dic objectForKey:@"title"];
            model.accountNickName = @"高圆圆圆圆是个胖子~";
            model.usn = [dic objectForKey:@"accountUsn"];
            model.zanCount = [[dic objectForKey:@"favNum"] stringValue];
            model.commentCount = [[dic objectForKey:@"commentNum"] stringValue];
            model.pics = [dic objectForKey:@"pics"];
            if (model.pics.count == 0) {
                
            }else{
                [oldFriendData addObject:model];
            }
        }
        [self.friendData addObjectsFromArray:oldFriendData];
        _tableView.indexData = _friendData;
        [_tableView reloadData];
        _tableView.data = oldFriendData;
        if (array.count < 15) {
            finishTipLabel.hidden = NO;
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                finishTipLabel.text = @"已经到底啦 ~ ";
                CGRect rect = finishTipLabel.frame;
                rect.origin.y = KScreenHeight-180;
                finishTipLabel.frame = rect;
                [timer2 invalidate];
                timer2 = nil;
            } completion:nil];
            [self performSelector:@selector(hideFinishTip) withObject:nil afterDelay:2];
        }
    } failLoad:^(id result) {
        
    }];
}

-(void)hiddenHeaderRefresh1:(RecordTableView *)tv{
    [tv doneLoadingTableViewData];
}

-(void)hiddenFooterRefresh1:(RecordTableView *)tv{
    tv.isRefresh = YES;
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
//        _tableView = nil;
//        _tableView1 = nil;
//        _tabBarImgView = nil;
//        tipLabel = nil;
//        self.view = nil;
//        self.friendData = nil;
//        self.mineData = nil;
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