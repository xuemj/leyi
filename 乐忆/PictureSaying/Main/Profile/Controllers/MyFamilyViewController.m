//
//  MyFamilyViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/30.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "MyFamilyViewController.h"
#import "groupTableViewCell.h"
#import "CreateStoryViewController.h"
@interface MyFamilyViewController ()<UITableViewDataSource,UITableViewDelegate,returnDelegate,UIAlertViewDelegate>
{
    
    UITableView *tv;
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    NSMutableArray *arr4;
    NSMutableArray *arr;
    MBProgressHUD *_hud;
    NSMutableDictionary *friendInfos;
    NSString *filename;
    NSMutableArray *friendusn;
    NSMutableArray *friendid;
    NSString *story;
    NSMutableArray *storyShare;
  
}
@end

@implementation MyFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array1RequestCompleteCount = -1;
    _array2RequestCompleteCount = -1;
    _array3RequestCompleteCount = -1;
    _array4RequestCompleteCount = -1;
    
    if ([self.isInvite isEqualToString:@"no"])
  {
    self.title = @"我的家人";
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0,0, 50, 22);
      [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];

    //请求好友信息(昵称.头像)数组列
    arr1 = [NSMutableArray array];
    arr2 = [NSMutableArray array];
    arr3 = [NSMutableArray array];
    arr4 = [NSMutableArray array];
    arr = [NSMutableArray array];

    //创建tabview
    tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tv.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    tv.delegate = self;
    tv.dataSource = self;
    tv.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tv];
    // 1. 创建一个plist文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    filename=[path stringByAppendingPathComponent:@"FriendInfos.plist"];
    if (netStatus != 0)
    {
        [self FriendsInfo];
    }
    else
    {
       NSString *sRead = [[NSString alloc]initWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
      
        NSData *dataa = [sRead dataUsingEncoding:NSUTF8StringEncoding];
        arr = [NSJSONSerialization JSONObjectWithData:dataa options:NSJSONReadingMutableContainers error:nil];

    }
  }
    else if ([self.isInvite isEqualToString:@"yes"])
  {
    
      self.title = @"共享好友";
      UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      leftBtn.frame = CGRectMake(0,0, 50, 22);
      [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
      [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
      
      UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      rightBtn.frame = CGRectMake(0,0, 50, 22);
      [rightBtn setTitle:@"确定"  forState:UIControlStateNormal];
      [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
      //创建tabview
      tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
      tv.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
      tv.delegate = self;
      tv.dataSource = self;
      [self.view addSubview:tv];

      //请求好友信息(昵称.头像)数组列
      arr1 = [NSMutableArray array];
      arr2 = [NSMutableArray array];
      arr3 = [NSMutableArray array];
      arr4 = [NSMutableArray array];
      arr = [NSMutableArray array];
      
      //好友usn数组
      friendusn = [NSMutableArray array];
      //好友id数组
      friendid = [NSMutableArray array];
      //接收好友usn
      self.addPhone = [NSMutableArray array];
      self.cancelPhone = [NSMutableArray array];
      self.shareid = [NSMutableArray array];
     // self.cacelid = [NSMutableArray array];
      // 1. 创建一个plist文件
      NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
      NSString *path=[paths objectAtIndex:0];
      filename=[path stringByAppendingPathComponent:@"InviteInfos.plist"];
      if (netStatus != 0)
      {
          [self FriendsInfo];
      }
      else
      {
          NSString *sRead = [[NSString alloc]initWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
          
          NSData *dataa = [sRead dataUsingEncoding:NSUTF8StringEncoding];
          arr = [NSJSONSerialization JSONObjectWithData:dataa options:NSJSONReadingMutableContainers error:nil];
      }
  
   }
    
    _cellArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (int i = 0; i < 4; i++)
    {
        groupTableViewCell *cell = [[groupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" withArray:arr[i] withId:self.isInvite];
        [_cellArray addObject:cell];
        cell.row = i;
    }
}

-(void)backAction{
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

-(void)FriendsInfo 
{
    NSString *urlf;
    if (self.albumId.length>0) {
        urlf = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/shared/%@/usns",self.albumId];
        [DataService requestWithURL:urlf params:nil httpMethod:@"GET" block1:^(id result) {
            for(NSDictionary *d in result)
            {
                NSString *s = [d objectForKey:@"accountUsn"];
                
                [friendusn addObject:s];
            }
        } failLoad:^(id result) {
            
        }];
    }
    else{
        if (self.storyId.length>0)
        {
             storyShare = [NSMutableArray array];
             urlf = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/storyUser/listByStory/%@/0/100",self.storyId]
            ;
            [DataService requestWithURL:urlf params:nil httpMethod:@"GET" block1:^(id result) {
                for(NSDictionary *d in result)
                {
               
                    NSString *s = [d objectForKey:@"userId"];
                    NSString *sun =[d objectForKey:@"usn"];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:s forKey:@"userId"];
                    [dic setObject:sun forKey:@"usn"];
                    [self.shareid addObject:dic];
                    [friendid addObject:s];
                }
               // NSLog(@"sssssssssssssssss----------------%@",friendid);
                
              

            } failLoad:^(id result) {
                
            }];
            
            story = @"yes";
        }
        else
        {
        story = @"yes";
        storyShare = [NSMutableArray array];
   
        }
    }
   
    
    NSDictionary *zwDic1 = [NSDictionary dictionaryWithObject:@"yes" forKey:@"zhanwei"];
    [arr1 addObject:zwDic1];
    
    NSDictionary *zwDic2 = [NSDictionary dictionaryWithObject:@"yes" forKey:@"zhanwei"];
    [arr2 addObject:zwDic2];

    
    NSDictionary *zwDic3 = [NSDictionary dictionaryWithObject:@"yes" forKey:@"zhanwei"];
    [arr3 addObject:zwDic3];
    
    NSDictionary *zwDic4 = [NSDictionary dictionaryWithObject:@"yes" forKey:@"zhanwei"];
    [arr4 addObject:zwDic4];
    
    [arr addObject:arr1];
    [arr addObject:arr2];
    [arr addObject:arr3];
    [arr addObject:arr4];
  
    [tv reloadData];
    
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
  
    NSString *sk = [tempDic objectForKey:@"id"];
    
    //当有网络情况下,才允许网络请求
    if (netStatus != 0) {
    
    [self showHud:@"正在加载好友列表..."];
    //第一组请求
    ///WeiXiao/api/v1/user/addressBook/{id}
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/addressBook/list/%@/1",sk];
    [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
        [self hideHud];
        NSArray *a = (NSArray *)result;
        
        for (NSMutableDictionary *d in a) {
            //            [arr1 addObject:d];
            [arr1 insertObject:d atIndex:arr1.count-1];
        }
 
        [self userInfo1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tv reloadData];
        });
    } failLoad:^(id result) {
        
    }];
    //第二组请求
    NSString *urlstring1 = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/addressBook/list/%@/2",sk];
    [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
        NSArray *a = (NSArray *)result;
        for (NSMutableDictionary *d in a) {
         
            [arr2 insertObject:d atIndex:arr2.count-1];
           
            
        }
      
        [self userInfo2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tv reloadData];
        });
    } failLoad:^(id result) {
        
    }];
    
    //第三组请求
    NSString *urlstring2 = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/addressBook/list/%@/3",sk];
    [DataService requestWithURL:urlstring2 params:nil httpMethod:@"GET" block1:^(id result) {
        NSArray *a = (NSArray *)result;
        for (NSMutableDictionary *d in a) {
        
            [arr3 insertObject:d atIndex:arr3.count-1];
            
        }
  
        [self userInfo3];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tv reloadData];
        });
    } failLoad:^(id result) {
        
    }];

    //第四组请求
    NSString *urlstring3 = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/addressBook/list/%@/4",sk];
    [DataService requestWithURL:urlstring3 params:nil httpMethod:@"GET" block1:^(id result) {
        NSArray *a = (NSArray *)result;
        for (NSMutableDictionary *d in a){
        
            [arr4 insertObject:d atIndex:arr4.count-1];
        }

        [self userInfo4];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tv reloadData];
        });
    } failLoad:^(id result) {
        
    }];
    }
}

-(void)refreshUserInfoWithDictionary:(NSMutableDictionary *)userInfoDic withReplaceDictionary:(NSDictionary *)replaceDic
{
    NSMutableArray *arrayTmp = arr[_rowCount-1];
    if ([arrayTmp isKindOfClass:[NSArray class]] && arrayTmp.count > 0)
    {
        if (replaceDic != nil)
        {
            int location = 0;
            for (int i = 0; i < arrayTmp.count; i++)
            {
                NSDictionary *dicTmp = arrayTmp[i];
                if (dicTmp == replaceDic)
                {
                    location = i;
                    break;
                }
            }
            [arrayTmp replaceObjectAtIndex:location withObject:userInfoDic];
        }
        else
        {
            [arrayTmp insertObject:userInfoDic atIndex:arrayTmp.count-1];
        }
    }
    [self requestFriendImageWithDic:userInfoDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tv reloadData];
    });
}

-(void)sendTocount:(NSInteger)count1
{
    self.rowCount = count1;

}


-(void)userInfo1
{
    for (int i = 0; i < arr1.count-1; i++)
    {
    NSString *fusn = [arr1[i] objectForKey:@"friendUsn"];
 //   NSString *fSource = [arr1[i] objectForKey:@"friendId"];
    
    if ([fusn length] > 0)
    {
        NSString *urlstring1 =[NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",fusn];
        [DataService requestWithURL:urlstring1 params: nil httpMethod:@"GET" block1:^(id result) {
        NSDictionary *a= (NSDictionary *)result;
            if (self.albumId.length>0) {
             
                NSString *mp = [a objectForKey:@"usn"];
                if ([friendusn indexOfObject:mp] != NSNotFound) {
                        [arr1[i] setObject:@1 forKey:@"status"];
                }
                else
                {
                    [arr1[i] setObject:@0 forKey:@"status"];
                }
               
            }
            if (self.storyId.length>0) {
              
                    NSString *mpid = [arr1[i] objectForKey:@"friendId"];
                    if ([friendid indexOfObject:mpid] != NSNotFound) {
                        [arr1[i] setObject:@1 forKey:@"status"];
                    }
                    else
                    {
                        [arr1[i] setObject:@0 forKey:@"status"];
                    }
                }
            
            
            if ([[a allKeys] count]>0) {
                NSString *image = [a objectForKey:@"image"];
                if (image.length>0) {
                    [arr1[i] setObject:image forKey:@"image"];
                }else{
                    [arr1[i] setObject:@"0" forKey:@"image"];
                }
                [tv reloadData];
                [self saveToLocation1];
            }
        } failLoad:^(id result) {
            [self saveToLocation1];
          
        }];
    }
    else
    {
        [self saveToLocation1];
        [arr1[i] setObject:@2 forKey:@"status"];
    }
}
    
}

-(void)saveToLocation1
{
    _array1RequestCompleteCount++;
    if (_array1RequestCompleteCount == arr1.count-2) {
        [self writeToFile];
    }
}

-(void)userInfo2
{
    for (int i = 0; i < arr2.count-1; i++)
    {
    NSString *fusn = [arr2[i] objectForKey:@"friendUsn"];
    if ([fusn length] > 0)
    {
        NSString *urlstring1 =[NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",fusn];
        [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
            NSDictionary *a = (NSDictionary *)result;
            if (self.albumId.length>0) {
                  NSString *mp = [a objectForKey:@"usn"];
                if ([friendusn indexOfObject:mp] != NSNotFound) {
                    [arr2[i] setObject:@1 forKey:@"status"];
                }
                else
                {
                    [arr2[i] setObject:@0 forKey:@"status"];
                }
               
            }
            if (self.storyId.length>0) {
              NSString *mpid = [arr2[i] objectForKey:@"friendId"];
                if ([friendid indexOfObject:mpid] != NSNotFound) {
                    [arr2[i] setObject:@1 forKey:@"status"];
                }
                else
                {
                    [arr2[i] setObject:@0 forKey:@"status"];
                }
            }
            if ([[a allKeys] count]>0) {
                NSString *image = [a objectForKey:@"image"];
                if (image.length>0) {
                    [arr2[i] setObject:image forKey:@"image"];
                }else{
                    [arr2[i] setObject:@"0" forKey:@"image"];
                }
                [tv reloadData];
                [self saveToLocation2];
            }
        } failLoad:^(id result) {
            [self saveToLocation2];
       
        }];
    }
    else
    {
        [self saveToLocation2];
        [arr2[i] setObject:@2 forKey:@"status"];
    }
}
    
}

-(void)saveToLocation2
{
    _array2RequestCompleteCount++;
    if (_array2RequestCompleteCount == arr2.count-2) {
        [self writeToFile];
    }
}

-(void)userInfo3
{
    for (int i = 0; i < arr3.count-1; i++)
    {
       
        NSString *fusn = [arr3[i] objectForKey:@"friendUsn"];
        if ([fusn length] > 0)
        {
            NSString *urlstring1 =[NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",fusn] ;
            [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
                NSDictionary *a = (NSDictionary *)result;
                if (self.albumId.length>0) {
                  
                    NSString *mp = [a objectForKey:@"usn"];
                    if ([friendusn indexOfObject:mp] != NSNotFound) {
                        [arr3[i] setObject:@1 forKey:@"status"];
                    }
                    else
                    {
                        [arr3[i] setObject:@0 forKey:@"status"];
                    }

                }
                if (self.storyId.length>0) {
               
                    NSString *mpid = [arr3[i] objectForKey:@"friendId"];
                    if ([friendid indexOfObject:mpid] != NSNotFound) {
                        [arr3[i] setObject:@1 forKey:@"status"];
                    }
                    else
                    {
                        [arr3[i] setObject:@0 forKey:@"status"];
                    }
                 
                }
                if ([[a allKeys] count]>0) {
                    NSString *image = [a objectForKey:@"image"];
                    if (image.length>0) {
                        [arr3[i] setObject:image forKey:@"image"];
                    }else{
                        [arr3[i] setObject:@"0" forKey:@"image"];
                    }
                    [tv reloadData];
                    [self saveToLocation3];
                }
            } failLoad:^(id result) {
                [self saveToLocation3];
              
            }];
        }
        else
        {
            [self saveToLocation3];
            [arr3[i] setObject:@2 forKey:@"status"];
        }
    }
    
}

-(void)saveToLocation3
{
    _array3RequestCompleteCount++;
    if (_array3RequestCompleteCount == arr3.count-2) {
        [self writeToFile];
    }
}

-(void)userInfo4
{
    for (int i = 0; i < arr4.count-1; i++)
    {
        NSString *fusn = [arr4[i] objectForKey:@"friendUsn"];
        
        if ([fusn length] > 0)
        {
            NSString *urlstring1 =[NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",fusn] ;
            [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
                NSDictionary *a= (NSDictionary *)result;
                if (self.albumId.length>0) {
                   
                    NSString *mp = [a objectForKey:@"usn"];
                    if ([friendusn indexOfObject:mp] != NSNotFound) {
                        [arr4[i] setObject:@1 forKey:@"status"];
                    }
                    else
                    {
                        [arr4[i] setObject:@0 forKey:@"status"];
                    }
               
                }
                if (self.storyId.length>0) {
                    
                    NSString *mpid = [arr4[i] objectForKey:@"friendId"];
                    if ([friendid indexOfObject:mpid] != NSNotFound) {
                        [arr4[i] setObject:@1 forKey:@"status"];
                    }
                    else
                    {
                        [arr4[i] setObject:@0 forKey:@"status"];
                    }
                   
                }
                if ([[a allKeys] count]>0) {
                    NSString *image = [a objectForKey:@"image"];
                    if (image.length>0) {
                        [arr4[i] setObject:image forKey:@"image"];
                    }else{
                        [arr4[i] setObject:@"0" forKey:@"image"];
                    }
                    [tv reloadData];
                    [self saveToLocation4];
                }
            } failLoad:^(id result) {
                [self saveToLocation4];
            }];
        }
        else
        {
            [self saveToLocation4];
            [arr4[i] setObject:@2 forKey:@"status"];
        }
    }
}

-(void)saveToLocation4
{
    _array4RequestCompleteCount++;
    if (_array4RequestCompleteCount == arr4.count-2) {
        [self writeToFile];
    }
}

-(void)requestFriendImageWithDic:(NSMutableDictionary *)dic
{
    NSString *fusn = [dic objectForKey:@"friendUsn"];
    NSString *urlstring1 =[NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",fusn] ;
    [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
        NSDictionary *a = (NSDictionary *)result;
        NSString *mp = [a objectForKey:@"usn"];
        if ([friendusn indexOfObject:mp] != NSNotFound) {
            [dic setObject:@1 forKey:@"status"];
        }
        else
        {
            [dic setObject:@0 forKey:@"status"];
        }
        if ([[a allKeys] count]>0) {
            NSString *image = [a objectForKey:@"image"];
            if (image.length>0) {
                [dic setObject:image forKey:@"image"];
            }else{
                [dic setObject:@"0" forKey:@"image"];
            }
            [tv reloadData];
            [self writeToFile];
        }
    } failLoad:^(id result) {
        
    }];
}

-(void)writeToFile{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *jsonString = [arr JSONString];
        [jsonString writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
 
  
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
    
}
-(void)click:(UIButton*)sender
{
    //添加好友
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSString *sku = [tempDic objectForKey:@"usn"];
    
    if ([story isEqualToString:@"yes"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定分享给这些好友吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
        [alert show];
    }
    else
    {
        if (self.addPhone.count>0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *musn = sku;
            [dic setObject:musn forKey:@"accountUsn"];
            [dic setObject:self.addPhone forKey:@"toAccountUsn"];
            NSString *s = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v3/album/shared/%@",self.albumId];
            
            NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
            [DataService requestWithURL:s params:dic requestHeader:headerDic httpMethod:@"POST" block:^(NSObject *result) {
                
            } failLoad:^(id result) {
                
            }];
        }
        if (self.cancelPhone.count>0) {
            
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            NSString *musn1 = sku;
            [dic1 setObject:musn1 forKey:@"accountUsn"];
            [dic1 setObject:self.cancelPhone forKey:@"toAccountUsn"];
            NSString *s1 = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v2/album/nshared/%@",self.albumId];
            
            NSDictionary *headerDic1 = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
            
            [DataService requestWithURL:s1 params:dic1 requestHeader:headerDic1 httpMethod:@"POST" block:^(NSObject *result) {
                
            } failLoad:^(id result) {
                
            }];
            
        }
        if(self.albumId.length>0 &&(self.cancelPhone.count>0 || self.addPhone.count>0))
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享(取消)成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有做有效操作!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([story isEqualToString:@"yes"]) {
        if (buttonIndex == 1) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isMemberOfClass:[CreateStoryViewController class]]) {
                    CreateStoryViewController *createSVC = (CreateStoryViewController *)vc;
//                    if (storyShare.count == 0) {
//                        NSMutableDictionary *d = [NSMutableDictionary dictionary];
//                        [d setObject:@0 forKey:@"userId"];
//                        [storyShare addObject:d];
//                    }
                    createSVC.reciveArr = self.shareid;
                    [self.navigationController popToViewController:createSVC animated:YES];
                    
                   
                }
            }
            
        }
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
     
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   [tv reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    NSInteger row = [arr[indexPath.row] count]-1;
    return ((KScreenWidth-120)/5+30)*(row/5+1)+30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    groupTableViewCell *cell = nil;
    if (indexPath.row < _cellArray.count)
    {
        cell = _cellArray[indexPath.row];
        cell.row = indexPath.row;
        cell.a = arr[indexPath.row];
        return cell;
    }
    else
    {
        return nil;
    }
    
 
    

}
@end
