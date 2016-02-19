//
//  FLbianjiViewController.m
//  GerenshezhiCenter
//
//  Created by tutu on 14-12-9.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  个人信息修改

#import "FLbianjiViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "DataService.h"
#import "PSConfigs.h"
#import <AVFoundation/AVFoundation.h>
#import "ImagePickerViewController.h"
#import "ZHPickView.h"
#define ORIGINAL_MAX_WIDTH 640.0f
#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface FLbianjiViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UIActionSheetDelegate,ImagePickerViewControllerDelegateDefine,ZHPickViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIImageView *portraitImageView;
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)UIPickerView *sexPickView;
@property(nonatomic,strong)UIView *pview;
@property(nonatomic,strong)NSArray *sexArr;
@property(nonatomic,copy)NSString *sexChange;
@end

@implementation FLbianjiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sexArr = @[@"男",@"女"];
    
    self.title = @"编辑信息";
    [self bianjiCeng];
    self.view.backgroundColor = rgb(240, 240, 240, 1);
    
    UIButton *buttQueding  = [UIButton buttonWithType:UIButtonTypeCustom];
    buttQueding.frame = CGRectMake(0, 0, 60, 44);
    buttQueding.backgroundColor = [UIColor clearColor];
    [buttQueding setTitle:@"确定" forState:UIControlStateNormal];
    [buttQueding setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttQueding.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [buttQueding addTarget:self action:@selector(donoAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttQueding];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 48, 20);
    //        leftBtn.backgroundColor = [UIColor orangeColor];
    leftBtn.showsTouchWhenHighlighted = YES;
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)backAction{
    [_pickview removeFromSuperview];

    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(void)donoAction:(UIButton *)tt{
//     NSURL *urlString = [NSURL URLWithString:@"http://192.168.1.200:8888/group1/M00/00/00/wKgByFSKncmAKFqGAAET4lte1f833.file"];
    [self altShibai];
}
-(void)altShibai{

    UIAlertView *at = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定修改吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    at.tag = 800;
    [at show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
            
    }else if(buttonIndex == 1){
  NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];

            if (strr.length>0) {
                [tempDic setObject:strr forKey:@"image"];
            }
            [tempDic setObject:JieshouName.text forKey:@"nickname"];
            [tempDic setObject:@0 forKey:@"status"];
            [tempDic setObject:areaDetail.text forKey:@"address"];
            if ([sexDetail.text isEqualToString:@"男"]) {
                [tempDic setObject:@1 forKey:@"sex"];
            }
            else
            {
                [tempDic setObject:@0 forKey:@"sex"];
            }
            [self showHud:@"正在上传..."];
            NSDictionary *dicc = [NSDictionary dictionaryWithObjects:@[JieshouName.text,self.ig] forKeys:@[@"name",@"image"]];
            [self sendNameAndImage:dicc];
            [DataService requestWithURL:@"/WeiXiao/api/v1/user/edit" params:tempDic requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
                NSDictionary *userResult = (NSDictionary *)result;
                if ([[userResult objectForKey:@"result"] isEqual:@0]) {
                    [self completeHud:@"修改成功"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                    [defaults setBool:YES forKey:@"changeUserInfo"];
                    [defaults setObject:JieshouName.text forKey:@"userName"];
                    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                    NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
                    [tempDic setObject:JieshouName.text forKey:@"nickname"];
                    [tempDic setObject:areaDetail.text forKey:@"address"];
                    if ([sexDetail.text isEqualToString:@"男"]) {
                        [tempDic setObject:@1 forKey:@"sex"];
                    }
                    else
                    {
                        [tempDic setObject:@0 forKey:@"sex"];
                    }

                    tempUserData = [tempDic JSONData];
                    [[NSUserDefaults standardUserDefaults] setObject:tempUserData forKey:kMyUserInfo];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[PSConfigs shareConfigs] loadUserInfo];
                
                }
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self dismissViewControllerAnimated:YES completion:^{
                    
                    }];
                });
        } failLoad:^(id result) {
            
        }];

}
    
}

-(void)sendNameAndImage:(NSDictionary *)dic{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NameAndImage" object:dic];
}

-(void)altTishi{
    UIAlertView *at = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜您修改成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [at show];
}
//编辑界面处理
-(void)bianjiCeng{
 
//    BianjiView = [[UIView alloc]init];
//    BianjiView.backgroundColor = rgb(255, 255, 255, 1);
//    BianjiView.frame  =CGRectMake(0, 20, KScreenWidth, 140);
//    [self.view addSubview:BianjiView];
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    //第一行处理 头像大按钮
    TouxiangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    TouxiangButton.backgroundColor = [UIColor whiteColor];
    TouxiangButton.frame = CGRectMake(0, 30, KScreenWidth, 90);
   // TouxiangButton.backgroundColor = [UIColor whiteColor];
    [TouxiangButton addTarget:self action:@selector(touxiangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:TouxiangButton];
    //加入箭头处理
    jianTou = [[UIImageView alloc]init];
    jianTou.frame = CGRectMake(KScreenWidth-30, 35, 20, 20);
    jianTou.image = [UIImage imageNamed:@"c1.png"];
    [TouxiangButton addSubview:jianTou];
    
    //头像按钮加入label
    TouxianLable = [[UILabel alloc]init];
    
    
    TouxianLable.frame = CGRectMake(20, 22, 50, 50);
    TouxianLable.text = @"头像";
    TouxianLable.font = [UIFont systemFontOfSize:20];
    [TouxiangButton addSubview:TouxianLable];
    
    //头像按钮加入图片按钮
    imageBtton  = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtton.frame = CGRectMake(KScreenWidth-120, 10, 70, 70);
    imageBtton.backgroundColor = [UIColor clearColor];
    imageBtton.layer.cornerRadius = 35;
    [imageBtton.layer setBorderWidth:0.5];
    [imageBtton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    imageBtton.layer.masksToBounds = YES;
    if (self.userAva != nil&&[self.userAva rangeOfString:@"http:"].location != NSNotFound) {
        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
//        [imageBtton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.userAva]];
        NSString *sss = [tempDic objectForKey:@"image"];
        [imageBtton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:sss]];

    }else{
        [imageBtton setImage:[UIImage imageNamed:self.userAva] forState:UIControlStateNormal];
    }
    [imageBtton addTarget:self action:@selector(tupianAction:) forControlEvents:UIControlEventTouchUpInside];
    [TouxiangButton addSubview:imageBtton];
 
//    [self addLineWithWidth:0 withHeight:0 toView:BianjiView];
//    
//    [self addLineWithWidth:0 withHeight:90 toView:BianjiView];
   //第二行处理  名字按钮处理
    MingZiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    MingZiButton.frame = CGRectMake(0,TouxiangButton.bottom+15, KScreenWidth, 50);
       MingZiButton.backgroundColor = [UIColor whiteColor];
    [MingZiButton addTarget:self action:@selector(mingziAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:MingZiButton];
//    jianTou1 = [[UIImageView alloc]init];
//    jianTou1.frame = CGRectMake(KScreenWidth-30, 15, 20, 20);
//    jianTou1.image = [UIImage imageNamed:@"c1.png"];
    UIImageView *mingziJiantou = [self jiantou1];
    [MingZiButton addSubview:mingziJiantou];
    
    //名字按钮上加入Label
    MingziLable = [[UILabel alloc]init];
    MingziLable.frame = CGRectMake(15, 0, 50, 50);
    MingziLable.text = @"名字";
    MingziLable.font = [UIFont systemFontOfSize:20];
    [MingZiButton addSubview:MingziLable];
  //  [self addLineWithWidth:0 withHeight:140 toView:BianjiView];
    
    JieshouName  = [[UILabel alloc]init];
    JieshouName.frame = CGRectMake(KScreenWidth-180, 5, 130, 40);
    JieshouName.textAlignment = NSTextAlignmentRight;
    JieshouName.backgroundColor = [UIColor whiteColor];
    [JieshouName setTextColor:rgb(137, 137, 137, 1)];
//    JieshouName.text = fl.str;
    if (self.userName) {
        JieshouName.text = _userName;
    }
    [MingZiButton addSubview:JieshouName];
    
    //第三行性别处理
    UIButton *sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sexButton.frame = CGRectMake(0,MingZiButton.bottom+0.8,KScreenWidth, 50);
    sexButton.backgroundColor = [UIColor whiteColor];
    [sexButton addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sexButton];
    
    UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 50, 50)];
    sexLabel.text = @"性别";
    sexLabel.font = [UIFont systemFontOfSize:20];
    [sexButton addSubview:sexLabel];
    UIImageView *sexJiantou = [self jiantou1];
    [sexButton addSubview:sexJiantou];
    
   sexDetail = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-80, 5, 20, 40)];
    sexDetail.textAlignment = NSTextAlignmentRight;
    sexDetail.backgroundColor = [UIColor whiteColor];
    [sexDetail setTextColor:rgb(137, 137, 137, 1)];
    NSNumber *sexNumber = [tempDic objectForKey:@"sex"];
    if ([sexNumber isEqual:@1]) {
        sexDetail.text = @"男";
    }
    else
    {
    sexDetail.text = @"女";
    }
    [sexButton addSubview:sexDetail];
    
    //第四行地区
    UIButton *areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    areaButton.frame = CGRectMake(0,sexButton.bottom+0.8,KScreenWidth, 50);
    areaButton.backgroundColor = [UIColor whiteColor];
    [areaButton addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaButton];
    
    UILabel *areaLabel= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 50, 50)];
    areaLabel.text = @"地区";
    areaLabel.font = [UIFont systemFontOfSize:20];
    [areaButton addSubview:areaLabel];
    UIImageView *areaJiantou = [self jiantou1];
    [areaButton addSubview:areaJiantou];
    
    areaDetail = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-180, 5, 130, 40)];
    areaDetail.textAlignment = NSTextAlignmentRight;
    areaDetail.backgroundColor = [UIColor whiteColor];
    [areaDetail setTextColor:rgb(137, 137, 137, 1)];
    NSString *area = [tempDic objectForKey:@"address"];
    areaDetail.text = area;
    [areaButton addSubview:areaDetail];
    
    //第五行手机号码
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(0,areaButton.bottom+15,KScreenWidth, 50);
    phoneButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneButton];
    
    UILabel *phoneLabel= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 50)];
    phoneLabel.text = @"手机号码";
    phoneLabel.font = [UIFont systemFontOfSize:20];
    [phoneButton addSubview:phoneLabel];
    UILabel *phoneDetail = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-150, 5, 130, 40)];
    phoneDetail.textAlignment = NSTextAlignmentRight;
    phoneDetail.backgroundColor = [UIColor whiteColor];
    [phoneDetail setTextColor:rgb(137, 137, 137, 1)];
    NSString *phone = [tempDic objectForKey:@"usn"];
    phoneDetail.text = phone;
    [phoneButton addSubview:phoneDetail];
}
    
-(UIImageView*)jiantou1
{

    jianTou1 = [[UIImageView alloc]init];
    jianTou1.frame = CGRectMake(KScreenWidth-30, 15, 20, 20);
    jianTou1.image = [UIImage imageNamed:@"c1.png"];
    return jianTou1;
}
 //线条处理
//-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
//    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, KScreenWidth, 0.5)];
//    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
//    [parentView addSubview:lineIV];
//    [parentView bringSubviewToFront:lineIV];
//}

 //添加按钮处理
-(void)touxiangAction:(UIButton *)bt{
    [self editPortrait];
}
//性别处理
-(void)sexClick:(UIButton*)bSex
{
    [_pickview removeFromSuperview];
    self.pview = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-306, KScreenWidth, 306)];
    self.pview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pview];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,40)];
    view.backgroundColor = rgb(248, 248, 248, 1);
    [self.pview addSubview:view];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0,50, 40)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:CommonBlue
                     forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-70, 0,50, 40)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:CommonBlue
                     forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightButton];

    self.sexPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,40, self.sexPickView.frame.size.width, 170)];
    self.sexPickView.delegate = self;
    self.sexPickView.dataSource = self;
    [self.pview addSubview:self.sexPickView];
}
-(void)cancel
{
    [self.pview removeFromSuperview];
}
-(void)click
{
    if(self.sexChange.length>0)
    {
    sexDetail.text = self.sexChange;
    }
    else
    {
    sexDetail.text = @"男";
    }
    self.sexChange = nil;
    [self.pview removeFromSuperview];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   // self.sexChange = @"男";
    self.sexChange = self.sexArr[row];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.sexArr[row];

}

-(void)areaClick:(UIButton*)bArea;
{
    [self.pview removeFromSuperview];
    _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:YES];
    _pickview.delegate= self;
    [self.view addSubview:_pickview];
}
#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    areaDetail.text = resultString;
}
 //圆形图片添加图片处理
-(void)tupianAction:(UIButton *)bttt{

     [self editPortrait];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    if (fl.str > 0) {
        JieshouName.text = fl.str;
    }else{
    
       JieshouName.text  = _userName;
    }
}

//名字按钮处理事件
-(void)mingziAction:(UIButton *)bttt{
    fl = [[FLQiMingZiViewController alloc]init];
    fl.name = self.userName;
    [self.navigationController pushViewController:fl animated:YES];
}

//图片功能处理
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:@"拍照", @"从相册中选取", nil];
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
//            controller = [[UIImagePickerController alloc] init];
//            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
//            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
//            controller.mediaTypes = mediaTypes;
//            controller.delegate = self;
//            controller.allowsEditing = YES;
//            [self presentViewController:controller
//                               animated:YES
//                             completion:^(void){
//                                 NSLog(@"Picker View Controller is presented");
//                             }];
            ImagePickerViewController *picker = [[ImagePickerViewController alloc]init];
            picker.isAva = @"ava";
            picker.delegateDefine = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            UIAlertView *cameraUnable = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [cameraUnable show];
        }
        
    } else if (buttonIndex == 1) {
        //从相册中选取
        if ([self isPhotoLibraryAvailable]) {
//            controller = [[UIImagePickerController alloc] init];
//            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
//            controller.mediaTypes = mediaTypes;
//            controller.delegate = self;
//            controller.allowsEditing = YES;
//            [self presentViewController:controller
//                               animated:YES
//                             completion:^(void){
//                                 NSLog(@"Picker View Controller is presented");
//                             }];
            ImagePickerViewController *picker = [[ImagePickerViewController alloc]init];
            picker.isAva = @"ava";
            picker.delegateDefine = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            UIAlertView *photoUnable = [[UIAlertView alloc] initWithTitle:@"无法打开相册" message:@"请为乐忆开放照片权限:设置-隐私-照片-乐忆时光-打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [photoUnable show];
        }
    }
}

-(void)imagePickerDidChooseImage:(ImagePickerViewController *)imagePickerViewController withImage:(UIImage *)image1{
    [self saveImage:image1 WithName:@"userAva.jpg"];
    
    NSString *sanbox = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [sanbox stringByAppendingPathComponent:@"userAva.jpg"];
    self.ig = image1;
    if (image != nil) {
        //UIImage  ---> NSData
        userAvaData = UIImageJPEGRepresentation(image1, 0.3);
        if (userAvaData.length > 1024*1024) {
            //如果图片大于1M，则压缩
            userAvaData = UIImageJPEGRepresentation(image1, 0.1);
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    [params setObject:filePath forKey:@"pic"];
    NSString *str = [NSString stringWithFormat:@"/WeiXiaoAva/api/v1/upload/user/ava/%@",[tempDic objectForKey:@"usn"]];
    
    [DataService rrequestWithURL:str params:params httpMethod:@"POST" block1:^(id result) {
        NSDictionary *imageInfo = (NSDictionary *)result;
        if ([[result objectForKey:@"result"] isEqual:@0]) {
            NSString *tu = [imageInfo objectForKey:@"value"];
            strr = tu;
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            [tempDic setObject:tu forKey:kImage];
            tempUserData = [tempDic JSONData];
            [[NSUserDefaults standardUserDefaults] setObject:tempUserData forKey:kMyUserInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[PSConfigs shareConfigs] loadUserInfo];
        }else{
            
        }
    } failLoad:^(id result) {
        
    }];
    [imageBtton setImage:image1 forState:UIControlStateNormal];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [controller dismissViewControllerAnimated:YES completion:NULL];
    controller = nil;
    UIImage *theImage = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        
        //判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
            
        } else {
            //照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        }
    }
    [self saveImage:theImage WithName:@"userAva.jpg"];
    
    NSString *sanbox = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [sanbox stringByAppendingPathComponent:@"userAva.jpg"];
    self.ig = theImage;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    if (theImage != nil) {
        //UIImage  ---> NSData
        userAvaData = UIImageJPEGRepresentation(theImage, 0.3);
        if (userAvaData.length > 1024*1024) {
            //如果图片大于1M，则压缩
            userAvaData = UIImageJPEGRepresentation(theImage, 0.1);
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

        NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
        [params setObject:filePath forKey:@"pic"];
    
        NSString *str = [NSString stringWithFormat:@"/WeiXiaoAva/api/v1/upload/user/ava/%@",[tempDic objectForKey:@"usn"]];

    [DataService rrequestWithURL:str params:params httpMethod:@"POST" block1:^(id result) {
        NSDictionary *imageInfo = (NSDictionary *)result;
        if ([[result objectForKey:@"result"] isEqual:@0]) {
            NSString *tu = [imageInfo objectForKey:@"value"];
            strr = tu;
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            [tempDic setObject:tu forKey:kImage];
            tempUserData = [tempDic JSONData];
            [[NSUserDefaults standardUserDefaults] setObject:tempUserData forKey:kMyUserInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[PSConfigs shareConfigs] loadUserInfo];
        }else{
            
        }
    } failLoad:^(id result) {
        
    }];
    [imageBtton setImage:theImage forState:UIControlStateNormal];
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        BianjiView = nil;
        TouxiangButton = nil;
        TouxianLable = nil;
        MingZiButton = nil;
        MingziLable = nil;
        image = nil;
        imageBtton = nil;
        jianTou = nil;
        jianTou1 = nil;
        JieshouName = nil;
        self.view = nil;
    }
}

@end
