//
//  CameraViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/30.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  相机

#import "CameraViewController.h"
#import "SCSlider.h"
#import "SCCommon.h"
#import "SVProgressHUD.h"
#import "DataService.h"
#import "MyLibraryDetailVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BaseNaviagtionViewController.h"

#define SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE      0   //对焦框是否一直闪到对焦完成

#define SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA   1   //没有拍照功能的设备，是否给一张默认图片体验一下

//height
#define CAMERA_TOPVIEW_HEIGHT   44  //title
#define CAMERA_MENU_VIEW_HEIGH  44  //menu

//color
#define bottomContainerView_UP_COLOR     [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.f]       //bottomContainerView的上半部分
#define bottomContainerView_DOWN_COLOR   [UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1.f]       //bottomContainerView的下半部分
#define DARK_GREEN_COLOR        [UIColor colorWithRed:10/255.0f green:107/255.0f blue:42/255.0f alpha:1.f]    //深绿色
#define LIGHT_GREEN_COLOR       [UIColor colorWithRed:143/255.0f green:191/255.0f blue:62/255.0f alpha:1.f]    //浅绿色

//对焦
#define ADJUSTINT_FOCUS @"adjustingFocus"
#define LOW_ALPHA   0.7f
#define HIGH_ALPHA  1.0f

typedef enum {
    bottomContainerViewTypeCamera    =   0,  //拍照页面
    bottomContainerViewTypeAudio     =   1   //录音页面
} BottomContainerViewType;

@interface  CameraViewController()<UIScrollViewDelegate,UIAlertViewDelegate>
{
    int alphaTimes;
    CGPoint currTouchPoint;
    int  Albumcount;
}

@property (nonatomic, strong) SCCaptureSessionManager *captureManager;

//@property (nonatomic, strong) UIView *topContainerView;//顶部view

@property(nonatomic,strong)UIView *v1;
@property(nonatomic,strong)UIImageView *v2;
@property(nonatomic,strong)UIImageView *imageView;
@property (nonatomic, strong) UIView *bottomContainerView;//除了顶部标题、拍照区域剩下的所有区域
@property (nonatomic, strong) UIView *cameraMenuView;//网格、闪光灯、前后摄像头等按钮
@property (nonatomic, strong) NSMutableSet *cameraBtnSet;
@property(nonatomic,strong)NSMutableArray *phoneArray;
@property(nonatomic,strong)NSMutableDictionary *phoneDictionary;
@property(nonatomic,strong)NSMutableArray *finallyArray;
@property(nonatomic,strong)NSMutableArray *Albumid;
@property (nonatomic, strong) UIView *doneCameraUpView;
@property (nonatomic, strong) UIView *doneCameraDownView;
@property(nonatomic)int count;
//对焦
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) SCSlider *scSlider;
//缩略图
@property(nonatomic,strong)UIImageView *imageView1;

//小黄点
@property(nonatomic,strong)UIImageView *v;
@property(nonatomic)BOOL status;
@end

@implementation CameraViewController
@synthesize nextButton, reloadButton;
@synthesize infoLabel;
#pragma mark -------------life cycle---------------
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom initialization
    alphaTimes = -1;
    currTouchPoint = CGPointZero;
    _cameraBtnSet = [[NSMutableSet alloc] init];
    indexCount = 0;
    
    titleArray = [NSMutableArray array];
    
    albumName = [NSMutableArray array];
    if (netStatus != 0) {
        [self showHud:@"正在配置相机,请稍后..."];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //get请求相册列表
        [self getList];
    });
    self.phoneDictionary = [NSMutableDictionary dictionary];
    self.Albumid = [NSMutableArray array];
    self.count = 0;
    //navigation bar
    _status = NO;
    
    //status bar
    if (!self.navigationController) {
        _isStatusBarHiddenBeforeShowCamera = [UIApplication sharedApplication].statusBarHidden;
        if ([UIApplication sharedApplication].statusBarHidden == NO) {
            //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }
    }
    
    //notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationOrientationChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:kNotificationOrientationChange object:nil];
    
    //session manager
    manager = [[SCCaptureSessionManager alloc] init];
    
    //AvcaptureManager
    if (CGRectEqualToRect(_previewRect, CGRectZero)) {
        self.previewRect = CGRectMake(0, 0, SC_APP_SIZE.width, SC_APP_SIZE.height);
    }
    [manager configureWithParentLayer:self.view previewRect:_previewRect];
//    self.captureManager = manager;
    
    [self addFocusView];
    
    [self addPinchGesture];
    
    [manager.session startRunning];
    
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"设备不支持拍照功能T_T"];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.image = [UIImage imageNamed:@"test.jpg"];
        [self.view addSubview:self.imageView];
    }
#endif
    //上阴影视图
    self.v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.v1.backgroundColor = [UIColor blackColor];
    self.v1.alpha = 1;
    [self.view addSubview:self.v1];
    //下阴影视图
    self.v2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.82, self.view.frame.size.width, self.view.frame.size.height*0.18)];
    self.v2.autoresizesSubviews = NO;
    self.v2.backgroundColor = [UIColor blackColor];
    self.v2.userInteractionEnabled = YES;
    [self.view addSubview:self.v2];
    
    //缩略图
    NSString *sanbox = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [sanbox stringByAppendingPathComponent:@"tempImage.jpg"];
    self.imageView1= [[UIImageView alloc] initWithFrame:CGRectMake(self.v2.frame.size.width*0.75,self.v2.frame.size.height*0.4, self.v2.frame.size.height*0.5, self.v2.frame.size.height*0.5)];
    self.imageView1.image = [[UIImage alloc]initWithContentsOfFile:filePath];
    self.imageView1.layer.cornerRadius = 4;
    self.imageView1.layer.masksToBounds = YES;
    [self.v2 addSubview:self.imageView1];
    
    //小黄点
    self.v = [[UIImageView alloc]initWithFrame:CGRectMake(self.v2.frame.size.width*0.48,5,self.v2.frame.size.height*0.06 , self.v2.frame.size.height*0.06)];
    self.v.image = [UIImage imageNamed:@"小黄点"];
    self.v.layer.cornerRadius = self.v2.frame.size.height*0.03;
    self.v.layer.masksToBounds = YES;
    [self.v2 addSubview:self.v];
    self.view.backgroundColor = [UIColor blackColor];
    //pickerView滑动视图
    pickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 20)];
    pickerView.backgroundColor   = [UIColor clearColor];
    pickerView.selectedTextColor = [UIColor orangeColor];
   // pickerView.elementFont =  [UIFont systemFontOfSize:1];
    pickerView.textColor   = [UIColor whiteColor];
    pickerView.delegate    = self;
    pickerView.dataSource  = self;
    pickerView.elementFont = [UIFont boldSystemFontOfSize:14.0f];
    pickerView.selectionPoint = CGPointMake(KScreenWidth/2, 0);
    [self.v2 addSubview:pickerView];
    
    //拍照按钮
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat cameraBtnLength = self.view.frame.size.height*0.10;
    b.frame = CGRectMake((SC_APP_SIZE.width - cameraBtnLength) / 2, self.v2.frame.size.height*0.33, cameraBtnLength, cameraBtnLength);
    [b setImage:[UIImage imageNamed:@"shot"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(takePictureBtnPressed:) forControlEvents:UIControlEventTouchUpInside ];
    [self.v2 addSubview:b];
    
    //返回.反转按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0,self.v1.frame.size.width*0.2 , 40);
    [backBtn setImage:[UIImage imageNamed:@"close_cha"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.v1 addSubview:backBtn];
    
    UIButton *fanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fanBtn.frame = CGRectMake(self.v1.frame.size.width*0.8, 0, self.v1.frame.size.width*0.2, 40);
    [fanBtn setImage:[UIImage imageNamed:@"switch_camera"] forState:UIControlStateNormal];
    [fanBtn addTarget:self action:@selector(switchCameraBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.v1 addSubview:fanBtn];
    
}

#pragma mark - UIPickerView
#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return [albumName count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
    return [albumName objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSString *text = [albumName objectAtIndex:index];
    CGSize textSize;
    if (![text isKindOfClass:[NSNull class]]) {
        textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:10.0f]
                           constrainedToSize:constrainedSize
                               lineBreakMode:UILineBreakModeWordWrap];
    }else{
        textSize = CGSizeMake(100, 20);
    }
    
    return textSize.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    int a = index;
    self.infoLabel.text = [NSString stringWithFormat:@"Selected index %d", a];
    Albumcount = a;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [pickerView scrollToElement:0 animated:NO];
}
-(void)getList
{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/?accountUsn=%@",[tempDic objectForKey:@"usn"]];
    [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
        [self hideHud];
        NSArray *a = (NSArray *)result;
        for (NSDictionary *d in a) {
            [titleArray addObject: [d objectForKey:@"id"]];
            [albumName addObject:[d objectForKey:@"title"]];
        }
        
        [pickerView reloadData];
        [pickerView scrollToElement:0 animated:NO];

    } failLoad:^(id result) {
        [self hideHud];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取相册信息失败!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [pickerView removeFromSuperview];
    pickerView = nil;
    [manager.session stopRunning];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        
    }
    
}

//对焦的框
- (void)addFocusView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x.png"]];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}



//伸缩镜头的手势
- (void)addPinchGesture {
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinch];
    //竖向
    CGFloat width = 40;
    CGFloat height = _previewRect.size.height - 100;
    SCSlider *slider = [[SCSlider alloc] initWithFrame:CGRectMake(_previewRect.size.width - width, (_previewRect.size.height + CAMERA_MENU_VIEW_HEIGH - height) / 2, width, height) direction:SCSliderDirectionVertical];
    slider.alpha = 0.f;
    slider.minValue = MIN_PINCH_SCALE_NUM;
    slider.maxValue = MAX_PINCH_SCALE_NUM;
    __weak SCCaptureSessionManager *mm = manager;
    __weak CameraViewController *viewC = self;

//    WEAKSELF_SC
    [slider buildDidChangeValueBlock:^(CGFloat value) {
        [mm pinchCameraViewWithScalNum:value];
    }];
    [slider buildTouchEndBlock:^(CGFloat value, BOOL isTouchEnd) {
        [viewC setSliderAlpha:isTouchEnd];
    }];
    
    [self.view addSubview:slider];
    
    self.scSlider = slider;
}


- (void)setSliderAlpha:(BOOL)isTouchEnd {
    if (_scSlider) {
        _scSlider.isSliding = !isTouchEnd;
        
        if (_scSlider.alpha != 0.f && !_scSlider.isSliding) {
            double delayInSeconds = 3.88;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (_scSlider.alpha != 0.f && !_scSlider.isSliding) {
                    [UIView animateWithDuration:0.3f animations:^{
                        _scSlider.alpha = 0.f;
                    }];
                }
            });
        }
    }
}


#pragma mark -------------touch to focus---------------
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        
        if (!isAdjustingFocus) {
            alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        int alphaNum = (alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        alphaTimes++;
        
    } completion:^(BOOL finished) {
        
        if (alphaTimes != -1) {
            [self showFocusInPoint:currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //    [super touchesBegan:touches withEvent:event];
    
    alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    currTouchPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(manager.previewLayer.bounds, currTouchPoint) == NO) {
        return;
    }
    
    [manager focusInPoint:currTouchPoint];
    
    //对焦框
    [_focusImageView setCenter:currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

//上传照片URL
-(void)post:(UIImage*)image
{
    NSData *imagedata = UIImageJPEGRepresentation(image, 1);
    if (imagedata.length > 1024*1024*2) {
        CGFloat a = (1024*1024*2)/imagedata.length;
        imagedata = UIImageJPEGRepresentation(image,a);
        image = nil;
    }
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:imagedata forKey:@"path1"];
    [parmas setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    [parmas setObject:@"Basino" forKey:@"txt1"];
    if (titleArray.count == 0) {
        NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/def/photof"];
        [DataService requestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
            [self completeHud:@"图片已上传至默认相册"];

        } failLoad:^(id result) {
            [self completeHud:@"网络不给力啊,亲"];
        }];
    }else{
        NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photof",titleArray[Albumcount]];
        [DataService requestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
            [self completeHud:@"图片已上传"];
        } failLoad:^(id result) {
            [self completeHud:@"网络不给力啊,亲"];
        }];
    }
}
-(void)post2:(NSMutableDictionary*)dic
{
    NSArray *a = [self.phoneDictionary allKeys];
    for (int i = 0; i<a.count; i++) {
        NSArray *phone = [self.phoneDictionary objectForKey:a[i]];
        for (int j = 0; j<phone.count; j++) {
            UIImage *image = phone[j];
            NSData *imagedata = UIImageJPEGRepresentation(image, 1);
            if (imagedata.length > 1024*1024*2) {
                CGFloat a = (1024*1024*2)/imagedata.length;
                imagedata = UIImageJPEGRepresentation(image,a);
                image = nil;
            }
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
            [parmas setObject:imagedata forKey:@"path1"];
            [parmas setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
            [parmas setObject:@"Basino" forKey:@"txt1"];
            if (titleArray.count == 0) {
                [self showHud:@"正在上传"];
                NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/def/photof"];
                [DataService requestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
                    
                    [self hideHud];
                    [self completeHud:@"图片已上传至默认相册"];
                    [self back];
                    
                } failLoad:^(id result) {
                    [self back];
                }];
            }else{
                [self showHud:@"正在上传"];
                NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photof",a[i]];
                [DataService requestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
                    
                 [self hideHud];
                 [self completeHud:@"图片已上传"];
                 [self back];
                   
                } failLoad:^(id result) {
                    [self completeHud:@"网络不给力啊,亲"];
                    [self back];
                }];
            }
        }
    }
   
}
-(void)post1:(NSString *)imagePath
{
    
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:imagePath forKey:@"path1"];
    [parmas setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    [parmas setObject:@"Basino" forKey:@"txt1"];
    if (titleArray.count == 0) {
        NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/def/photof"];
        [DataService rrequestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
            [self completeHud:@"图片已上传至默认相册"];
        } failLoad:^(id result) {
           [self completeHud:@"网络不给力啊,亲"];
        }];
    }else{
        NSString *str = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photof",titleArray[Albumcount]];

        [DataService rrequestWithURL:str params:parmas httpMethod:@"POST" block1:^(id result) {
            [self completeHud:@"图片已上传"];
        } failLoad:^(id result) {
            [self completeHud:@"网络不给力啊,亲"];
        }];
    }
}

#pragma mark -------------button actions---------------
//拍照页面，拍照按钮
- (void)takePictureBtnPressed:(UIButton*)sender {
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SVProgressHUD showErrorWithStatus:@"设备不支持拍照功能T_T"];
        return;
    }
#endif
    _status = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(netStatus != 0)
//        {
//         [self showHud:@"正在上传..."];
//        }
//    });
//    
    sender.userInteractionEnabled = NO;
    // WEAKSELF_SC
    __weak CameraViewController *viewC = self;
    self.count++;
    if (self.count<100) {
        [manager takePicture:^(UIImage *stillImage) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [SCCommon saveImageToPhotoAlbum:stillImage];//存至本机
                [viewC createAlbumInPhoneAlbum:stillImage];
           if (titleArray.count>0) {
            if(netStatus == 1)
            {
                
                if ([self.Albumid indexOfObject:titleArray[Albumcount]]== NSNotFound)
                    {
                        self.phoneArray = [NSMutableArray array];
                        [self.phoneArray addObject:stillImage];
                   [self.phoneDictionary setObject:self.phoneArray forKey:titleArray[Albumcount]];
         
                    
                }
                else
                {
                    NSMutableArray *arr = [viewC.phoneDictionary objectForKey:titleArray[Albumcount]];
                    [arr addObject:stillImage];
                }
               
                if ([self.Albumid indexOfObject:titleArray[Albumcount]]== NSNotFound)
                {
                [self.Albumid addObject:titleArray[Albumcount]];
    
                }
                else
                {
            
                }
          
                

            }
                }
                NSString *sanbox = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *filePath = [sanbox stringByAppendingPathComponent:@"tempImage.jpg"];
            
                if (netStatus == 2) {
                    [self post1:filePath];
                    
                }
                
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.userInteractionEnabled = YES;
                self.imageView1.image = stillImage;
            });
        }];
    }
    else
    {
       sender.userInteractionEnabled = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"亲!你拍摄过于频繁,退出相机休息会吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
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

#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage
{
    NSURL *url = [NSURL URLWithString:@"http"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"photo" forKey:@"type"];
    [request setFile:bigImage forKey:@"file_pic_big"];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
}

#pragma mark - 在手机相册中创建相册
- (void)createAlbumInPhoneAlbum:(UIImage *)image
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        
        else
        {
            BOOL haveHDRGroup = NO;
            
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                
                if ([name isEqualToString:@"乐忆"])
                {
                    haveHDRGroup = YES;
                }
            }
            
            if (!haveHDRGroup)
            {
                //do add a group named "XXXX"
                [assetsLibrary addAssetsGroupAlbumWithName:@"乐忆"
                                               resultBlock:^(ALAssetsGroup *group)
                 {
                     [groups addObject:group];
                     
                 }
                                              failureBlock:nil];
                haveHDRGroup = YES;
            }
        }
        
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    
    [self saveToAlbumWithMetadata:nil imageData:UIImageJPEGRepresentation(image, 0.75) customAlbumName:@"乐忆" completionBlock:^{
         //这里可以创建添加成功的方法
     }failureBlock:^(NSError *error)
     {
         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
         dispatch_async(dispatch_get_main_queue(), ^{
             
             //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
             if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                 
                 [alert show];
                 
             }
         });
     }];
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    __block ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(assetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrary, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)tmpBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//拍照页面，"X"按钮
- (void)dismissBtnPressed:(id)sender {
    //status bar
//    if (!self.navigationController) {
//        _isStatusBarHiddenBeforeShowCamera = [UIApplication sharedApplication].statusBarHidden;
//        if ([UIApplication sharedApplication].statusBarHidden == YES) {
//            //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//        }
//    }
    if (!_status || netStatus == 0 || (titleArray.count == 0 && netStatus != 1)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(netStatus == 2)
    {
//        [self post2:self.phoneDictionary];
        [self back];
        
    }
    
    else if (netStatus == 1)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接提醒" message:@"当前网络无Wi-Fi,继续上传可能会被运营商收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续上传", nil];
        [alert show];
       
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self post2:self.phoneDictionary];
       
    }
    else
        [self back];
}
-(void)back
{
    if (titleArray.count>0) {
        MyLibraryDetailVC *tttddd = [[MyLibraryDetailVC alloc]init];
        tttddd.Jieshou = titleArray[Albumcount];
        BaseNaviagtionViewController *caremaNav = [[BaseNaviagtionViewController alloc] initWithRootViewController:tttddd];
        
        [self presentViewController:caremaNav animated:YES completion:^{
            
        }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
   

}

//拍照页面，切换前后摄像头按钮按钮
- (void)switchCameraBtnPressed:(UIButton*)sender {
    
    
    sender.selected = !sender.selected;
    [manager switchCamera:sender.selected];
}

#pragma mark -------------pinch camera---------------
//伸缩镜头
- (void)handlePinch:(UIPinchGestureRecognizer*)gesture {
    
    [manager pinchCameraView:gesture];
    
    if (_scSlider) {
        if (_scSlider.alpha != 1.f) {
            [UIView animateWithDuration:0.3f animations:^{
                _scSlider.alpha = 1.f;
            }];
        }
        [_scSlider setValue:manager.scaleNum shouldCallBack:NO];
        
        if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
            [self setSliderAlpha:YES];
        } else {
            [self setSliderAlpha:NO];
        }
    }
}


#pragma mark -------------save image to local---------------
//保存照片至本机
//- (void)saveImageToPhotoAlbum:(UIImage*)image {
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error != NULL) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了!" message:@"存不了T_T" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    } else {
//        SCDLog(@"保存成功");
//    }
//}

#pragma mark ------------notification-------------
- (void)orientationDidChange:(NSNotification*)noti {
    
    if (!_cameraBtnSet || _cameraBtnSet.count <= 0) {
        return;
    }
    [_cameraBtnSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIButton *btn = ([obj isKindOfClass:[UIButton class]] ? (UIButton*)obj : nil);
        if (!btn) {
            *stop = YES;
            return ;
        }
        
        btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait://1
            {
                transform = CGAffineTransformMakeRotation(0);
                break;
            }
            case UIDeviceOrientationPortraitUpsideDown://2
            {
                transform = CGAffineTransformMakeRotation(M_PI);
                break;
            }
            case UIDeviceOrientationLandscapeLeft://3
            {
                transform = CGAffineTransformMakeRotation(M_PI_2);
                break;
            }
            case UIDeviceOrientationLandscapeRight://4
            {
                transform = CGAffineTransformMakeRotation(-M_PI_2);
                break;
            }
            default:
                break;
        }
        [UIView animateWithDuration:0.3f animations:^{
            btn.transform = transform;
        }];
    }];
}

#pragma mark ---------rotate(only when this controller is presented, the code below effect)-------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    return [UIApplication sharedApplication].statusBarOrientation;
    return UIInterfaceOrientationPortrait;
}
#endif

#pragma mark - hud
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

//现实加载完成的hud
-(void)completeHud:(NSString *)title{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1];
    _hud = nil;
}
@end
