//
//  CreateStoryViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/17.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  创建故事

#import "CreateStoryViewController.h"
#import "CreateViewController.h"
#import "WhoCanLookViewController.h"
#import "ImagePickerViewController.h"
#import "PSConfigs.h"

#define coverUrl /WeiXiaoStory/api/v1/upload/story/{storyId}/cover


@interface CreateStoryViewController ()<UITextFieldDelegate,UITextViewDelegate,ImagePickerViewControllerDelegateDefine>
{
    UILabel *label1;
    WhoCanLookViewController *whoCanLookVC;
    UIButton *selectCover;
    NSString *selectedCover;
}
@end

@implementation CreateStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.conTitle.length>0) {
        self.title = @"编辑故事";
    }else{
        self.title = @"创建故事";
    }
    [self _createNavItems];
    [self _initViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (whoCanLookVC != nil) {
        if(whoCanLookVC.str.length>0){
            label1.text = whoCanLookVC.str;
        }
    }
    if (self.reciveArr.count>0) {
        label1.text = @"指定好友";
    }
}

-(void)_createNavItems{
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 60, 44);
    doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.showsTouchWhenHighlighted = YES;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)_initViews{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    [self.view addSubview:_scrollView];
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, KScreenWidth, 45)];
    firstView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:firstView];
    [self addLineWithWidth:0 withHeight:0 toView:firstView];
    //故事标题
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(15,0.5,KScreenWidth-30, 44)];
    self.tf.placeholder = @"请填写故事标题(21个字以内)";
    self.tf.delegate = self;
    self.tf.font = [UIFont systemFontOfSize:14.0];
    self.tf.returnKeyType = UIReturnKeyDone;
    self.tf.backgroundColor = [UIColor clearColor];
    if (self.model != nil) {
        self.tf.text = self.model.title;
        _storyName = self.model.title;
        [self.tf resignFirstResponder];
    }
    [firstView addSubview:self.tf];
    [self addLineWithWidth:0 withHeight:self.tf.bottom toView:firstView];
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, firstView.bottom+15, KScreenWidth, self.tf.height*3.5)];
    secondView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:secondView];
    [self addLineWithWidth:0 withHeight:0 toView:secondView];
    //故事描述
    self.tv = [[UITextView alloc]initWithFrame:CGRectMake(15,5, KScreenWidth-30,secondView.height-5)];
    self.tv.backgroundColor = [UIColor clearColor];
    self.tv.delegate = self;
    self.tv.font = [UIFont systemFontOfSize:14.0];
    self.tv.returnKeyType = UIReturnKeyDone;
    if (self.model != nil) {
        self.tv.text = self.model.descrip;
        _storyDisc = self.model.descrip;
    }
    [secondView addSubview:self.tv];
    
    [self addLineWithWidth:0 withHeight:self.tv.bottom toView:secondView];
    
    self.labelText = [[UILabel alloc] initWithFrame:CGRectMake(2,5, 200, 20)];
    self.labelText.font = [UIFont systemFontOfSize:14.0];
    self.labelText.text = @"对故事进行描述(140字以内).....";
    if (self.model != nil) {
        self.labelText.hidden = YES;
    }
    self.labelText.textColor = rgb(198, 198, 198, 1);
    [self.tv addSubview:self.labelText];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, secondView.bottom+15, KScreenWidth, 45);
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(whoCanLookAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    [self addLineWithWidth:0 withHeight:0 toView:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0.5, 150, 44)];
    label.text = @"谁可以看";
    [button addSubview:label];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(button.width-140, 0.5, 100, 44)];
    label1.textColor = rgb(137, 137, 137, 1);
    label1.textAlignment = 2;
    label1.text = @"公开";
    label1.backgroundColor = [UIColor clearColor];
    [button addSubview:label1];
    [self addLineWithWidth:0 withHeight:label.bottom toView:button];
    [self addArrowWithHeight:(button.height-15)/2 ToParentView:button];
    
//    UILabel *mobanlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, button.bottom+10, KScreenWidth-30, 25)];
//    mobanlabel.text = @"选择模板";
//    [_scrollView addSubview:mobanlabel];

    UIView *coverBg = [[UIView alloc] initWithFrame:CGRectMake(0, button.bottom, KScreenWidth, 100)];
    coverBg.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:coverBg];
    UILabel *mobanlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth-30, 25)];
    mobanlabel.text = @"选择封面";
    [coverBg addSubview:mobanlabel];
    
//    UIImageView *mobanView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, mobanlabel.bottom+5, (KScreenWidth-50)/2, (KScreenWidth-50)/2*472/270)];
//    //KScreenHeight-mobanlabel.bottom-80
//    mobanView1.tag = 100;
//    mobanView1.backgroundColor = [UIColor orangeColor];
//    mobanView1.image = [UIImage imageNamed:@"moban1"];
//    [_scrollView addSubview:mobanView1];
    
//    UIImageView *smallIV1 = [[UIImageView alloc] initWithFrame:CGRectMake(mobanView1.width-25,5, 20, 20)];
//    smallIV1.image = [UIImage imageNamed:@"c6"];
//    smallIV1.tag = 101;
//    smallIV1.hidden = NO;
//    [mobanView1 addSubview:smallIV1];
    self.templateId = @"1";
    
//    UIImageView *mobanView2 = [[UIImageView alloc] initWithFrame:CGRectMake(mobanView1.right+20, mobanlabel.bottom+5, (KScreenWidth-50)/2, (KScreenWidth-50)/2*472/270)];
//    mobanView2.tag = 102;
//    mobanView2.userInteractionEnabled = YES;
//    mobanView2.backgroundColor = [UIColor brownColor];
//    mobanView2.image = [UIImage imageNamed:@"moban2"];
//    [_scrollView addSubview:mobanView2];
    
//    UIImageView *smallIV2 = [[UIImageView alloc] initWithFrame:CGRectMake(mobanView2.width-25,5, 20, 20)];
//    smallIV2.image = [UIImage imageNamed:@"c6"];
//    smallIV2.tag = 103;
//    smallIV2.hidden = YES;
//    [mobanView2 addSubview:smallIV2];
    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1:)];
//    [mobanView1 addGestureRecognizer:tap1];
    
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2:)];
//    [mobanView2 addGestureRecognizer:tap2];
//    if (self.model.templateId.length>0) {
//        if ([self.model.templateId isEqualToString:@"1"]) {
//            smallIV1.hidden = NO;
//            smallIV2.hidden = YES;
//            mobanView1.userInteractionEnabled = NO;
//            mobanView1.userInteractionEnabled = YES;
//        }else{
//            smallIV2.hidden = NO;
//            smallIV1.hidden = YES;
//            mobanView2.userInteractionEnabled = NO;
//            mobanView1.userInteractionEnabled = YES;
//        }
//        self.templateId = self.model.templateId;
//    }
    selectCover = [UIButton buttonWithType:UIButtonTypeCustom];
    selectCover.frame = CGRectMake(15, mobanlabel.bottom+10, KScreenWidth-30, (KScreenWidth-30)*9/16);
    selectCover.imageView.contentMode = UIViewContentModeScaleAspectFill;
    selectCover.backgroundColor = rgb(240, 240, 240, 1);
    [selectCover addTarget:self action:@selector(selectCover:) forControlEvents:UIControlEventTouchUpInside];
    [selectCover setImage:[UIImage imageNamed:@"加号IOS.png"] forState:UIControlStateNormal];
    [coverBg addSubview:selectCover];
    coverBg.frame = CGRectMake(0, button.bottom, KScreenWidth, mobanlabel.height+selectCover.height+100);
    _scrollView.contentSize = CGSizeMake(KScreenWidth, selectCover.bottom+10);
}

#pragma mark - ButtonAction
-(void)whoCanLookAction:(UIButton *)btn{
    whoCanLookVC = [[WhoCanLookViewController alloc] init];
    whoCanLookVC.isOpen = label1.text;
    whoCanLookVC.sssid = self.model.sid;
    [self.navigationController pushViewController:whoCanLookVC animated:YES];
}

-(void)selectCover:(UIButton *)btn{
    ImagePickerViewController *picker = [[ImagePickerViewController alloc]init];
    picker.isAva = @"noava";
    picker.delegateDefine = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerDidChooseImage:(ImagePickerViewController *)imagePickerViewController withImage:(UIImage *)image{
    [self saveImage:image WithName:@"storyCover.jpg"];
    selectedCover = @"yes";
    [selectCover setImage:image forState:UIControlStateNormal];
}

-(void)tapAction1:(UITapGestureRecognizer *)tap{
    UIImageView *iv = (UIImageView *)[tap.view viewWithTag:101];
    iv.hidden = NO;
    tap.view.userInteractionEnabled = NO;
    UIImageView *moban2 = (UIImageView *)[self.view viewWithTag:102];
    moban2.userInteractionEnabled = YES;
    UIImageView *mobansmall = (UIImageView *)[moban2 viewWithTag:103];
    mobansmall.hidden = YES;
    self.templateId = @"1";
}

-(void)tapAction2:(UITapGestureRecognizer *)tap{
    UIImageView *iv = (UIImageView *)[tap.view viewWithTag:103];
    iv.hidden = NO;
    tap.view.userInteractionEnabled = NO;
    UIImageView *moban1 = (UIImageView *)[self.view viewWithTag:100];
    moban1.userInteractionEnabled = YES;
    UIImageView *mobansmall = (UIImageView *)[moban1 viewWithTag:101];
    mobansmall.hidden = YES;
    self.templateId = @"2";
}

-(void)doneAction:(UIButton *)btn{
    _storyName = self.tf.text;
    if (_storyDisc != nil&&_storyDisc.length>0&&_storyName != nil&&_storyName.length>0) {
        if (![selectedCover isEqualToString:@"yes"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择故事封面" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if (netStatus != 0) {
            [self showAlert];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接,请 检查您的网络设置!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请把信息填写完整" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.tf resignFirstResponder];
        [self.tv resignFirstResponder];
        [alert show];
    }
    
}

#pragma mark - showAlert
-(void)showAlert{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定保存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.tag = 150;
//    [alertView show];
    [self showHud:@"正在提交信息,请稍后..."];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    [param setObject:@"nimo" forKey:@"nickname"];
    [param setObject:@"0" forKey:@"source"];
    [param setObject:@"0" forKey:@"status"];
    [param setObject:@"0" forKey:@"support"];
    [param setObject:[tempDic objectForKey:@"id"] forKey:@"userId"];
    [param setObject:[tempDic objectForKey:@"usn"] forKey:@"usn"];
    if ([label1.text isEqualToString:@"私密"]) {
        [param setObject:@"1" forKey:@"visible"];
    }else if ([label1.text isEqualToString:@"指定好友"]){
        [param setObject:@"2" forKey:@"visible"];
    }else if([label1.text isEqualToString:@"所有好友"]){
        [param setObject:@"3" forKey:@"visible"];
    }else{
        [param setObject:@"0" forKey:@"visible"];
    }
    [param setObject:self.templateId forKey:@"templateId"];
    [param setObject:_storyName forKey:@"title"];
    [param setObject:_storyDisc forKey:@"description"];
        NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/plain;charset=UTF-8" forKey:@"Content-Type"];
        [DataService requestWithURL:@"/WeiXiao/api/v1/story/add" params:param requestHeader:headerDic httpMethod:@"POST" block:^(NSObject *result) {
            NSDictionary *dic = (NSDictionary *)result;
            NSString *s = [dic objectForKey:@"id"];
            if (s != nil) {
                
                [self postCover:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
        
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建失败,请重试！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新创建", nil];
                    alert.tag = 200;
                    [alert show];
                });
            }
            
        } failLoad:^(id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [PSConfigs showProgressWithError:result withView:self.view operationResponseString:nil delayShow:YES isImage:NO];
                
            });
        }];
        
//    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 150){
        if (buttonIndex == 0) {
            
        }else{
            [self showHud:@"正在提交信息,请稍后..."];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            [param setObject:@"nimo" forKey:@"nickname"];
            [param setObject:@"0" forKey:@"source"];
            [param setObject:@"0" forKey:@"status"];
            [param setObject:@"0" forKey:@"support"];
            [param setObject:[tempDic objectForKey:@"id"] forKey:@"userId"];
            [param setObject:[tempDic objectForKey:@"usn"] forKey:@"usn"];
            if ([label1.text isEqualToString:@"私密"]) {
                [param setObject:@"1" forKey:@"visible"];
            }else if ([label1.text isEqualToString:@"指定好友"]){
                [param setObject:@"2" forKey:@"visible"];
            }else if([label1.text isEqualToString:@"所有好友"]){
                [param setObject:@"3" forKey:@"visible"];
            }else{
                [param setObject:@"0" forKey:@"visible"];
            }
            [param setObject:self.templateId forKey:@"templateId"];
            [param setObject:_storyName forKey:@"title"];
            [param setObject:_storyDisc forKey:@"description"];
            
            if (self.model!=nil) {
                
                if (self.reciveArr.count > 0) {
                    NSArray *a = self.reciveArr;
                    
                    NSMutableArray *arr = [NSMutableArray array];
                    NSString *userid ;
                    for(NSDictionary *ddd in a)
                    {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        userid = [ddd objectForKey:@"userId"];
                        [dic setObject:self.model.sid forKey:@"storyId"];
                        [dic setObject:userid forKey:@"userId"];
                        [arr addObject:dic];
                    }
                    NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/storyUser/updateByStory/%@",self.model.sid];
                    NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
                    [DataService requestWithURL:url params:arr requestHeader:headerDic httpMethod:@"POST" block2:^(NSObject *result) {
                
                    } failLoad:^(id result) {
                        
                    }];
                }
                [param setObject:self.model.originalTime forKey:@"time"];
                [param setObject:self.model.sid forKey:@"id"];
                [DataService requestWithURL:@"/WeiXiao/api/v1/story/edit" params:param requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
                    [self hideHud];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
                        
                    });
                } failLoad:^(id result) {
                    
                }];

            }else{
                NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/plain;charset=UTF-8" forKey:@"Content-Type"];
                [DataService requestWithURL:@"/WeiXiao/api/v1/story/add" params:param requestHeader:headerDic httpMethod:@"POST" block:^(NSObject *result) {
                    NSDictionary *dic = (NSDictionary *)result;
                    NSString *s = [dic objectForKey:@"id"];
                    if (s != nil) {
                        self.model.sid = s;
                        if (self.reciveArr.count > 0) {
                            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
                            NSArray *a = self.reciveArr;
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            NSMutableArray *arr = [NSMutableArray array];
                            NSString *userid ;
                            for(NSDictionary *ddd in a)
                            {
                                userid = [ddd objectForKey:@"userId"];
                                [dic setObject:s forKey:@"storyId"];
                                [dic setObject:[tempDic objectForKey:@"source"] forKey:@"source"];
                                [dic setObject:[tempDic objectForKey:@"usn"] forKey:@"usn"];
                                [dic setObject:userid forKey:@"userId"];
                                [arr addObject:dic];
                            }
                            NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/storyUser/updateByStory/%@",s];
                            NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
                            [DataService requestWithURL:url params:arr requestHeader:headerDic httpMethod:@"POST" block2:^(NSObject *result) {
                            } failLoad:^(id result) {
                                
                            }];
                        }
                        [self postCover:dic];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            CreateViewController *createVC = [[CreateViewController alloc] init];
                            createVC.storyDic = (NSDictionary *)result;
                            createVC.storyName = _storyName;
                            createVC.isAdded = @"storyed";
                            createVC.isPopRoot = @"poptoroot";
                            [self.navigationController pushViewController:createVC animated:YES];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideHud];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建失败,请重试！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新创建", nil];
                            alert.tag = 200;
                            [alert show];
                        });
                    }

                } failLoad:^(id result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideHud];
                        [PSConfigs showProgressWithError:result withView:self.view operationResponseString:nil delayShow:YES isImage:NO];

                    });
                }];

                }
            
        }
    }else if(alertView.tag == 200){
        if (buttonIndex == 0) {
            
        }else{
            [self showHud:@"正在提交信息,请稍后..."];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            [param setObject:@"nimo" forKey:@"nickname"];
            [param setObject:@"0" forKey:@"source"];
            [param setObject:@"0" forKey:@"status"];
            [param setObject:@"0" forKey:@"support"];
            [param setObject:[tempDic objectForKey:@"id"] forKey:@"userId"];
            [param setObject:[tempDic objectForKey:@"usn"] forKey:@"usn"];
            if ([label1.text isEqualToString:@"私密"]) {
                [param setObject:@"1" forKey:@"visible"];
            }else if ([label1.text isEqualToString:@"朋友"]){
                [param setObject:@"2" forKey:@"visible"];
            }else{
                [param setObject:@"0" forKey:@"visible"];
            }
            [param setObject:self.templateId forKey:@"templateId"];
            [param setObject:_storyName forKey:@"title"];
            [param setObject:_storyDisc forKey:@"description"];
            if (self.model != nil) {
                    
                if (self.reciveArr.count > 0) {
                    NSArray *a = self.reciveArr;
                        
                    NSMutableArray *arr = [NSMutableArray array];
                    NSString *userid ;
                    for(NSDictionary *ddd in a){
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        userid = [ddd objectForKey:@"userId"];
                        [dic setObject:self.model.sid forKey:@"storyId"];
                        [dic setObject:userid forKey:@"userId"];
                        [arr addObject:dic];
                    }
                    NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/storyUser/updateByStory/%@",self.model.sid];
                    NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
                    [DataService requestWithURL:url params:arr requestHeader:headerDic httpMethod:@"POST" block2:^(NSObject *result) {

                    } failLoad:^(id result) {
                            
                    }];
                }
                    [param setObject:self.model.originalTime forKey:@"time"];
                    [param setObject:self.model.sid forKey:@"id"];
                    [DataService requestWithURL:@"/WeiXiao/api/v1/story/edit" params:param requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
                        [self hideHud];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
                            
                        });
                    } failLoad:^(id result) {
                        
                    }];
                    
                }else{
                    NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
                    [DataService requestWithURL:@"/WeiXiao/api/v1/story/add" params:param requestHeader:headerDic httpMethod:@"POST" block:^(NSObject *result) {
                        NSDictionary *dic = (NSDictionary *)result;
                        NSString *s = [dic objectForKey:@"id"];
                        if (s!=nil) {
                            self.model.sid = s;
                            if (self.reciveArr.count > 0) {
                                NSArray *a = self.reciveArr;
                                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                NSMutableArray *arr = [NSMutableArray array];
                                NSString *userid ;
                                for(NSDictionary *ddd in a)
                                {
                                    userid = [ddd objectForKey:@"userId"];
                                    [dic setObject:s forKey:@"storyId"];
                                    [dic setObject:userid forKey:@"userId"];
                                    [arr addObject:dic];
                                }
                                NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/storyUser/updateByStory/%@",s];
                                NSDictionary *headerDic = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
                                [DataService requestWithURL:url params:arr requestHeader:headerDic httpMethod:@"POST" block2:^(NSObject *result) {
                                } failLoad:^(id result) {
                                    
                                }];
                            }
                            [self postCover:dic];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                CreateViewController *createVC = [[CreateViewController alloc] init];
                                createVC.storyDic = (NSDictionary *)result;
                                createVC.storyName = _storyName;
                                createVC.isAdded = @"storyed";
                                createVC.isPopRoot = @"poptoroot";
                                [self.navigationController pushViewController:createVC animated:YES];
                            });
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self hideHud];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建失败,请稍后再试！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                [alert show];
                            });
                        }
                        
                    } failLoad:^(id result) {
                        
                    }];
                    
                }
        }
    }
}

-(void)postCover:(NSDictionary *)dic{
    
    if ([selectedCover isEqualToString:@"yes"]) {
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        NSString *sid = [dic objectForKey:@"id"];
        NSString *postCoverUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/upload/story/%@/cover",sid];
        NSString *sanbox = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [sanbox stringByAppendingPathComponent:@"storyCover.jpg"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
        [params setObject:filePath forKey:@"pic"];
        [DataService rrequestWithURL:postCoverUrl params:params httpMethod:@"POST" block1:^(id result) {
            NSDictionary *resultDic= (NSDictionary *)result;
            if ([[resultDic objectForKey:@"result"] isEqual:@0]) {
                [self hideHud];
                
                NSString *storyCoverUrl = [resultDic objectForKey:@"value"];
                NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [newDic setObject:storyCoverUrl forKey:@"image"];
                [self editStoryRequest:newDic];
            }else{
                [self hideHud];
                
            }
        } failLoad:^(id result) {
            [self hideHud];
            
        }];
    }
    
}

-(void)editStoryRequest:(NSMutableDictionary *)dic{
    [DataService requestWithURL:@"/WeiXiao/api/v1/story/edit" params:dic requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
        self.model.sid = [dic objectForKey:@"id"];
        if (self.reciveArr.count > 0) {
      
            NSArray *a = self.reciveArr;
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            NSMutableArray *arr = [NSMutableArray array];
            NSString *userid ;
            NSString *userUsn;
            for(NSDictionary *ddd in a)
            {
                userid = [ddd objectForKey:@"userId"];
                userUsn = [ddd objectForKey:@"usn"];
                [dic1 setObject:[dic objectForKey:@"id"] forKey:@"storyId"];
                [dic1 setObject:@"0" forKey:@"source"];
                [dic1 setObject:userUsn forKey:@"usn"];
                [dic1 setObject:userid forKey:@"userId"];
                [arr addObject:dic1];
            }
            NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/storyUser/updateByStory/%@",[dic objectForKey:@"id"]];
            [DataService requestWithURL:url params:arr requestHeader:nil httpMethod:@"POST" block2:^(NSObject *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CreateViewController *createVC = [[CreateViewController alloc] init];
                    createVC.storyDic = (NSDictionary *)dic;
                    createVC.storyName = _storyName;
                    createVC.isAdded = @"storyed";
                    createVC.isPopRoot = @"poptoroot";
                    [self.navigationController pushViewController:createVC animated:YES];
                });
            } failLoad:^(id result) {
                
            }];
            //                    NSURL *url = [NSURL URLWithString:str];
            //                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            //                    [request setHTTPMethod:@"POST"];
            //                    [request setHTTPBody:data];
            //                     NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            //                    NSLog(@"%@",received);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                CreateViewController *createVC = [[CreateViewController alloc] init];
                createVC.storyDic = (NSDictionary *)dic;
                createVC.storyName = _storyName;
                createVC.isAdded = @"storyed";
                createVC.isPopRoot = @"poptoroot";
                [self.navigationController pushViewController:createVC animated:YES];
            });
        }
    } failLoad:^(id result) {
        
    }];
}

#pragma mark - UITextViewDelegate and UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {//检测到“完成”
        [textField resignFirstResponder];//释放键盘
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 21) { //如果输入框内容大于7则弹出警告
        textField.text = [toBeString substringToIndex:21];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    if (textField.text != nil && textField.text.length > 0) {
//        NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        if (![pred evaluateWithObject:textField.text]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"故事标题只能有汉字、英文字母或数字组成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//            [alert show];
//            textField.text = nil;
//        }else{
//            _storyName = textField.text;
//            [textField resignFirstResponder];
//            return YES;
//            }
//    }else{
//        textField.text = nil;
//        _storyName = nil;
//    }
//    return YES;
//}

-(void)textViewDidChange:(UITextView *)textView
{
    self.labelText.hidden = YES;
    _storyDisc = textView.text;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    
    if (self.tv.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.labelText.hidden=NO;
        }else{
            self.labelText.hidden=YES;
        }
    }else{//textview长度不为0
        if (self.tv.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.labelText.hidden=NO;
            }else{//不是删除
                self.labelText.hidden=YES;
            }
        }else{//长度不为1时候
            self.labelText.hidden=YES;
        }
    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    if ([toBeString length] > 140) { //如果输入框内容大于140则弹出警告
        textView.text = [toBeString substringToIndex:140];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text != nil && textView.text.length > 0) {
        _storyDisc = textView.text;
    }
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *theImage = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        
        //判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
            //            theImage = [info objectForKey:UIImagePickerControllerCropRect];
            
        } else {
            //照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        }
    }
        [self saveImage:theImage WithName:@"storyCover.jpg"];
    
    //    if (theImage != nil) {
    //        //UIImage  ---> NSData
    //        NSData *userAvaData = UIImageJPEGRepresentation(theImage, 0.3);
    //        if (userAvaData.length > 1024*1024) {
    //            //如果图片大于1M，则压缩
    //            userAvaData = UIImageJPEGRepresentation(theImage, 0.1);
    //        }
    //    }
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //
    //    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    //    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    //    [params setObject:filePath forKey:@"pic"];
    //
    //    NSString *str = [NSString stringWithFormat:@"/WeiXiaoAva/api/v1/upload/user/ava/%@",[tempDic objectForKey:@"usn"]];
    selectedCover = @"yes";
    [selectCover setImage:theImage forState:UIControlStateNormal];
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.75);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
//        self.tf = nil;
//        self.tv = nil;
//        self.labelText = nil;
//        self.view = nil;
    }
}

@end
