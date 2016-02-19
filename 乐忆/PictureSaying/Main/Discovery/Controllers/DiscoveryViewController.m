//
//  DiscoveryViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "ZoomIamgeView.h"
#import "UIColor+Hex.h"
#import "PSConfigs.h"
#import "RecordTableView.h"
#import "PSConfigs.h"
#define recommandUrl @"/WeiXiaoSpecialItem/api/v1/si/recom/get/%d/%d"
#define newestUrl @"/WeiXiaoSpecialItem/api/v1/si/new/get/%d/%d"
#define hotestUrl @"/WeiXiaoSpecialItem/api/v1/si/hot/get/%d/%d"
#define storyUrl @"/WeiXiao/api/v1/story//publicList/%d/%d"
#define attentionUrl @"/WeiXiao/api/v1/event/userSubscriberEvent/list/%@/%d/%d"
#import "MobClick.h"

@interface DiscoveryViewController ()
{
    UIView *menuBg;
    int menuCtrl;
}
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation DiscoveryViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    NSString *s = @"/zubaAPI/RegisterLoginAPI";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"18301625870" forKey:@"phone"];
    [dic setObject:@"12345" forKey:@"password"];
     [DataService requestWithURL:s params:dic requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
         NSLog(@"%@",result);
     } failLoad:^(id result) {
         NSLog(@"失败");
     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //禁止MMDrawer菜单
    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = rgb(240, 240, 240, 1);
    self.newestData = [NSMutableArray array];
    self.hotestData = [NSMutableArray array];
    self.attentionData = [NSMutableArray array];
    self.recommandData = [NSMutableArray array];
    self.storyData = [NSMutableArray array];
    [self _createNavItem];
    [self _initMenuView];
//    [self _initBehindTableView];
//    [self _initFrontTableView];
    [self _initMainViews];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusRefresh:) name:kPSLikeStatusChangeNotification object:nil];
    
    finishTipLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-200)/2, KScreenHeight+50, 200, 30)];
    finishTipLabel.backgroundColor = [UIColor blackColor];
    finishTipLabel.textAlignment = 1;
    finishTipLabel.font = [UIFont systemFontOfSize:16.0];
    finishTipLabel.textColor = [UIColor whiteColor];
    finishTipLabel.layer.cornerRadius = 5;
    finishTipLabel.layer.masksToBounds = YES;
    [self.view addSubview:finishTipLabel];


}

-(void)_initMainViews{
    _mainSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, menuBg.bottom, KScreenWidth, KScreenHeight-64-44-40)];
    _mainSV.delegate = self;
    _mainSV.showsHorizontalScrollIndicator = NO;
    _mainSV.contentSize =CGSizeMake(KScreenWidth*5, KScreenHeight-64-44-40);
    _mainSV.pagingEnabled = YES;
    _mainSV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainSV];
    for (int i = 0; i < 5; i++) {
        RecordTableView *tableView = [[RecordTableView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight-64-44-40)];
        tableView.backgroundColor = rgb(240, 240, 240, 1);
        tableView.tag = 150+i;
        tableView.refreshDelegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = (KScreenHeight-64)/3;
//        CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
//        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
//        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
//        tableView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//        tableView.backgroundColor = rgb(arc4random() % 256 / 255.0, arc4random() % 256 / 255.0, arc4random() % 256 / 255.0, 1);
        [_mainSV addSubview:tableView];
        
    }
}

-(void)_initMenuView{
    menuBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    menuBg.backgroundColor = rgb(248, 248, 248, 1);
    [self.view addSubview:menuBg];
    NSArray *buttonTitle = @[@"推荐",@"最新",@"最热",@"故事",@"关注"];
    for (int i = 0; i<buttonTitle.count; i++) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(KScreenWidth/5*i, 0, KScreenWidth/5, 40);
        menuButton.tag = 200+i;
        menuButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [menuButton setTitle:buttonTitle[i] forState:UIControlStateNormal];
        [menuButton setTitleColor:rgb(153, 153, 153, 1) forState:UIControlStateNormal];
        [menuButton setTitleColor:CommonBlue forState:UIControlStateSelected];
        [menuButton addTarget:self action:@selector(menuSelect:) forControlEvents:UIControlEventTouchUpInside];
        [menuBg addSubview:menuButton];
        if (i == 0) {
            CGAffineTransform tf = menuButton.transform;
            menuButton.transform = CGAffineTransformScale(tf, 1.3, 1.3);
            menuButton.selected = YES;
            menuCtrl = menuButton.tag;
        }
        
    }
    UILabel *yellowLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 37.5, KScreenWidth/5, 2.5)];
    yellowLine.tag = 205;
    yellowLine.backgroundColor = CommonBlue;
    [menuBg addSubview:yellowLine];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.newestData.count>0&&self.hotestData.count>0) {
//        NSArray *keys = @[@"tableView",@"array"];
//        NSArray *values = @[_tableView1,self.hotestData];
//        NSDictionary *argDic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
//        NSArray *keys1 = @[@"tableView",@"array"];
//        NSArray *values1 = @[_tableView,self.newestData];
//        NSDictionary *argDic1 = [NSDictionary dictionaryWithObjects:values1 forKeys:keys1];
//        [self requestZanAndComment:argDic];
//        [self requestZanAndComment:argDic1];
//    }
    
    if (netStatus == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else{
//        [self _requstTestData:@"recommand"];
//        [self _requstTestData:@"newest"];
//        [self _requstTestData:@"hotest"];
//        [self _requstTestData:@"story"];
//        [self _requstTestData:@"attention"];
        [self _loadNewNewestData:150];
        [self _loadNewNewestData:151];
        [self _loadNewNewestData:152];
        [self _loadNewNewestData:153];
        [self _loadNewNewestData:154];
        
    }
}

#pragma mark - RequestData And InitViews
-(void)_requstTestData:(NSString *)type{
    NSString *url;
    int tableTag;
    if ([type isEqualToString:@"recommand"]) {
        url = [NSString stringWithFormat:recommandUrl,0,15];
        tableTag = 150;
    }else if ([type isEqualToString:@"newest"]){
        url = [NSString stringWithFormat:newestUrl,0,15];
        tableTag = 151;
    }else if ([type isEqualToString:@"hotest"]){
        url = [NSString stringWithFormat:hotestUrl,0,15];
        tableTag = 152;
    }else if ([type isEqualToString:@"story"]){
        url = [NSString stringWithFormat:storyUrl,0,15];
        tableTag = 153;
    }else if ([type isEqualToString:@"attention"]){
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        url = [NSString stringWithFormat:attentionUrl,[tempDic objectForKey:@"usn"],0,15];
        tableTag = 154;
    }else{
        return;
    }
    [self showHud:@"精彩马上开始..."];
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    [DataService requestWithURL:url params:params1 httpMethod:@"GET" block1:^(id result) {
        
        [self hideHud];
        NSArray *array;
        if ([type isEqualToString:@"story"]||[type isEqualToString:@"attention"]) {
            array = (NSArray *)result;
        }else{
            NSDictionary *resultDic = (NSDictionary *)result;
            array = [resultDic objectForKey:@"value"];
        }
        NSMutableArray *tempArray = [NSMutableArray array];
        if (array.count>0) {
            for (int i = 0;i<array.count;i++) {
                NSDictionary *dic = array[i];
                MainModel *model = [[MainModel alloc] initContentWithDic:dic];
                NSString *isodd = i%2 == 0?@"1":@"0";
                model.isOdd = isodd;
//                if ([dic objectForKey:@"templateId"]) {
//                    model.templateId = @"1";
//                }else{
//                    model.templateId = [dic objectForKey:@"templateId"];
//                }
                if ([type isEqualToString:@"story"]) {
                    model.usn = [dic objectForKey:@"usn"];
                }else{
                    model.usn = [dic objectForKey:@"accountUsn"];
                }
                model.descrip = [dic objectForKey:@"title"];
                model.accountNickName = @"高圆圆圆圆是个胖子~";
//                model.image = @"";
                model.zanCount = [[dic objectForKey:@"favNum"] stringValue];
                model.commentCount = [[dic objectForKey:@"commentNum"] stringValue];
//                model.zanCount = @"255";
//                model.commentCount = @"999";
//                model.isZan = [dic objectForKey:@"exitFav"];
//                model.pics = @[@"222",@"222"];
                model.pics = [dic objectForKey:@"pics"];
                if (tableTag != 103) {
                    if (model.pics.count == 0) {
                        
                    }else{
                        [tempArray addObject:model];
                    }
                }else{
                    [tempArray addObject:model];
                }
                
            }
            RecordTableView *recommendTableView = (RecordTableView *)[_mainSV viewWithTag:tableTag];
            if ([type isEqualToString:@"recommand"]) {
                self.recommandData = tempArray;
                recommendTableView.indexData = _recommandData;
                [recommendTableView reloadData];
                recommendTableView.data = _recommandData;
            }else if ([type isEqualToString:@"newest"]){
                self.newestData = tempArray;
                recommendTableView.indexData = _newestData;
                [recommendTableView reloadData];
                recommendTableView.data = _newestData;
            }else if ([type isEqualToString:@"hotest"]){
                self.hotestData = tempArray;
                recommendTableView.indexData = _hotestData;
                [recommendTableView reloadData];
                recommendTableView.data = _hotestData;
            }else if ([type isEqualToString:@"story"]){
                self.storyData = tempArray;
                recommendTableView.indexData = _storyData;
                [recommendTableView reloadData];
                recommendTableView.data = _storyData;
            }else if ([type isEqualToString:@"attention"]){
                self.attentionData = tempArray;
                recommendTableView.indexData = _attentionData;
                [recommendTableView reloadData];
                recommendTableView.data = _attentionData;
            }
            finishTipLabel.hidden = NO;
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                finishTipLabel.text = @"乐意分享，我乐意~";
                CGRect rect = finishTipLabel.frame;
                rect.origin.y = KScreenHeight-180;
                finishTipLabel.frame = rect;
            } completion:nil];
            [self performSelector:@selector(hideFinishTip) withObject:nil afterDelay:2];

        }
        
    } failLoad:^(id result) {
        [PSConfigs showProgressWithError:result withView:self.view operationResponseString:nil delayShow:NO isImage:NO];

    }];
    

}


//-(void)likeStatusRefresh:(NSNotification *)noti
//{
//    NSArray *array = noti.object;
//    if (array.count == 3)
//    {
//        IndexModel *indexModel = array[0];
//        EventModel *eventModel = array[1];
//        enum likeType type = [array[2] intValue];
//        
//        if (type == likeType_Story)
//        {
//            for (IndexModel *indexModelTmp in _tableView.indexData)
//            {
//                if ([indexModelTmp.storyId isEqualToString:indexModel.storyId])
//                {
//                    indexModelTmp.isZan = indexModel.isZan;
//                    indexModelTmp.zanCount = indexModel.zanCount;
//                    break;
//                }
//            }
//            
//            for (IndexModel *indexModelTmp in _tableView1.indexData)
//            {
//                if ([indexModelTmp.storyId isEqualToString:indexModel.storyId])
//                {
//                    indexModelTmp.isZan = indexModel.isZan;
//                    indexModelTmp.zanCount = indexModel.zanCount;
//                    break;
//                }
//            }
//            
//            [_tableView reloadData];
//            [_tableView1 reloadData];
//        }
//    }
//}

-(void)_createNavItem{
    self.title = @"发现";
//    UIView *switchView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, 110, 30)];
//    switchView.backgroundColor = [UIColor clearColor];
//    self.navigationItem.titleView = switchView;
//    
//    UIButton *friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    friendButton.frame = CGRectMake(0, 2, 55, 30);
//    [friendButton setBackgroundImage:[UIImage imageNamed:@"yellowl"] forState:UIControlStateNormal];
//    [friendButton setBackgroundImage:[UIImage imageNamed:@"grayl"] forState:UIControlStateSelected];
//    friendButton.selected = YES;
//    friendButton.userInteractionEnabled = NO;
//    friendButton.tag = 100;
//    friendButton.titleLabel.textAlignment = 1;
//    friendButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [friendButton setTitle:@"最新" forState:UIControlStateNormal];
//    [friendButton addTarget:self action:@selector(friendAction:) forControlEvents:UIControlEventTouchUpInside];
//    [switchView addSubview:friendButton];
//    
//    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    myButton.frame = CGRectMake(friendButton.right, 2, 55, 30);
//    [myButton setBackgroundImage:[UIImage imageNamed:@"yellowr"] forState:UIControlStateNormal];
//    [myButton setBackgroundImage:[UIImage imageNamed:@"grayr"] forState:UIControlStateSelected];
//    myButton.tag = 101;
//    myButton.titleLabel.textAlignment = 1;
//    myButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [myButton setTitle:@"最热" forState:UIControlStateNormal];
//    [myButton addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
//    [switchView addSubview:myButton];
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 50, 21);
//    rightButton.showsTouchWhenHighlighted = YES;
//    [rightButton setTitle:@"记录" forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Action
-(void)menuSelect:(UIButton *)btn{
//    for (int i = 0; i < 5; i++) {
//        UIButton *otherButton = (UIButton *)[menuBg viewWithTag:200+i];
//        if (btn.tag == otherButton.tag) {
//            otherButton.selected = YES;
//            if (menuCtrl != btn.tag) {
//                CGAffineTransform tf = otherButton.transform;
//                UILabel *yellowLine = (UILabel *)[menuBg viewWithTag:205];
//                NSLog(@"tx = %f",otherButton.transform.tx);
//                [UIView animateWithDuration:0.4 animations:^{
//                    otherButton.transform = CGAffineTransformScale(tf, 1.3, 1.3);
////                    yellowLine.frame = CGRectMake(otherButton.left, 37.5, KScreenWidth/5, 2.5);
//                }];
//                NSLog(@"coooo = %f",KScreenWidth*(btn.tag-200));
//                mainSV.contentOffset = CGPointMake(KScreenWidth*(btn.tag-200), 0);
//            }
//            menuCtrl = btn.tag;
//        }else{
//            otherButton.selected = NO;
//            [UIView animateWithDuration:0.2 animations:^{
//                otherButton.transform = CGAffineTransformIdentity;
//            }];
//        }
//    }
//    UILabel *yellowLine = (UILabel *)[menuBg viewWithTag:205];
    
    [UIView animateWithDuration:0.4 animations:^{
//        yellowLine.frame = CGRectMake(btn.left, 37.5, KScreenWidth/5, 2.5);
        _mainSV.contentOffset = CGPointMake(KScreenWidth*(btn.tag-200), 0);
    }];
    if (btn.tag == 201) {
        [MobClick event:@"guangchengzuixin"];
    }else if(btn.tag == 202){
        [MobClick event:@"guangchengzuire"];
    }
}

-(void)friendAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    btn.selected = !btn.selected;
    UIView *view = btn.superview;
    UIButton *but = (UIButton *)[view viewWithTag:101];
    but.selected = NO;
    but.userInteractionEnabled = YES;
    [self superView:self.view flag:btn.selected];
}

-(void)myAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    btn.selected = !btn.selected;
    UIView *view = btn.superview;
    UIButton *but = (UIButton *)[view viewWithTag:100];
    but.selected = NO;
    but.userInteractionEnabled = YES;
    [self superView:self.view flag:!btn.selected];
}

//翻转动画实现方法
-(void)superView:(UIView *)view flag:(BOOL)flag{
    UIViewAnimationOptions flip = flag?UIViewAnimationOptionCurveEaseIn:UIViewAnimationOptionCurveEaseOut;
    [UIView transitionWithView:view duration:1.5 options:flip animations:^{
        [view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:nil];
}
//2086207132qq
-(void)rightAction:(UIButton *)btn{

    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float x = scrollView.contentOffset.x;
    UILabel *yellowLine = (UILabel *)[menuBg viewWithTag:205];
    CGRect frame = yellowLine.frame;
    frame.origin.x = x/5;
    yellowLine.frame = frame;
    if(scrollView.contentOffset.x == KScreenWidth){
        [self changeMenu:201];
    }else if (scrollView.contentOffset.x == KScreenWidth*2){
        [self changeMenu:202];
    }else if (scrollView.contentOffset.x == KScreenWidth*3){
        [self changeMenu:203];
    }else if (scrollView.contentOffset.x == KScreenWidth*4){
        [self changeMenu:204];
    }else if (scrollView.contentOffset.x<KScreenWidth){
        [self changeMenu:200];
    }
}

-(void)changeMenu:(int)btnTag{
    for (int i = 0; i < 5; i++) {
        UIButton *otherButton = (UIButton *)[menuBg viewWithTag:200+i];
        if (btnTag == otherButton.tag) {
            otherButton.selected = YES;
            CGAffineTransform tf = otherButton.transform;
            if (menuCtrl != btnTag) {
                [UIView animateWithDuration:0.5 animations:^{
                    otherButton.transform = CGAffineTransformScale(tf, 1.3, 1.3);
                }];
            }
            menuCtrl = btnTag;
        }else{
            otherButton.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                otherButton.transform = CGAffineTransformIdentity;
            }];
        }
    }
}


//#pragma mark - ViewAction
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //开启MMDrawer菜单
//    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    //禁止MMDrawer菜单
//    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//}

#pragma mark - BaseTableViewDelegate
-(void)pullDone:(BaseTableView *)tableView{
    if (netStatus == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        RecordTableView *recommendTableView = (RecordTableView *)[_mainSV viewWithTag:tableView.tag];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
            [self hiddenHeaderRefresh1:recommendTableView];
            });
    }else{
        [self _loadNewNewestData:tableView.tag];
    }
}

-(void)_loadNewNewestData:(int)tableTag{
    NSString *url;
    if (tableTag == 150) {
        url = [NSString stringWithFormat:recommandUrl,0,15];
    }else if (tableTag == 151){
        url = [NSString stringWithFormat:newestUrl,0,15];
    }else if (tableTag == 152){
        url = [NSString stringWithFormat:hotestUrl,0,15];
    }else if (tableTag == 153){
        url = [NSString stringWithFormat:storyUrl,0,15];
    }else if (154){
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        url = [NSString stringWithFormat:attentionUrl,[tempDic objectForKey:@"usn"],0,15];
    }else{
        return;
    }
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    [DataService requestWithURL:url params:params1 httpMethod:@"GET" block1:^(id result) {
        
        NSArray *array;
        if (tableTag == 153||tableTag == 154) {
            array = (NSArray *)result;
        }else{
            NSDictionary *resultDic = (NSDictionary *)result;
            array = [resultDic objectForKey:@"value"];
        }
        RecordTableView *recommendTableView = (RecordTableView *)[_mainSV viewWithTag:tableTag];
        if (array.count>0) {
            NSMutableArray *newNewestData = [NSMutableArray array];
            for (int i = 0;i<array.count;i++) {
                NSDictionary *dic = array[i];
                MainModel *model = [[MainModel alloc] initContentWithDic:dic];
                NSString *isodd = i%2 == 0?@"1":@"0";
                model.isOdd = isodd;
                if (tableTag == 153) {
                    model.usn = [dic objectForKey:@"usn"];
                }else{
                    model.usn = [dic objectForKey:@"accountUsn"];
                }
                //                if ([dic objectForKey:@"templateId"]) {
                //                    model.templateId = @"1";
                //                }else{
                //                    model.templateId = [dic objectForKey:@"templateId"];
                //                }
                model.descrip = [dic objectForKey:@"title"];
                model.accountNickName = @"高圆圆圆圆是个胖子~";
                //                model.image = @"";
                model.zanCount = [[dic objectForKey:@"favNum"] stringValue];
                model.commentCount = [[dic objectForKey:@"commentNum"] stringValue];
//                model.zanCount = @"255";
//                model.commentCount = @"999";
                model.isZan = [dic objectForKey:@"exitFav"];
                model.pics = [dic objectForKey:@"pics"];
                if (tableTag != 153) {
                    if (model.pics.count == 0) {
                        
                    }else{
                        [newNewestData addObject:model];
                    }
                }else{
                    [newNewestData addObject:model];
                }
            }
            
            if (tableTag == 150) {
                self.recommandData = newNewestData;
                recommendTableView.indexData = _recommandData;
                [recommendTableView reloadData];
                recommendTableView.data = _recommandData;
            }else if (tableTag == 151){
                self.newestData = newNewestData;
                recommendTableView.indexData = _newestData;
                [recommendTableView reloadData];
                recommendTableView.data = _newestData;
            }else if (tableTag == 152){
                self.hotestData = newNewestData;
                recommendTableView.indexData = _hotestData;
                [recommendTableView reloadData];
                recommendTableView.data = _hotestData;
            }else if (tableTag == 153){
                self.storyData = newNewestData;
                recommendTableView.indexData = _storyData;
                [recommendTableView reloadData];
                recommendTableView.data = _storyData;
            }else if (tableTag == 154){
                self.attentionData = newNewestData;
                recommendTableView.indexData = _attentionData;
                [recommendTableView reloadData];
                recommendTableView.data = _attentionData;
            }
            if (_newestData.count<15) {
                finishTipLabel.hidden = NO;
                [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    finishTipLabel.text = @"没有最新的啦 ~ ";
                    CGRect rect = finishTipLabel.frame;
                    rect.origin.y = KScreenHeight-180;
                    finishTipLabel.frame = rect;
                } completion:nil];
                [self performSelector:@selector(hideFinishTip) withObject:nil afterDelay:2];
            }
            [self hiddenHeaderRefresh1:recommendTableView];
        }else{
            [self hiddenHeaderRefresh1:recommendTableView];
        }
    } failLoad:^(id result) {
        
    }];
}


-(void)pullUp:(BaseTableView *)tableView{
    if (tableView->upLoading == YES) {
        
    }else{
        if (netStatus == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            RecordTableView *recommendTableView = (RecordTableView *)[_mainSV viewWithTag:tableView.tag];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hiddenHeaderRefresh1:recommendTableView];
            });
        }else{
            [self _loadOldNewestData:tableView.tag];
        }
    }
}

-(void)_loadOldNewestData:(int)tableTag{
    NSString *url;
    if (tableTag == 150) {
        url = [NSString stringWithFormat:recommandUrl,self.recommandData.count,self.recommandData.count+15];
    }else if (tableTag == 151){
        url = [NSString stringWithFormat:newestUrl,self.newestData.count,self.newestData.count+15];
    }else if (tableTag == 152){
        url = [NSString stringWithFormat:hotestUrl,self.hotestData.count,self.hotestData.count+15];
    }else if (tableTag == 153){
        url = [NSString stringWithFormat:storyUrl,self.storyData.count,15];
    }else if (154){
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        url = [NSString stringWithFormat:attentionUrl,[tempDic objectForKey:@"usn"],self.attentionData.count,15];
    }else{
        return;
    }
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    [DataService requestWithURL:url params:params1 httpMethod:@"GET" block1:^(id result) {
        NSArray *array;
        if (tableTag == 153||tableTag == 154) {
            array = (NSArray *)result;
        }else{
            NSDictionary *resultDic = (NSDictionary *)result;
            array = [resultDic objectForKey:@"value"];
        }
        if (array.count>0) {
            NSMutableArray *newNewestData = [NSMutableArray array];
            for (int i = 0;i<array.count;i++) {
                NSDictionary *dic = array[i];
                MainModel *model = [[MainModel alloc] initContentWithDic:dic];
                NSString *isodd = i%2 == 0?@"1":@"0";
                model.isOdd = isodd;
                if (tableTag == 153) {
                    model.usn = [dic objectForKey:@"usn"];
                }else{
                    model.usn = [dic objectForKey:@"accountUsn"];
                }
                //                if ([dic objectForKey:@"templateId"]) {
                //                    model.templateId = @"1";
                //                }else{
                //                    model.templateId = [dic objectForKey:@"templateId"];
                //                }
                model.descrip = [dic objectForKey:@"title"];
                model.accountNickName = @"高圆圆圆圆是个胖子~";
                //                model.image = @"";
                model.zanCount = [[dic objectForKey:@"favNum"] stringValue];
                model.commentCount = [[dic objectForKey:@"commentNum"] stringValue];
//                model.zanCount = @"255";
//                model.commentCount = @"999";
                model.isZan = [dic objectForKey:@"exitFav"];
                model.pics = [dic objectForKey:@"pics"];
                if (tableTag != 103) {
                    if (model.pics.count == 0) {
                        
                    }else{
                        [newNewestData addObject:model];
                    }
                }else{
                    [newNewestData addObject:model];
                }
//                [newNewestData addObject:model];
            }
            RecordTableView *recommendTableView = (RecordTableView *)[_mainSV viewWithTag:tableTag];
            if (tableTag == 150) {
                [self.recommandData addObjectsFromArray:newNewestData];
                recommendTableView.indexData = _recommandData;
                [recommendTableView reloadData];
                recommendTableView.data = newNewestData;
            }else if (tableTag == 151){
                [self.newestData addObjectsFromArray:newNewestData];
                recommendTableView.indexData = _newestData;
                [recommendTableView reloadData];
                recommendTableView.data = newNewestData;
            }else if (tableTag == 152){
                [self.hotestData addObjectsFromArray:newNewestData];
                recommendTableView.indexData = _hotestData;
                [recommendTableView reloadData];
                recommendTableView.data = newNewestData;
            }else if (tableTag == 153){
                [self.storyData addObjectsFromArray:newNewestData];
                recommendTableView.indexData = _storyData;
                [recommendTableView reloadData];
                recommendTableView.data = newNewestData;
            }else if (tableTag == 154){
                [self.attentionData addObjectsFromArray:newNewestData];
                recommendTableView.indexData = _attentionData;
                [recommendTableView reloadData];
                recommendTableView.data = newNewestData;
            }
        if (array.count < 15) {
            finishTipLabel.hidden = NO;
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                finishTipLabel.text = @"已经到底啦 ~ ";
                CGRect rect = finishTipLabel.frame;
                rect.origin.y = KScreenHeight-180;
                finishTipLabel.frame = rect;
            } completion:nil];
            [self performSelector:@selector(hideFinishTip) withObject:nil afterDelay:2];
        }
        }else{
            RecordTableView *recommendTableView = (RecordTableView *)[_mainSV viewWithTag:tableTag];
//            recommendTableView.data = @[@"oo"];
            recommendTableView.data = array;
        }
//        NSArray *keys = @[@"tableView",@"array"];
//        NSArray *values = @[_tableView,self.newestData];
//        NSDictionary *argDic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
//        [self performSelectorInBackground:@selector(requestZanAndComment:) withObject:argDic];
    } failLoad:^(id result) {
        
    }];
}

-(void)hideFinishTip{
    [UIView animateWithDuration:1.0 animations:^{
        finishTipLabel.hidden = YES;
    }];
}
     
-(void)hiddenHeaderRefresh1:(RecordTableView *)tv{
    [tv doneLoadingTableViewData];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    
    //设置返回的style为导航控制器最顶层那个视图设置的style
    //    UIStatusBarStyle style = [self.topViewController preferredStatusBarStyle];
    //    return style;
    return UIStatusBarStyleLightContent;
    
    /*
     iOS6与iOS7导航栏适配：
     原理：  iOS6导航栏默认是不透明的，子控制器视图原点是从导航栏下边开始
     iOS7导航栏默认是半透明的，子控制器视图原点是从导航栏上边开始的
     
     解决：  1.系统判断（MoviViewController中写代码）
     2.修改导航栏不透明
     3.修改视图控制器的
     */
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
//        _tableView = nil;
//        _tableView1 = nil;
//        self.view = nil;
//        self.newestData = nil;
//        self.hotestData = nil;
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