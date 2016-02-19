//
//  WanShanSingerInfermaionViewController.m
//  PictureSaying
//
//  Created by fulei on 15/1/26.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "WanShanSingerInfermaionViewController.h"
#import "WanShanDetalViewController.h"
#import "DataService.h"
#import "PSConfigs.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
@interface WanShanSingerInfermaionViewController (){

 MBProgressHUD *_hud;
}

@end

@implementation WanShanSingerInfermaionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善个人信息";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self InferMation];
    // Do any additional setup after loading the view.
}
-(void)InferMation{
    
    TouxiangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    TouxiangButton.frame = CGRectMake((KScreenWidth-60)/2, 15, 60, 60);
    TouxiangButton.layer.cornerRadius = 30;
    TouxiangButton.clipsToBounds = YES;
    TouxiangButton.backgroundColor = [UIColor redColor];
    [TouxiangButton addTarget:self action:@selector(AddImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:TouxiangButton];
    
    shangChuanLable = [[UILabel alloc]init];
    shangChuanLable.frame = CGRectMake((KScreenWidth-100)/2, TouxiangButton.bottom+10, 100, 40);
    shangChuanLable.textAlignment = 1;
    shangChuanLable.text = @"上传头像";
    [self.view addSubview:shangChuanLable];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, shangChuanLable.bottom+10, KScreenWidth, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg];
    
    NichenLable = [[UILabel alloc]init];
    NichenLable.frame = CGRectMake(15, 0, 50, 40);
    NichenLable.text = @"昵称";
    [bg addSubview:NichenLable];
    
    
    text = [[UITextField alloc]init];
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
    text.frame = CGRectMake(NichenLable.right, 0, KScreenWidth - NichenLable.right, 40);
    text.backgroundColor = [UIColor whiteColor];
    text.placeholder = @"请输入昵称比如张三";
    [bg addSubview:text];
    
    QuedingAction = [UIButton buttonWithType:UIButtonTypeCustom];
    QuedingAction.frame = CGRectMake(10, bg.bottom+10, KScreenWidth -20, 50);
    [QuedingAction setTitle:@"下一步" forState:UIControlStateNormal];
     QuedingAction.backgroundColor = CommonBlue;
    QuedingAction.layer.cornerRadius = 3;
    [QuedingAction addTarget:self action:@selector(PushNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: QuedingAction];

   
}
-(void)AddImageAction:(UIButton *)bb{
    [self editPortrait];
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
-(void)PushNextAction:(UIButton *)bbt{
    
     WanShanDetalViewController *wansanDital = [[WanShanDetalViewController alloc]init];
     wansanDital.textNsstr = text.text;
     [self.navigationController pushViewController:wansanDital animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [text resignFirstResponder];
}

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
            controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            controller.allowsEditing = YES;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                    
                             }];
        }else{
            UIAlertView *cameraUnable = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [cameraUnable show];
        }
        
    } else if (buttonIndex == 1) {
        //从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            controller.allowsEditing = YES;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                
                             }];
        }else{
            UIAlertView *photoUnable = [[UIAlertView alloc] initWithTitle:@"无法打开相册" message:@"请为乐忆开放照片权限:设置-隐私-照片-乐忆时光-打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [photoUnable show];
        }
    }
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
    [TouxiangButton setImage:theImage forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
