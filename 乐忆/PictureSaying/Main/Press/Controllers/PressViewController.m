//
//  PressViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  我的相册

#import "PressViewController.h"
#import "DataService.h"
#import "UIImageView+WebCache.h"
#import "MyLibraryCell.h"
#import "MyLibraryDetailVC.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+Additions.h"
#import "MobClick.h"
@interface PressViewController ()
{
    UILabel *tipLabel;
    NSMutableArray *arrStatus;
}
@end

@implementation PressViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的相册";
    arrStatus = [NSMutableArray array];
        tabView = [[UITableView alloc]init];
        tabView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-44-5);
        tabView.delegate = self;
        tabView.dataSource =self;
        tabView.separatorStyle = YES;
        tabView.showsVerticalScrollIndicator = NO;
        tabView.tableFooterView = [[UIView alloc] init];
         [self.view addSubview:tabView];
        [self _createNavItem];
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, KScreenHeight+50, KScreenWidth-40, 30)];
        tipLabel.alpha = .75;
        tipLabel.backgroundColor = [UIColor blackColor];
        tipLabel.textAlignment = 1;
        tipLabel.font = [UIFont systemFontOfSize:16.0];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.layer.cornerRadius = 5;
        tipLabel.layer.masksToBounds = YES;
        [self.view addSubview:tipLabel];
    if (netStatus != 0) {
        [self requestNewData:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }

    
//    [tabView showLoadingWithLabelText:@"正在加载中"];
    
        __weak PressViewController *viewC = self;
        [tabView addHeaderWithCallback:^{
            if (netStatus != 0) {
                [viewC requestNewData:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [tabView headerEndRefreshing];
                [tabView hideLoading];
            }
        }];
        [tabView addFooterWithCallback:^{
            if (netStatus != 0) {
                [viewC requestNewData:NO];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [tabView footerEndRefreshing];
                [tabView hideLoading];
            }
            
        }];
    
}
#pragma mark - NaviItem
-(void)_createNavItem{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,60, 44);
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    leftButton.showsTouchWhenHighlighted = YES;
    [leftButton setTitle:@"添加" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tightItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = tightItem;
}

#pragma mark - UITableViewDelegate And DataSource
//tableview处理效果
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.data.count){
        static NSString *identifier = @"indexCell";
        MyLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyLibraryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = rgb(251, 251, 251, 1);
        }
        cell.model = self.data[indexPath.row];
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIButton *buttttt = [UIButton buttonWithType:UIButtonTypeCustom];
        buttttt.frame = CGRectMake(10, 10, KScreenWidth/4+10, KScreenWidth/4+10);
        [buttttt setImage:[UIImage imageNamed:@"AlmbAdd"] forState:UIControlStateNormal];
        [buttttt addTarget:self action:@selector(JIaRu:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buttttt];
        UILabel *jiaxiangce = [[UILabel alloc]init];
        jiaxiangce.frame = CGRectMake(buttttt.right+15, KScreenWidth/8, 70, 30);
        jiaxiangce.text = @"添加相册";
        [jiaxiangce setTextColor:[UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1]];
        [cell.contentView addSubview:jiaxiangce];
        cell.backgroundColor = rgb(251, 251, 251, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//添加相册名称细节处理
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    MyPhotos *model = self.data[indexPath.row];
    if ([tableView isEqual:tabView]) {
        if (indexPath.row<self.data.count && [model.status isEqual:@0]) {
            result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
        }
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    //设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [tabView setEditing:editing animated:animated];
    //切换接收者的进入和退出编辑模式。
}
 
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        //如果编辑样式为删除样式
        if (indexPath.row<[self.data count]) {
            localModel = self.data[indexPath.row];
            ip = indexPath;
            [self showAlert];
        }
    }
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    //禁止MMDrawer菜单
//    [self.mmDrawViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KScreenWidth/4+30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count + 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.data.count) {
        MyPhotos *mps = self.data[indexPath.row];
        MyLibraryDetailVC *tttddd = [[MyLibraryDetailVC alloc]init];
        tttddd.Jieshou = mps.AlumbId;
        tttddd.albumName = mps.title;
        [self.navigationController pushViewController:tttddd animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (netStatus != 0) {
                [self ALiter];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
        
    }
}

#pragma mark - ReloadData
-(void)reloadtvData:(NSMutableArray *)data{
    self.data = data;
    [tabView reloadData];
}

#pragma mark - ButtonActions
-(void)rightAction:(UIButton *)rg{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (netStatus != 0) {
            [self ALiter];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
}

-(void)showAlert{
    UIAlertView *Alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除相册吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    Alter.tag = 600;
    [Alter show];
    
}

-(void)ALiter{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"添加相册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [alert textFieldAtIndex:0];
    field.placeholder = @"7个字符以内...";
    field.delegate = self;
    [alert show];
    [MobClick event:@"xiangcetianjia"];
}

////添加新的相册按钮处理
-(void)JIaRu:(UIButton *)tt{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (netStatus != 0) {
            [self ALiter];
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
  
    });
}

//好友添加按钮
-(void)jiaHaoyou:(UIButton *)tt{
 
}

#pragma mark - alertAction
//添加相册名称细节处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 600) {
        switch (buttonIndex) {
            case 1:
            {
                NSString *stttUUrl = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/del",localModel.AlumbId];
                NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
                NSMutableDictionary *dicDele = [NSMutableDictionary dictionary];
                [dicDele setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
                [DataService requestWithURL:stttUUrl params:dicDele httpMethod:@"POST" block1:^(id result) {
                    NSString *sx = [[result objectForKey:@"result"] stringValue];
                    if ([sx isEqualToString:@"-1"]) {
                    }
                } failLoad:^(id result) {
                    
                }];
                [self.data removeObjectAtIndex:ip.row];
                //移除数据源的数据
                [tabView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationLeft];
                //移除tableView中的数据
                [tabView reloadData];
            }
                break;
            default:
                break;
            }
    }else{
        
        if (buttonIndex == 1) {
            if ([[alertView textFieldAtIndex:0]text].length > 0 && [[alertView textFieldAtIndex:0]text].length <= 7)  {
                NSString *dat = [NSString stringWithFormat:@"%@",[NSDate date]];
                NSString *b = [dat substringToIndex:10];
                NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
                NSString *strURl = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/"];
                NSArray *keys = @[@"accountUsn",@"title",@"Time"];
                NSArray *vlues = @[[tempDic objectForKey:@"usn"],[[alertView textFieldAtIndex:0]text],b];
                NSMutableDictionary *dicDele = [NSMutableDictionary dictionaryWithObjects:vlues forKeys:keys];
                [DataService requestWithURL:strURl params:dicDele httpMethod:@"POST" block1:^(id result) {
                NSNumber *AlbId = [result objectForKey:@"result"];
                if ([AlbId isEqual:@0]) {
                MyLibraryDetailVC *MyLibRa= [[MyLibraryDetailVC alloc]init];
                MyLibRa.Jieshou = [[result objectForKey:@"value"]objectForKey:@"id"];
                MyLibRa.kongZhi = @"YES";
                MyLibRa.albumName = [[alertView textFieldAtIndex:0]text];
                [self.navigationController pushViewController:MyLibRa animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
                } else {
                    
                }
                [self requestNewData:YES];
                } failLoad:^(id result) {
                    
                }];
                }else if ([[alertView textFieldAtIndex:0]text].length > 7){
                UIAlertView *altttt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"字数不能超过七个字" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [altttt show];
                }
              else{
                
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相册名不能为空~" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [av show];
                }
            }
           else{
               
        }
    }
}

#pragma mark - DateRequest
-(void)requestNewData:(BOOL)new{
    if (netStatus != 0) {
    //1421999037
    [self showHud:@"正在努力加载新数据..."];
    //获取我的相册的第一个链接信息    相册名称  相册时间  相册缩略图信息
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *dicccc = [NSMutableDictionary dictionary];
        [dicccc setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
        NSString *urlstring = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%lu/10",(new?0:_data.count)];
        [DataService requestWithURL:urlstring params:dicccc httpMethod:@"GET" block1:^(id result) {
          [self hideHud];
            NSArray *resultArray = (NSArray *)result;
            NSMutableArray *aaaa = [NSMutableArray array];
            if (resultArray.count > 0) {
                for(NSDictionary *dicccccc in result)
                {
                    MyPhotos *model = [[MyPhotos alloc] init];
                    model.title = [dicccccc objectForKey:@"title"];
                    NSString *str = [dicccccc objectForKey:@"cover"];
                    if (![str isKindOfClass:[NSNull class]]) {
                        model.ImageName = [dicccccc objectForKey:@"cover"];
                    }else{
                        model.ImageName = @"dfghjkl";
                    }
                    model.status = [dicccccc objectForKey:@"defaut"];
                    model.AlumbId = [dicccccc objectForKey:@"id"];
                    long long time = [[dicccccc objectForKey:@"time"] longLongValue];
                    long long tt = time/1000;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tt];
                    NSTimeZone *zone = [NSTimeZone systemTimeZone];
                    NSInteger inteval = [zone secondsFromGMTForDate:date];
                    NSDate *localDate = [date dateByAddingTimeInterval:inteval];
                    NSDateFormatter *df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateString = [df stringFromDate:localDate];
                    model.Timedate = dateString;
                    [aaaa addObject:model];
                }
                if (new)
                {
                    self.data = aaaa;
                }
                else
                {
                    [self.data addObjectsFromArray:aaaa];
                }
                
                [tabView reloadData];
            }else
            {
                if (new) {
                tipLabel.hidden = NO;
                [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                tipLabel.text = @"您还没相册哦！赶紧创建一个吧";
                CGRect rect = tipLabel.frame;
                rect.origin.y = KScreenHeight-180;
                tipLabel.frame = rect;
                } completion:nil];
                [self performSelector:@selector(hideTip) withObject:nil afterDelay:3];
                }
                else{
                    tipLabel.hidden = NO;
                    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        tipLabel.text = @"没有更多了...";
                        CGRect rect = tipLabel.frame;
                        rect.origin.y = KScreenHeight-180;
                        tipLabel.frame = rect;
                    } completion:nil];
                    [self performSelector:@selector(hideTip) withObject:nil afterDelay:3];
                    
                }
               }
            [tabView headerEndRefreshing];
            [tabView footerEndRefreshing];
            [tabView hideLoading];
            
        } failLoad:^(id result) {
            [self hideHud];
            [tabView headerEndRefreshing];
            [tabView footerEndRefreshing];
            [tabView hideLoading];
      }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接,请检查您的网络设置!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)hideTip{
    [UIView animateWithDuration:1.0 animations:^{
        tipLabel.hidden = YES;
    }];
}

-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
{
//        butt = nil;
//        biaotiLabel= nil;
//        timaLabel =nil;
//        tianjiaHaoyou= nil;
//        tabView =nil;
//        self.view = nil;
//        self.data = nil;
   }
}

@end
