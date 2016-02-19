//
//  StoryDetailViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/17.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "EventModel.h"
#import "CreateViewController.h"
#import "PSConfigs.h"
#import "BigImageController.h"
#import "CommentViewController.h"

@interface StoryDetailViewController ()<BaseTableViewDelegate>

@end

@implementation StoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"故事详情";
    [self _initTableView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusRefresh:) name:kPSLikeStatusChangeNotification object:nil];
    
    tipNullLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-200)/2, KScreenHeight+50, 200, 30)];
    tipNullLabel.backgroundColor = [UIColor blackColor];
    tipNullLabel.textAlignment = 1;
    tipNullLabel.font = [UIFont systemFontOfSize:16.0];
    tipNullLabel.textColor = [UIColor whiteColor];
    tipNullLabel.layer.cornerRadius = 5;
    tipNullLabel.layer.masksToBounds = YES;
    [self.view addSubview:tipNullLabel];
    self.Data = [NSMutableArray array];
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-64-50, KScreenWidth, 50)];
    [self.view addSubview:toolBar];
    
    [self addLineWithWidth:0 withHeight:0 toView:toolBar];
    
    NSArray *imgNames = @[@"gray.png",
                          @"评论.png",
                          @"share.png",
                          @"lookback.png"];
    
    NSString *zanCount;
    NSString *commentCount;
    if (![self.model.zanCount isKindOfClass:[NSNull class]]&&self.model.zanCount != nil) {
        zanCount = self.model.zanCount;
    }else{
        zanCount = @"0";
    }
    if (![self.model.commentCount isKindOfClass:[NSNull class]]&&self.model.commentCount != nil) {
        commentCount = self.model.commentCount;
    }else{
        commentCount = @"0";
    }
    NSArray *titleArr = @[zanCount, commentCount, @"分享", @"从头开始"];
    
    CGFloat width = KScreenWidth/imgNames.count;
    CGFloat height = CGRectGetHeight(toolBar.frame);
    
    for (int i = 0; i<imgNames.count; i++) {
        NSString *imageName = imgNames[i];
        NSString *title = titleArr[i];
        
        //        定制方法一、添加Button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(i*width, 0, width, height);
        [btn setTitleColor:CommonGray forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
            NSString *isZan = self.model.isZan;
            if (isZan == nil || [isZan isEqualToString:@"-1"]) {
                btn.selected = NO;
            }else{
                btn.selected = YES;
            }
            if ([title isEqualToString:@"0"]) {
                [btn setTitle:@"" forState:UIControlStateNormal];
            }else{
                [btn setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];

            }
        }
        if (i == 1) {
            if ([title isEqualToString:@"0"]) {
                [btn setTitle:@"" forState:UIControlStateNormal];
            }else{
                [btn setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
                
            }
        }
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.titleEdgeInsets = UIEdgeInsetsMake(30, -15, 0, 0);
        if (i==3) {
            btn.imageEdgeInsets = UIEdgeInsetsMake(-10, 30, 0, 0);
        }else{
            btn.imageEdgeInsets = UIEdgeInsetsMake(-10, 17, 0, 0);
        }
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btn];
        
        if (i == 2) {
            
        }
    }

//    if (![self.writable isEqualToString:@"yes"]) {
//        toolBar.hidden = YES;
//        storylistTV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
//    }else{
//        
//    }
    if (self.model == nil) {
        [self requestHeaderData];

    }
    if ([self.writable isEqualToString:@"yes"]) {
        [self _createNavItems];
    }
}

-(void)requestHeaderData{
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/%@",self.storyId];
    [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
        NSDictionary *dic = result;
        MainModel *model = [[MainModel alloc] initContentWithDic:dic];
        model.usn = [dic objectForKey:@"usn"];
        //                if ([[dic objectForKey:@"templateId"] length]<=0) {
        //                    model.templateId = @"1";
        //                }else{
        //                    model.templateId = [dic objectForKey:@"templateId"];
        //                }
        model.descrip = [dic objectForKey:@"description"];
        storylistTV.model = model;
//        [storylistTV reloadData];
    } failLoad:^(id result) {
        
    }];
}

-(void)clickAction:(UIButton *)btn{
  
    if (btn.tag == 100) {
        [[PSConfigs shareConfigs]likeActionWithType:likeType_Story withZanButton:btn withIndexModel:self.model withEventModel:nil];
    }else if (btn.tag == 101){
        CommentViewController *storyComment = [[CommentViewController alloc] init];
        storyComment.isStory = @"story";
        if (self.model.sid.length>0) {
            storyComment.storyId = self.model.sid;
        }else{
            storyComment.storyId = self.model.storyId;
        }
        storyComment.imodel = self.model;
        [self.navigationController pushViewController:storyComment animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
        
    }else if (btn.tag == 102){
        if (self.model.sid.length>0) {
            [PSConfigs shareConfigs].sid = self.model.sid;
        }
        else
        {
            [PSConfigs shareConfigs].sid = self.model.storyId;
        }
        if (self.model.image) {
            [PSConfigs shareConfigs].image = self.model.image;
        }
        else
        {
            [PSConfigs shareConfigs].image = @"http://wetime.oss-cn-beijing.aliyuncs.com/54f6c32245ce44b0b5c59dfe_640_640.jpeg";
        }
        [PSConfigs shareConfigs].title = self.model.title;
        [[PSConfigs shareConfigs] shareActionWithFromViewController:self withObject:self.model];
    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能尚未开通,敬请期待!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
        if (self.Data.count>0) {
            BigImageController *debugBigVC = [[BigImageController alloc] init];
            debugBigVC.data = self.Data;
            debugBigVC.isOrder = @"yes";
            [self.navigationController pushViewController:debugBigVC animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"这个故事还没有事件哦!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)_createNavItems{
    UIButton *botton = [UIButton buttonWithType:UIButtonTypeCustom];
    botton.frame = CGRectMake(0,0,60, 44);
    botton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [botton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [botton setTitle:@"添加" forState:UIControlStateNormal];
    [botton addTarget:self action:@selector(addEventAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:botton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (netStatus == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
    }else{
        [self _loadNewData];
    }
    
}

-(void)addEventAction:(UIButton *)btn{
    CreateViewController *createVC = [[CreateViewController alloc] init];
    createVC.storyName = self.model.title;
    NSArray *keys = @[@"id",@"title"];
    NSArray *values = @[self.model.sid,self.model.title];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    createVC.storyDic = dic;
    createVC.isAdded = @"storyed";
    [self.navigationController pushViewController:createVC animated:YES];
}

-(void)_initTableView{
    storylistTV = [[StroyListTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-50)];
    storylistTV.writable = self.writable;
    if (self.model != nil) {
        storylistTV.model = self.model;
    }
    storylistTV.refreshDelegate = self;
    storylistTV.backgroundColor = rgb(240, 240, 240, 1);
    storylistTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:storylistTV];
}

#pragma mark - BaseTableViewDelegate
-(void)pullDone:(BaseTableView *)tableView{
    //newest
    if (netStatus == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
            [self hiddenHeaderRefresh:storylistTV];
        });
    }else{
        [self _loadNewData];
    }
}

-(void)backAction{
    if (self.navigationController.viewControllers.count>2) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];

    }else if(self.navigationController.viewControllers.count == 2){
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(void)_loadNewData{
    [self showHud:@"精彩马上开始..."];

    NSString *strUrl;
    if (self.model==nil) {
        strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/0/15",self.storyId];
    }else{
        if (self.model.sid.length>0) {
            strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/0/15",self.model.sid];
        }else{
            strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/0/15",self.model.storyId];
        }
    }
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    [DataService requestWithURL:strUrl params:params httpMethod:@"GET" block1:^(id result) {
        NSArray *tempArray = (NSArray *)result;
        if (tempArray.count>0) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in tempArray) {
                EventModel *model = [[EventModel alloc] initContentWithDic:dic];
                if(model.pics.count>0){
                    [array addObject:model];
                }
                //model.isZan = @"-1";
            }
            self.Data = array;
            storylistTV.data = self.Data;
            [storylistTV reloadData];
            if (array.count<15) {
                storylistTV->upLoading = YES;
                tipNullLabel.hidden = YES;
                [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    tipNullLabel.text = @"没有最新咯";
                    CGRect rect = tipNullLabel.frame;
                    rect.origin.y = KScreenHeight-180;
                    tipNullLabel.frame = rect;
                } completion:nil];
                [self performSelector:@selector(hideTip) withObject:nil afterDelay:2];
            }
        }else{
            storylistTV->upLoading = YES;
            tipNullLabel.hidden = NO;
            self.Data = [NSMutableArray array];
            storylistTV.data = self.Data;
            [storylistTV reloadData];
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([self.writable isEqualToString:@"yes"]) {
                    tipNullLabel.text = @"您还没有创建事件哦";
                }else{
                    tipNullLabel.text = @"该故事还没有任何事件~";
                }
                CGRect rect = tipNullLabel.frame;
                rect.origin.y = KScreenHeight-180;
                tipNullLabel.frame = rect;
            } completion:nil];
            [self performSelector:@selector(hideTip) withObject:nil afterDelay:2];
        }
        [self hideHud];
        [self hiddenHeaderRefresh:storylistTV];
    } failLoad:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideHud];
            [PSConfigs showProgressWithError:result withView:self.view operationResponseString:nil delayShow:NO isImage:NO];

        });
    }];
}

-(void)hideTip{
    [UIView animateWithDuration:1.0 animations:^{
        tipNullLabel.hidden = YES;
    }];
}

-(void)pullUp:(BaseTableView *)tableView{
    //newest
    
    [self _loadOldData];
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

-(void)_loadOldData{
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    NSString *strUrl;
    if (self.model.sid.length>0) {
        strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/%d/%d",self.model.sid,self.Data.count,self.Data.count+15];
    }else{
        strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/%d/%d",self.model.storyId,self.Data.count,self.Data.count+15];
    }
    [DataService requestWithURL:strUrl params:params1 httpMethod:@"GET" block1:^(id result) {
        NSArray *array = (NSArray *)result;
        NSMutableArray *oldData = [NSMutableArray array];
        for (int i = 0;i<array.count;i++) {
            NSDictionary *dic = array[i];
            EventModel *model = [[EventModel alloc] initContentWithDic:dic];
            if(model.pics.count>0){
                [oldData addObject:model];
            }
        }
//        for (EventModel *m in self.Data) {
//            for (EventModel *sm in oldData) {
//                if (![m.eventId isEqualToString:sm.eventId]) {
//                    [self.Data addObject:sm];
//                }
//            }
//        }
        [self.Data addObjectsFromArray:oldData];
        storylistTV.data = _Data;
        [storylistTV reloadData];
        if (oldData.count<15) {
            tipNullLabel.hidden = NO;
            [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                tipNullLabel.text = @"已经到底啦~";
                CGRect rect = tipNullLabel.frame;
                rect.origin.y = KScreenHeight-180;
                tipNullLabel.frame = rect;
            } completion:nil];
            [self performSelector:@selector(hideTip) withObject:nil afterDelay:2];
        }
        [self hiddenFooterRefresh:storylistTV];
    } failLoad:^(id result) {
        
    }];
}

-(void)hiddenHeaderRefresh:(StroyListTableView *)tv{
    [tv doneLoadingTableViewData];
}

-(void)hiddenFooterRefresh:(StroyListTableView *)tv{
    tv.isRefresh = YES;
}

#pragma mark - ButtonAction
-(void)zanStoryAction:(UIButton *)btn{
//    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
//    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
//    [[PSConfigs shareConfigs] likeActionWithType:likeType_Story withZanButton:zanBuuton withZanLabel:zanCount withIndexModel:_model withEventModel:nil];
    //    if ([self.model.isZan isEqualToString:@"0"]) {
    //        NSInteger zanCou = [zanCount.text integerValue];
    //        zanCount.text = [NSString stringWithFormat:@"%d",zanCou-1];
    //        self.model.zanCount = [NSString stringWithFormat:@"%d",zanCou-1];
    //        zanBuuton.selected = NO;
    //        self.model.isZan = @"-1";
    //        NSString *storyUrl;
    //        if (self.model.sid.length>0) {
    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@/del",self.model.sid,[tempDic objectForKey:@"usn"]];
    //        }else{
    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@/del",self.model.storyId,[tempDic objectForKey:@"usn"]];
    //        }
    //        [DataService requestWithURL:storyUrl params:nil httpMethod:@"POST" block:^(id result) {
    //            NSLog(@"呜呜~他不爱我%@",result);
    //        }];
    //    }else{
    //        NSInteger zanCou = [zanCount.text integerValue];
    //        zanCount.text = [NSString stringWithFormat:@"%d",zanCou+1];
    //        self.model.zanCount = [NSString stringWithFormat:@"%d",zanCou+1];
    //        zanBuuton.selected = YES;
    //        self.model.isZan = @"0";
    //        NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //        [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    //        NSString *storyUrl;
    //        if (self.model.storyId.length>0) {
    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav",self.model.storyId];
    //        }else{
    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav",self.model.sid];
    //        }
    //        [DataService requestWithURL:storyUrl params:params httpMethod:@"POST" block:^(id result) {
    //            NSLog(@"有人给你点赞啦%@",result);
    //        }];
    //    }
    //    NSLog(@"%@",self.nextResponder.nextResponder);
    //    //    [(UITableView *)self.nextResponder.nextResponder reloadData];
    //    //    [btn setImage:[UIImage imageNamed:(i%2==0?@"red.png":@"gray.png")] forState:UIControlStateNormal];
    //    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //    k.values = @[@(0.1),@(1.0),@(2.0),@(3.0),@(4.0)];
    //    k.keyTimes = @[@(0.0),@(0.5),@(1.0),@(1.5),@(2.0)];
    //    k.calculationMode = kCAAnimationLinear;
    //    [btn.layer addAnimation:k forKey:@"SHOW"];
}

-(void)commentStoryAction:(UIButton *)btn{
    CommentViewController *myEventComment = [[CommentViewController alloc] init];
    myEventComment.delegate = self;
    myEventComment.isStory = @"story";
    if (self.model.sid.length>0) {
        myEventComment.storyId = self.model.sid;
    }else{
        myEventComment.storyId = self.model.storyId;
    }
    myEventComment.imodel = self.model;
    [self.navigationController pushViewController:myEventComment animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
}

-(void)shareStoryAction:(UIButton *)btn{
    
    [[PSConfigs shareConfigs] shareActionWithFromViewController:self withObject:self.model];
    [PSConfigs shareConfigs].sid = self.model.sid;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        storylistTV = nil;
        self.view = nil;
    }
    self.Data = nil;
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