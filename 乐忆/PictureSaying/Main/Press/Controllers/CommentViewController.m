//
//  CommentViewController.m
//  Comment
//
//  Created by tutu on 14/12/10.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  评论

#import "CommentViewController.h"
#import "AppDelegate.h"
#import "HeaderViewCell.h"
#import "CommentViewCell.h"
#import "UIViewExt.h"
#import "DataService.h"
#import "MBProgressHUD.h"
#import "PSConfigs.h"
#import "NSDate+Additions.h"
#import "UIImage+HB.h"
#import "UIScrollView+MJRefresh.h"
#import "PSConfigs.h"
#import "DianzanViewController.h"
#import "EventDetailCell.h"
#import "PSConfigs.h"
#import "StoryDetailViewController.h"
#define kMaxLength  70

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    Info *info;
    int count;
    NSMutableArray *_data;
    MBProgressHUD *_hud;
    NSMutableArray *_useid;
    NSMutableArray *dianzanArray;
    NSMutableArray *dianzanUserInfo;
    CGSize ksize;
    UIImageView *userAva;
    UILabel *userName;
    UILabel *titleLabel;
    UIButton *attentionButton;
    UILabel *line;
    UIView *tableHeaderView;
}
@property(nonatomic,strong)UITableView *tv;
@property(nonatomic,strong)UIView *v;
@property(nonatomic,strong)UIView *toolBar;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *dianzanView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UILabel *Liuyan;
@property(nonatomic)BOOL sta;
@property(nonatomic)BOOL stb;
@property(nonatomic)CGFloat kHeight;

@end

@implementation CommentViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            // Custom initialization
            [self _initHeaderView];
            
        }
        return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sta = YES;
    _stb = YES;
//    [self _initHeaderView];
    if ([self.isMine isEqualToString:@"yes"]) {
        [self _createNavItem];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusRefresh:) name:kPSLikeStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //cell数据源
    _data =  [NSMutableArray array];
    self.eventdata = [NSMutableArray array];
    //回复id数组
    _useid = [NSMutableArray array];
    if (self.emodel || self.eventId) {
        self.title = @"事件详情";
    }
    else
    {
    self.title = @"评论";
    }
    //点赞usn数组
    dianzanArray = [NSMutableArray array];
    //点赞用户信息
    dianzanUserInfo = [NSMutableArray array];
    //表头数据源
    info = [[Info alloc] init];
    if (self.emodel || self.eventId) {
        if (self.emodel) {
            info.comment = self.emodel.commentNum;
            self.eventdata = self.emodel.pics;
        }
        else
        {
            info.comment = self.num;
            self.eventdata = self.chuanzhi;
        }
        
    }else{
//        info.name = self.imodel.title;
        info.image = self.imodel.image;
//        info.infos = self.imodel.descrip;
//        info.xin = self.imodel.zanCount;
//        info.time = self.imodel.time;
        info.comment = self.imodel.commentCount;
    }
    //获取点赞usn
    [self getListDianzan];
    //tabview
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-KScreenHeight*.1) style:UITableViewStyleGrouped];
    self.tv.backgroundColor = [UIColor whiteColor];
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.view addSubview:self.tv];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dian:)];
    [self.tv addGestureRecognizer:tap];
    self.tf = [[UITextView alloc]init];
    self.tf.delegate = self;
    self.tf.font = [UIFont systemFontOfSize:16.0];
//    self.tf.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tf.scrollEnabled = NO;
    self.tf.frame = CGRectMake(KScreenWidth*0.05,10, KScreenWidth*0.76, 35);
    self.tf.backgroundColor = [UIColor clearColor];
    //_tf.returnKeyType = UIReturnKeySend;
    if ([self.fromEvent isEqualToString:@"yes"]) {
        
    }else{
        [self.tf becomeFirstResponder];

    }
    self.tf.returnKeyType = UIReturnKeyDefault;
    //发送底部框
    self.v = [[UIView alloc]init];
    if ([self.isStory isEqualToString:@"story"]) {
        self.v.frame = CGRectMake(0, KScreenHeight*0.9-64,KScreenWidth,KScreenHeight*0.1);
    }
    else
    {
    self.v.frame = CGRectMake(0, KScreenHeight,KScreenWidth,KScreenHeight*0.1);
    }
    self.v.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    self.v.autoresizesSubviews = NO;
    [self.view addSubview:self.v];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage resizableImage:@"evaluateBg.png"]];
    self.imageView.frame = CGRectMake(KScreenWidth*0.05,10, KScreenWidth*0.76, 35);
    [self.v addSubview:self.imageView];
    [self.v addSubview:self.tf];
    
    self.placeHodel = [[UILabel alloc]initWithFrame:CGRectMake(3,5,200,25)];
    self.placeHodel.text = @"发表你的评论...";
    [self.placeHodel setTextColor:[UIColor lightGrayColor]];
    [self.tf addSubview:self.placeHodel];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(self.imageView.right,self.imageView.bottom-25, KScreenWidth*0.18, 30);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
   // [_sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sendButton setTitleColor:CommonBlue forState:UIControlStateSelected];
    [_sendButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitleColor:[UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1] forState:UIControlStateNormal];
    [self.v addSubview:_sendButton];
    [self getNetworkDataWithLoadMore:NO];
    
    __weak CommentViewController *commentController = self;
//    [_tv addHeaderWithCallback:^{
//        [commentController getNetworkDataWithLoadMore:NO];
//    }];
    
    [_tv addFooterWithCallback:^{
        [commentController getNetworkDataWithLoadMore:YES];
    }];
    if ([self.isStory isEqualToString:@"story"]) {
    }
    else
    {
    [self _initToolBar];
    }
}

-(void)_initHeaderView{
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    userAva = [[UIImageView alloc] initWithFrame:CGRectZero];
    userAva.layer.cornerRadius = 25;
    userAva.layer.masksToBounds = YES;
    userAva.contentMode = UIViewContentModeScaleAspectFill;
    userAva.clipsToBounds = YES;
    userAva.image = [UIImage imageNamed:@"test.jpg"];
    [tableHeaderView addSubview:userAva];
    
    userName = [[UILabel alloc] initWithFrame:CGRectZero];
    userName.font = [UIFont systemFontOfSize:15.0];
    userName.textColor = rgb(87, 87, 87, 1);
    [tableHeaderView addSubview:userName];
    
    attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    attentionButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [attentionButton setImage:[UIImage imageNamed:@"attention.png"] forState:UIControlStateNormal];
    [attentionButton setImage:[UIImage imageNamed:@"attentioned.png"] forState:UIControlStateDisabled];
    [tableHeaderView addSubview:attentionButton];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.numberOfLines = 0;
    [tableHeaderView addSubview:titleLabel];
    
    line = [[UILabel alloc] initWithFrame:CGRectZero];
    line.backgroundColor = CommonGray;
    [tableHeaderView addSubview:line];
    self.tv.tableHeaderView = tableHeaderView;

}

-(void)setEmodel:(EventModel *)model{
    if (_emodel != model) {
        _emodel = model;
        
        CGSize size = [model.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000)];
        tableHeaderView.height = size.height+KScreenWidth*0.55+110;
        userAva.frame = CGRectMake(10, 10, 50, 50);
        if (model.accountAva.length>0) {
            [userAva sd_setImageWithURL:[NSURL URLWithString:model.accountAva]];

        }else{
            userAva.image = [UIImage imageNamed:@"gerenzhxintouxing.png"];
        }
        userName.frame = CGRectMake(userAva.right + 10, userAva.top, KScreenWidth-70-70, 30);
        if (model.accountNickName.length>0) {
            userName.text = model.accountNickName;

        }else{
            userName.text = @"";

        }
        attentionButton.frame = CGRectMake(KScreenWidth-60, userName.top, 50, 25);
//        if ([mmodel.isSub isEqualToString:@"yes"]) {
//            attentionButton.enabled = NO;
//        }else{
//            attentionButton.enabled = YES;
//        }
        if ([self.isMine isEqualToString:@"yes"]) {
            attentionButton.enabled = NO;
            
        }else{
            attentionButton.enabled = YES;
            
        }
        line.frame = CGRectMake(userName.left, userName.bottom, KScreenWidth-70, 0.5);
        titleLabel.frame = CGRectMake(userName.left, line.bottom, line.width-10, size.height+10);
        //        contentLabel.backgroundColor = [UIColor brownColor];
        titleLabel.text = model.title;
        tableHeaderView.height = userName.height+titleLabel.height+10+0.5+10;
        self.tv.tableHeaderView = tableHeaderView;
    }
}

-(void)setImodel:(MainModel *)mmodel{
    if (_imodel != mmodel) {
        _imodel = mmodel;
        CGSize size = [mmodel.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000)];
        tableHeaderView.height = size.height+KScreenWidth*0.55+110;
        userAva.frame = CGRectMake(10, 10, 50, 50);
        if (mmodel.accountAva.length>0) {
            [userAva sd_setImageWithURL:[NSURL URLWithString:mmodel.accountAva]];
            
        }else{
            userAva.image = [UIImage imageNamed:@"gerenzhxintouxing.png"];
        }        userName.frame = CGRectMake(userAva.right + 10, userAva.top, KScreenWidth-70-70, 30);
        if (mmodel.accountNickName.length>0) {
            userName.text = mmodel.accountNickName;
            
        }else{
            userName.text = @"";
            
        }        attentionButton.frame = CGRectMake(KScreenWidth-60, userName.top, 50, 25);
        
        if ([self.isMine isEqualToString:@"yes"]) {
            attentionButton.enabled = NO;
            
        }else{
            if ([mmodel.isSub isEqualToString:@"yes"]) {
                attentionButton.enabled = NO;
            }else{
                attentionButton.enabled = YES;
            }
        }
        line.frame = CGRectMake(userName.left, userName.bottom, KScreenWidth-70, 0.5);
        titleLabel.frame = CGRectMake(userName.left, line.bottom, line.width-10, size.height+10);
        //        contentLabel.backgroundColor = [UIColor brownColor];
        titleLabel.text = mmodel.title;
        tableHeaderView.height = userName.height+titleLabel.height+10+0.5+10;
        self.tv.tableHeaderView = tableHeaderView;
    }
}

-(void)_createNavItem{
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 44, 10);
    [deleteButton setImage:[UIImage imageNamed:@"threePoint.png"] forState:UIControlStateNormal];
    deleteButton.showsTouchWhenHighlighted = YES;
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)deleteAction:(UIButton *)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (_emodel||_eventId) {
            if (_emodel) {
                NSString *deleUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/%@/del",self.storyId,self.emodel.eventId];
                NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
                [DataService requestWithURL:deleUrl params:params httpMethod:@"POST" block1:^(id result) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert.tag = 100;
                    [alert show];
                } failLoad:^(id result) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert.tag = 101;
                    [alert show];
                }];
            }else{
                NSString *deleUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/%@/del",self.storyId,self.eventId];
                NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
                [DataService requestWithURL:deleUrl params:params httpMethod:@"POST" block1:^(id result) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert.tag = 100;
                    [alert show];
                } failLoad:^(id result) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert.tag = 101;
                    [alert show];
                }];
            }
        }else{
            
        }
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
//        if (self.navigationController.viewControllers.count>2) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else if(self.navigationController.viewControllers.count == 2){
//            [self.navigationController popViewControllerAnimated:YES];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
//        }else{
//            [self dismissViewControllerAnimated:YES completion:^{
//                
//            }];
//        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
    
        }
        StoryDetailViewController *storyVC = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:storyVC animated:YES];
    }else{
        
    }
    
}

-(void)_initToolBar{
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-KScreenHeight*0.1-64, KScreenWidth, KScreenHeight*0.1)];
    [self.view addSubview:toolBar];
    
    [self addLineWithWidth:0 withHeight:0 toView:toolBar];
    
    NSArray *imgNames = @[@"gray.png",
                          @"评论.png",
                          @"share.png",
                          @"lookback.png"];
    NSString *zanCount;
    NSString *commentCount;
    if (_emodel == nil) {
        if (![self.imodel.zanCount isKindOfClass:[NSNull class]]&&self.imodel.zanCount != nil) {
            zanCount = self.imodel.zanCount;
        }else{
            zanCount = @"0";
        }
        if (![self.imodel.commentCount isKindOfClass:[NSNull class]]&&self.imodel.commentCount != nil) {
            commentCount = self.imodel.commentCount;
        }else{
            commentCount = @"0";
        }
    }else{
        if (![self.emodel.favNum isKindOfClass:[NSNull class]]&&self.emodel.favNum != nil) {
            zanCount = self.emodel.favNum;
        }else{
            zanCount = @"0";
        }
        if (![self.emodel.commentNum isKindOfClass:[NSNull class]]&&self.emodel.commentNum != nil) {
            commentCount = self.emodel.commentNum;
        }else{
            commentCount = @"0";
        }
    }
    NSArray *titleArr = @[zanCount, commentCount, @"分享", @"时间轴"];
    
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
            NSString *isZan;
            if (_emodel) {
                isZan = self.emodel.isZan;

            }else{
                isZan = self.imodel.isZan;

            }
            if (isZan == nil || [isZan isEqualToString:@"-1"]){
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
            btn.imageEdgeInsets = UIEdgeInsetsMake(-10, 25, 0, 0);

        }else{
            btn.imageEdgeInsets = UIEdgeInsetsMake(-10, 17, 0, 0);
        }
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btn];
        
        if (i == 2) {
            
        }
    }
}

-(void)clickAction:(UIButton*)sender
{
    if (sender.tag == 100) {
        if (self.emodel) {
            [[PSConfigs shareConfigs]likeActionWithType:likeType_Event withZanButton:sender withIndexModel:nil withEventModel:self.emodel];

        }else{
            [[PSConfigs shareConfigs]likeActionWithType:likeType_Event withZanButton:sender withIndexModel:self.imodel withEventModel:nil];

        }
    }else if(sender.tag == 101){
        [self.tf becomeFirstResponder];
    }else if (sender.tag == 102) {
        if (self.emodel || self.eventId) {
            if(!self.emodel){
                [PSConfigs shareConfigs].sid = self.eventId;
                [PSConfigs shareConfigs].image = [self.imodel.pics[0] objectForKey:@"path"];
                [PSConfigs shareConfigs].title = self.imodel.title;
                [[PSConfigs shareConfigs] shareActionWithFromViewController:self];
            }else{
                [PSConfigs shareConfigs].sid = self.eventId;
                [PSConfigs shareConfigs].image = [self.emodel.pics[0] objectForKey:@"path"];
                [PSConfigs shareConfigs].title = self.emodel.title;
                [[PSConfigs shareConfigs] shareActionWithFromViewController:self];
            }
        }
       else
       {
           if (self.imodel.sid.length>0) {
               [PSConfigs shareConfigs].sid = self.imodel.sid;
           }
           else
           {
               [PSConfigs shareConfigs].sid = self.imodel.storyId;
           }
           [[PSConfigs shareConfigs] shareActionWithFromViewController:self withObject:self.imodel];
       }
        
    }else if(sender.tag == 103){
//        if (self.navigationController.viewControllers.count>2) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else if(self.navigationController.viewControllers.count == 2){
//            [self.navigationController popViewControllerAnimated:YES];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
//        }else{
//            [self dismissViewControllerAnimated:YES completion:^{
//                
//            }];
//        }
        
        StoryDetailViewController *storyDVC = [[StoryDetailViewController alloc] init];
        storyDVC.storyId = self.storyId;
        storyDVC.writable = @"no";
        [self.navigationController pushViewController:storyDVC animated:YES];
       
       }
}

/*
 照片描述、删除事件--1天
 回顾跳转、故事删除--1天
 剩余bug，完善本期任务--4天
 */

-(void)getListDianzan
{
    if (self.emodel||self.eventId) {
        NSString *url = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav/0/1000",self.storyId,self.eventId];
        [DataService requestWithURL:url params:nil httpMethod:@"GET" block1:^(id result) {
            NSArray *arr = (NSArray*)result;
            if (arr.count > 0) {
                for(NSDictionary *dic in arr)
                {
                    NSString *phone = [dic objectForKey:@"accountUsn"];
                    [dianzanArray addObject:phone];
                    
                }

            }
            [self userInfo];
        } failLoad:^(id result) {
            
        }];
    }
    else
    {
        NSString *url = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/0/1000",self.storyId];
        [DataService requestWithURL:url params:nil httpMethod:@"GET" block1:^(id result) {
            NSArray *arr = (NSArray*)result;
            if (arr.count>0) {
                for(NSDictionary *dic in arr)
                {
                    NSString *phone = [dic objectForKey:@"accountUsn"];
                    [dianzanArray addObject:phone];
                    
                }
               
            }
            [self userInfo];
        } failLoad:^(id result) {
            
        }];
        
        
    }


}
-(void)userInfo
{
    if(dianzanArray.count > 0)
    {
      for (int i = 0; i<dianzanArray.count; i++)
      {
       NSString *urlstring1 =[NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",dianzanArray[i]] ;
          [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
              NSDictionary *dicuserInfo = (NSDictionary*)result;
              [dianzanUserInfo insertObject:dicuserInfo atIndex:0];
              if (i == dianzanArray.count-1) {
                  [self.tv reloadData];
                  
              }
              
          } failLoad:^(id result) {
              
          }];
            
       }
    }


}
-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *info1 = [noti userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    ksize = [[info1 objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [UIView animateWithDuration:0.35 animations:^{
        self.v.frame = CGRectMake(0, KScreenHeight*0.9-64-ksize.height,KScreenWidth ,KScreenHeight*0.1 );

    }];

}

-(void)keyboardWillHide:(NSNotification *)noti
{
    if ([self.isStory isEqualToString:@"story"]) {
        self.v.frame = CGRectMake(0, KScreenHeight*0.9-64,KScreenWidth,KScreenHeight*0.1);
    }
    else
    {
        self.v.frame = CGRectMake(0, KScreenHeight,KScreenWidth,KScreenHeight*0.1);
    }
    self.tf.frame = CGRectMake(KScreenWidth*0.05,10, KScreenWidth*0.76, 35);
    [self.tf resignFirstResponder];
    self.imageView.frame = CGRectMake(KScreenWidth*0.05,12, KScreenWidth*0.76, 30);
    _sendButton.frame = CGRectMake(self.imageView.right,self.imageView.bottom-25, KScreenWidth*0.18, 30);
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
//        switch (type)
//        {
//            case likeType_Story:
//            {
//                self.imodel.zanCount = indexModel.zanCount;
//                self.imodel.isZan = indexModel.isZan;
//                info.xin = indexModel.zanCount;
//            }
//                break;
//            case likeType_Event:
//            {
//                if (eventModel) {
//                    self.emodel.favNum = eventModel.favNum;
//                    self.emodel.isZan = eventModel.isZan;
//                    info.xin = eventModel.favNum;
//                }else{
//                    self.emodel.favNum = indexModel.zanCount;
//                    self.emodel.isZan = indexModel.isZan;
//                    info.xin = indexModel.zanCount;
//                }
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        [_tv reloadData];
//        
//    }
//}

-(void)refreshCommentCount
{
    if (self.emodel || self.eventId) {
        self.emodel.commentNum = info.comment;
        self.num = info.comment;
    }else{
        self.imodel.commentCount = info.comment;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(commentCountRefresh)])
        {
            [_delegate commentCountRefresh];
        }
    });
}

-(void)getNetworkDataWithLoadMore:(BOOL)isLoadMore
{
    if([self.isStory isEqualToString:@"story"]){
        NSString *urlstring = [NSString stringWithFormat:@"/WeiXiaoComment/api/v1/story/%@/comment/%lu/20",self.storyId,isLoadMore?_data.count:0];
        [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
            NSData *data = (NSData*)result;
            NSArray *array = (NSArray*)result;
            if (data != nil)
            {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (NSDictionary *dic in array ) {
                    //评论数据源
                    comment *commentuser = [[comment alloc]init];
                    NSString *sid = [dic objectForKey:@"id"];
                    [_useid addObject:sid];
                    NSString *sname = [dic objectForKey:@"fromAccountNickName"];
                    if ([sname isKindOfClass:[NSNull class]]) {
                        commentuser.userName = @"游客";
                    }
                    else
                    {
                        commentuser.userName = sname;
                    }
                    NSString *surl = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",[dic objectForKey:@"fromAccountUsn"]];
                    [DataService requestWithURL:surl params:nil httpMethod:@"GET" block1:^(id result) {
                        NSDictionary *dd = (NSDictionary*)result;
                        commentuser.userImageStr = [dd objectForKey:@"image"];
                        NSString *sname = [dd objectForKey:@"nickname"];
                        if ([sname isKindOfClass:[NSNull class]]) {
                            commentuser.userName = @"无昵称";
                        }
                        else
                        {
                            commentuser.userName = sname;
                        }
                        [_tv reloadData];
                    } failLoad:^(id result) {
                       
                    }];
                    NSString *stext = [dic objectForKey:@"text"];
                    if ([stext isKindOfClass:[NSNull class]]) {
                        commentuser.comments = @" ";
                    }
                    
                    else
                    {
                        commentuser.comments = stext;
                    }
                    
                    double time = [[dic objectForKey:@"time"] doubleValue]/1000;
                    
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                    NSString *dateString = [NSDate stringForRecentDate:date];
                    
                    commentuser.time = dateString;
                    
                    
                    NSDictionary *d = [dic objectForKey:@"toComment"];
                    if ([d isKindOfClass:[NSNull class]]) {
            
                    }
                    else
                    {
                        commentuser.replyName = d[kFromAccountNickName];
                        commentuser.replyContent = d[kText];
                    }
                    [tempArray addObject:commentuser];
                    
                }
                if (isLoadMore)
                {
                    [_data addObjectsFromArray:tempArray];
                }
                else
                {
                    _data = tempArray;
                }
                [_tv headerEndRefreshing];
                [_tv footerEndRefreshing];
                
                if (_sta) {
                    [self performSelectorOnMainThread:@selector(reloadtvData) withObject:nil waitUntilDone:NO];
                    _sta = NO;
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
                }
            }
        } failLoad:^(id result) {
           
        }];
        
    }else{
        //to do event comment
        NSString *urlstring = [NSString stringWithFormat:@"/WeiXiaoComment/api/v1/story/%@/item/%@/comment/%lu/20",self.storyId,self.eventId,isLoadMore?_data.count:0];
        [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
            NSArray *array = (NSArray*)result;
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in array ) {
                //评论数据源
                comment *commentuser = [[comment alloc]init];
                NSString *sid = [dic objectForKey:@"id"];
                [_useid addObject:sid];
                NSString *sname = [dic objectForKey:@"fromAccountNickName"];
                if ([sname isKindOfClass:[NSNull class]]) {
                    commentuser.userName = @"游客";
                }
                else
                {
                    commentuser.userName = sname;
                }
                NSString *surl = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",[dic objectForKey:@"fromAccountUsn"]];
                [DataService requestWithURL:surl params:nil httpMethod:@"GET" block1:^(id result) {
                    NSDictionary *dd = (NSDictionary*)result;
                    commentuser.userImageStr = [dd objectForKey:@"image"];
                    NSString *sname = [dd objectForKey:@"nickname"];
                    if ([sname isKindOfClass:[NSNull class]]) {
                        commentuser.userName = @"无昵称";
                    }
                    else
                    {
                        commentuser.userName = sname;
                    }
                    [_tv reloadData];
                } failLoad:^(id result) {
                    
                }];
                NSString *stext = [dic objectForKey:@"text"];
                if ([stext isKindOfClass:[NSNull class]]) {
                    commentuser.comments = @" ";
                }
                
                else
                {
                    commentuser.comments = stext;
                }
                
                double time = [[dic objectForKey:@"time"] doubleValue]/1000;
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                NSString *dateString = [NSDate stringForRecentDate:date];
                
                commentuser.time = dateString;
                
                
                NSDictionary *d = [dic objectForKey:@"toComment"];
                if ([d isKindOfClass:[NSNull class]]) {
                }
                else
                {
                    commentuser.replyName = d[kFromAccountNickName];
                    commentuser.replyContent = d[kText];
                }
                [tempArray addObject:commentuser];
                
            }
            
            if (isLoadMore)
            {
                [_data addObjectsFromArray:tempArray];
            }
            else
            {
                _data = tempArray;
            }
            if (_sta) {
                [self performSelectorOnMainThread:@selector(reloadtvData) withObject:nil waitUntilDone:NO];
                _sta = NO;
            }
            else
            {
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
            }
            [_tv headerEndRefreshing];
            [_tv footerEndRefreshing];
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
        } failLoad:^(id result) {
          
        }];
    }
}

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
-(void)dian:(UIGestureRecognizer*)ge
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [UIView commitAnimations];
    
    [self.tf resignFirstResponder];
    self.tf.text = nil;
    _sendButton.selected = NO;
    self.isReply = NO;
    self.placeHodel.text = @"发表你的评论...";
    self.placeHodel.hidden = NO;
}

-(void)reloadtvData{
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:1];
    [_tv reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
  
    if ([info.comment isEqualToString:@"0"]) {
    
    }
    else
    {
        if ([self.fromEvent isEqualToString:@"yes"]) {
            self.fromEvent = @"no";
        }else{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [self.tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [UIView commitAnimations];
    
        }
        
   }
    [self hideHud];
}
-(void)reload{
    [_tv reloadData];
    
    [self hideHud];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
   NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([toBeString length] > 0 || [textView.text length] > 1)
    {
        _sendButton.selected = YES;
    }
    else
    {
        _sendButton.selected = NO;
    }
    
    if (toBeString.length > kMaxLength && range.length!=1){
        textView.text = [toBeString substringToIndex:kMaxLength];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最大输入长度不能超过70个字符" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    CGSize constraintSize;
    constraintSize.width = KScreenWidth*0.7;
    constraintSize.height = 80;
    CGSize sizeFrame = [self.tf.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:constraintSize];
    if (sizeFrame.height>20) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView commitAnimations];
        self.v.frame = CGRectMake(0, KScreenHeight*0.9-64-sizeFrame.height-ksize.height,KScreenWidth,sizeFrame.height+KScreenHeight*0.1);
        self.imageView.frame = CGRectMake(KScreenWidth*0.05,12, KScreenWidth*0.76,sizeFrame.height+16);
        self.tf.frame = CGRectMake(KScreenWidth*0.05, 10,KScreenWidth*0.76,sizeFrame.height+16);
        _sendButton.frame = CGRectMake(self.imageView.right,self.imageView.bottom-25, KScreenWidth*0.18, 30);
        _kHeight = sizeFrame.height+KScreenHeight*0.1;
    }
    else
    {
        self.v.frame = CGRectMake(0, KScreenHeight*0.9-64-ksize.height,KScreenWidth,KScreenHeight*0.1);
        self.imageView.frame = CGRectMake(KScreenWidth*0.05,10, KScreenWidth*0.76,35);
        self.tf.frame = CGRectMake(KScreenWidth*0.05, 10,KScreenWidth*0.76,35);
        _sendButton.frame = CGRectMake(self.imageView.right,self.imageView.bottom-25, KScreenWidth*0.18, 30);
        
    }
    return YES;


}

-(void)textViewDidChange:(UITextView *)textView{
    
    if ( [textView.text length] > 0)
    {
        _sendButton.selected = YES;
    }
    else
    {
        _sendButton.selected = NO;
    }
    if ([textView.text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        
    }
    if (textView.text.length==0){//textview长度为0
        if ([textView.text isEqualToString:@""]) {//判断是否为删除键
            self.placeHodel.hidden=NO;
        }else{
            self.placeHodel.hidden=YES;
        }
    }else{//textview长度不为0
        if (textView.text.length==1){//textview长度为1时候
            if ([textView.text isEqualToString:@""]) {//判断是否为删除键
                self.placeHodel.hidden=NO;
            }else{//不是删除
                self.placeHodel.hidden=YES;
            }
        }else{//长度不为1时候
            self.placeHodel.hidden=YES;
        }
    }
    CGSize constraintSize;
    constraintSize.width = KScreenWidth*0.7;
    constraintSize.height = MAXFLOAT;
    CGSize sizeFrame = [self.tf.text sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:constraintSize];
    if (sizeFrame.height>20) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView commitAnimations];
        self.v.frame = CGRectMake(0, KScreenHeight*0.9-64-sizeFrame.height-ksize.height,KScreenWidth,sizeFrame.height+KScreenHeight*0.1);
        self.imageView.frame = CGRectMake(KScreenWidth*0.05,12, KScreenWidth*0.76,sizeFrame.height+16);
        self.tf.frame = CGRectMake(KScreenWidth*0.05, 10,KScreenWidth*0.76,sizeFrame.height+16);
        _sendButton.frame = CGRectMake(self.imageView.right,self.imageView.bottom-25, KScreenWidth*0.18, 30);
        _kHeight = sizeFrame.height+KScreenHeight*0.1;
    }
    else
    {
        self.v.frame = CGRectMake(0, KScreenHeight*0.9-64-ksize.height,KScreenWidth,KScreenHeight*0.1);
        self.imageView.frame = CGRectMake(KScreenWidth*0.05,10, KScreenWidth*0.76,35);
        self.tf.frame = CGRectMake(KScreenWidth*0.05, 10,KScreenWidth*0.76,35);
        _sendButton.frame = CGRectMake(self.imageView.right,self.imageView.bottom-25, KScreenWidth*0.18, 30);
        
    }
}

-(void)comment:(UIButton*)sender
{

    if (_sendButton.selected)
    {
        NSString *text = [self.tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([text length] > 0)
        {
            //评论故事字典
            NSMutableDictionary *paras =[NSMutableDictionary dictionary];
            [paras setObject:_storyId forKey:@"storyId"];
            [paras setObject:[PSConfigs shareConfigs].usn forKey:@"fromAccountUsn"];
            [paras setObject:[PSConfigs shareConfigs].nickname forKey:@"fromAccountNickName"];
            [paras setObject:[PSConfigs shareConfigs].image forKey:@"fromAccountAva"];
            [paras setObject:text forKey:@"text"];
            
            //发表评论请求
            NSString *itemString = @"";
            if (![_isStory isEqualToString:@"story"])
            {
                itemString = [NSString stringWithFormat:@"/item/%@",_eventId];
            }
            NSString *s = [NSString stringWithFormat:@"/WeiXiaoComment/api/v1/story/%@%@/comment",_storyId,itemString];
            
            //回复评论字典
            if (_isReply) {
          
                
                [paras setObject:text forKey:@"text"];
                
                //回复评论请求
                s =[s stringByAppendingFormat:@"/%@/reply/",_useid[_myid]];

            }
            
            [self showHud:@"正在发表..."];

            [DataService requestWithURL:s params:paras httpMethod:@"POST" block1:^(id result) {
                [self requestNewComment];
                
            } failLoad:^(id result) {
                
            }];
            
            _isReply = NO;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [UIView commitAnimations];
            self.tf.text = nil;
            [self.tf resignFirstResponder];
            self.placeHodel.text = @"发表你的评论...";
            self.placeHodel.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _sendButton.selected = NO;
            });
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能发送空白消息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.tf.text = nil;
        }
        
    }
}

-(void)requestNewComment{
    _useid = [NSMutableArray array];
    NSString *itemString = @"";
    if (![_isStory isEqualToString:@"story"])
    {
        itemString = [NSString stringWithFormat:@"/item/%@",_eventId];
    }
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiaoComment/api/v1/story/%@%@/comment/0/100",_storyId,itemString];
//    NSURL *url = [NSURL URLWithString:urlstring];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"Get"];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
    [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
        NSArray *array = (NSArray*)result;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in array ) {
            //评论数据源
            comment *commentuser = [[comment alloc]init];
            NSString *sid = [dic objectForKey:@"id"];
            [_useid addObject:sid];
            
            NSString *surl = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",[dic objectForKey:@"fromAccountUsn"]];
            [DataService requestWithURL:surl params:nil httpMethod:@"GET" block1:^(id result) {
                NSDictionary *dd = (NSDictionary*)result;
                
                commentuser.userImageStr = [dd objectForKey:@"image"];
                NSString *sname = [dd objectForKey:@"nickname"];
                if ([sname isKindOfClass:[NSNull class]]) {
                    commentuser.userName = @"无昵称";
                }
                else
                {
                    commentuser.userName = sname;
                }
                [_tv reloadData];
            } failLoad:^(id result) {
                
            }];
            NSString *stext = [dic objectForKey:@"text"];
            if ([stext isKindOfClass:[NSNull class]]) {
                commentuser.comments = @" ";
            }
            else
            {
                commentuser.comments = stext;
            }
            
            double time = [[dic objectForKey:@"time"] doubleValue]/1000;
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *dateString = [NSDate stringForRecentDate:date];
            
            commentuser.time = dateString;
            
            
            NSDictionary *d = [dic objectForKey:@"toComment"];
            if ([d isKindOfClass:[NSNull class]]) {
            }
            else
            {
                commentuser.replyName = d[kFromAccountNickName];
                commentuser.replyContent = d[kText];
            }
            [tempArray addObject:commentuser];
            
        }
        //给Model源数组赋值
        _data = tempArray;
        info.comment = [NSString stringWithFormat:@"%d",(int)_data.count];
        [self refreshCommentCount];
        UIButton *btn = (UIButton*)[self.toolBar viewWithTag:101];
        dispatch_async(dispatch_get_main_queue(), ^{
            [btn setTitle:[NSString stringWithFormat:@" %@",info.comment] forState:UIControlStateNormal];
        });
        [self performSelectorOnMainThread:@selector(reloadtvData) withObject:nil waitUntilDone:NO];
    } failLoad:^(id result) {
        
    }];
    
}
-(void)back:(UIButton*)sender
{
  

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        //点赞列表
        self.dianzanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
        self.dianzanView.backgroundColor = [UIColor whiteColor];
        if (dianzanArray.count == 0) {
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(50, 30, 200, 30);
            label.text = @"现在还无人点赞!";
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.dianzanView addSubview:label];
            UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0,90, KScreenWidth, 0.5)];
             xian.backgroundColor = [UIColor lightGrayColor];
            [self.dianzanView addSubview:xian];
            self.Liuyan = [[UILabel alloc]init];
            self.Liuyan.frame = CGRectMake(10, 100,100,15);
            if (self.emodel) {
                
                self.Liuyan.text = [NSString stringWithFormat:@"留言 %@",info.comment];
            }
            else
            {
            
                self.Liuyan.text = [NSString stringWithFormat:@"留言 %@",info.comment];
            }
            [self.dianzanView addSubview:self.Liuyan];
        }
        else
        {
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(10, 15, 100, 15);
            label.text = [NSString stringWithFormat:@"点赞 %d",dianzanArray.count];
            [self.dianzanView addSubview:label];
            UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0,90, KScreenWidth, 0.5)];
            xian.backgroundColor = rgb(221, 221, 221, 1);
            [self.dianzanView addSubview:xian];
            self.Liuyan = [[UILabel alloc]init];
            self.Liuyan.frame = CGRectMake(10, 100,100,15);
            if (self.emodel) {
                
                self.Liuyan.text = [NSString stringWithFormat:@"留言 %@",info.comment];
            }
            else
            {
            
                self.Liuyan.text = [NSString stringWithFormat:@"留言 %@",info.comment];
            }
            [self.dianzanView addSubview:self.Liuyan];
            UIImageView *detailImg = [[UIImageView alloc]init];
            detailImg.frame = CGRectMake(10+(KScreenWidth/8+10)*5,label.bottom+5,KScreenWidth/8, KScreenWidth/8);
            detailImg.layer.cornerRadius = KScreenWidth/16;
            detailImg.layer.masksToBounds = YES;
            detailImg.image = [UIImage imageNamed:@"careList"];
            [self.dianzanView addSubview:detailImg];
            detailImg.userInteractionEnabled = YES;
            UITapGestureRecognizer *imagetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [detailImg addGestureRecognizer:imagetap];
            
            if(dianzanUserInfo.count <= 5)
            {
                for (int i = 0; i < dianzanUserInfo.count; i++) {
                    UIImageView *dianzanImg = [[UIImageView alloc]init];
                    dianzanImg.frame = CGRectMake(10+(KScreenWidth/8+10)*i,label.bottom+5,KScreenWidth/8, KScreenWidth/8);
                    dianzanImg.layer.cornerRadius = KScreenWidth/16;
                    dianzanImg.layer.masksToBounds = YES;
                    [dianzanImg.layer setBorderWidth:0.5];
                    [dianzanImg.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                    if(dianzanUserInfo.count>0)
                    {
                    NSString *image = [dianzanUserInfo[i] objectForKey:@"image"];
                        if (image.length<10) {
                            dianzanImg.image = [UIImage imageNamed:@"defaultAva"];
                        }
                        else
                        {
                    [dianzanImg sd_setImageWithURL:[NSURL URLWithString:image]];
                        }
                    }
                    [self.dianzanView addSubview:dianzanImg];
                }
            }
            else
            {
                for (int i = 0; i < 5; i++) {
                    UIImageView *dianzanImg = [[UIImageView alloc]init];
                    dianzanImg.frame = CGRectMake(10+(KScreenWidth/8+10)*i,label.bottom+5,KScreenWidth/8, KScreenWidth/8);
                    dianzanImg.layer.cornerRadius = KScreenWidth/16;
                    dianzanImg.layer.masksToBounds = YES;
                    [dianzanImg.layer setBorderWidth:0.5];
                    [dianzanImg.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                    if(dianzanUserInfo.count>0)
                    {
                        NSString *image = [dianzanUserInfo[i] objectForKey:@"image"];
                        [dianzanImg sd_setImageWithURL:[NSURL URLWithString:image]];
                    }

                    [self.dianzanView addSubview:dianzanImg];
                } 
                
                
                
            }
            
        }

        return self.dianzanView;
    }

    else{
        if ([self.isStory isEqualToString:@"story"]) {
            return nil;
        }else{
            return tableHeaderView;

    }
    }
}



-(void)tap:(UITapGestureRecognizer*)tap
{
    DianzanViewController *dianzan = [[DianzanViewController alloc]init];
    dianzan.dianzanArr = dianzanUserInfo;
    [self.navigationController pushViewController:dianzan animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 120;
    }
    else
    {
        if (self.emodel || self.eventId) {
             return userName.height+titleLabel.height+10+0.5+10;
        }

       else
       {
           return 0.01;
       }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (self.emodel || self.eventId) {
            NSDictionary *picDic = self.eventdata[indexPath.row];
            float textHeight = 0.0;
            if (![[picDic objectForKey:@"txt"] isKindOfClass:[NSNull class]]) {
                CGSize size = [[picDic objectForKey:@"txt"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(KScreenWidth-20, 1000)];
                textHeight = size.height;
            }else{
                textHeight = 10;
            }
            float imageHeight = 0.0;
            NSArray *imageInfo = [self imageUrl:[picDic objectForKey:@"path"]];
            if ([imageInfo[0] isEqual:@338]) {
                imageHeight = 9*KScreenWidth/16;
            }else{
                imageHeight = 3*KScreenWidth/4;
            }
            float cellHeight = textHeight+imageHeight+15;
            return cellHeight;

        }
        else
        {
        return 202;
        }
    }
    else
    {
        comment *commentuser = _data[indexPath.row];
        return [CommentViewCell getCellHeightWithComment:commentuser];
    }

}
-(NSArray *)imageUrl:(NSString *)path{
    //[_pics[4] objectForKey:@"path"]
    NSMutableString *imageUrl;
    NSInteger imageHeight;
    if ([path rangeOfString:@"http:"].location != NSNotFound) {
        imageUrl = [[NSMutableString alloc] initWithString:path];
        imageUrl = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:imageUrl]];
        NSArray *separatedUrl = [imageUrl componentsSeparatedByString:@"_"];
        NSInteger imageWidth = [separatedUrl[1] integerValue];
        imageHeight = [separatedUrl[2] integerValue];
        if (imageWidth>imageHeight) {
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage338]];
            imageHeight = 338;
        }else{
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage422]];
            imageHeight = 422;
        }
    }else{
        imageUrl = [[NSMutableString alloc] initWithString:@""];
    }
    NSNumber *imgH = [NSNumber numberWithInt:imageHeight];
    NSArray *imageInfo = @[imgH,[NSURL URLWithString:imageUrl]];
    return imageInfo;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.emodel || self.eventId) {
            return self.eventdata.count;
        }
        else
        {
        return 1;
        }
    }
    else
    return _data.count;
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (self.emodel || self.eventId) {
            static NSString *identifier = @"EventDetailCell";
            EventDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EventDetailCell" owner:self options:nil] lastObject];
                cell.backgroundColor = rgb(241, 241, 241, 1);
                            }
            cell.eventModel = self.emodel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.picDic = self.eventdata[indexPath.row];
            return cell;

        }
        else
        {
        HeaderViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HeaderViewCell" owner:self options:nil] lastObject];
        cell.indexModel = self.imodel;
        cell.info = info;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
    }
   else{
        static NSString *idenfier = @"CommentViewCell";
        CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
        if (!cell) {
             cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentViewCell" owner:self options:nil]lastObject];
        
        }
       cell.myrow = 100+indexPath.row;
       cell.comment = _data[indexPath.row];
        return cell;
   }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.tf = nil;
        self.v = nil;
        self.tv = nil;
        self.view = nil;
        _data = nil;
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
