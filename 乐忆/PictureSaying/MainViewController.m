//
//  MainViewController.m
//  TTSinaWeibo
//
//  Created by NimoT's Mac on 14-9-22.
//  Copyright (c) 2014年 wxhl. All rights reserved.
//

#import "MainViewController.h"
#import "DiscoveryViewController.h"
#import "PressViewController.h"
#import "BaseNaviagtionViewController.h"
#import "CreateViewController.h"
#import "CameraViewController.h"
#import "TestViewController.h"
#import "PSPhotoController.h"
#import "GuideView.h"
#import "UIView+Additions.h"
#import "RecordViewController.h"
#import "MobClick.h"
//#import "BoolAnimationView.h"
//#import "UIViewExt.h"

@interface MainViewController ()
{
    NSArray *viewControllers;
}
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push" object:nil];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"back" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAction:) name:@"push" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAction:) name:@"back" object:nil];
    self.view.backgroundColor = [UIColor grayColor];
    [self _initTabBar];
    [self _initViewControllers];
    if ([_fromAlbum isEqualToString:@"yes"]) {
        
    }else{
        [self _createGuideView];
    }
}

-(void)_createGuideView{
    GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:guideView];
    [self.view bringSubviewToFront:guideView];
}

-(void)pushAction:(NSNotification *)notification{
//    [UIView transitionWithView:self.view duration:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CGRect rect = _tabBarImgView.frame;
//        rect.origin.x = -KScreenWidth-200;
//        _tabBarImgView.frame = rect;
    _tabBarImgView.hidden = YES;
    
//    } completion:nil];
}

-(void)showAction:(NSNotification *)notification{
//    [UIView transitionWithView:self.view duration:0.20 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        CGRect rect = _tabBarImgView.frame;
//        rect.origin.x = 0;
//        _tabBarImgView.frame = rect;
        _tabBarImgView.hidden = NO;
//    } completion:nil];
}

-(void)_initTabBar{
    
    float y = ios7?KScreenHeight-49-10:KScreenHeight-49-40;
    _tabBarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, KScreenWidth, 47+10)];
    _tabBarImgView.backgroundColor = [UIColor clearColor];
    _tabBarImgView.userInteractionEnabled = YES;
    _tabBarImgView.multipleTouchEnabled = YES;
    _tabBarImgView.alpha = 0.88;
    _tabBarImgView.autoresizesSubviews = NO;
    _tabBarImgView.image = [UIImage imageNamed:@"tagbg.png"];
//    _tabBarImgView.image = [UIImage imageNamed:@"mask_navbar.png"];
//    if (self.show) {
//        _tabBarImgView.hidden = YES;
//    }
    [self.view addSubview:_tabBarImgView];
    
    int btnWidth = KScreenWidth/5;
    NSArray *btnImgNames = @[
                             @"picture_normal.png",
                             @"libray_normal.png",
                             @"story_normal.png",
                             @"square_normal.png",
                             ];
    
    NSArray *selectImgNames = @[@"picture_high.png",
                                @"libray_high.png",
                                @"story_high.png",
                                @"square_high.png",
                               ];
    for (int i = 0; i<btnImgNames.count; i++) {
        NSString *imgName = [btnImgNames objectAtIndex:i];
        NSString *selectImageName = selectImgNames[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i<2) {
            button.frame = CGRectMake(btnWidth * i, 10, btnWidth, 49);
        }else{
            button.frame = CGRectMake(btnWidth * (i+1), 10, btnWidth, 49);
        }
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
        button.tag = 100+i;
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarImgView addSubview:button];
    }
    
    UIButton *cremaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cremaButton.frame = CGRectMake((KScreenWidth/5)*2, 5, 49, 49);
    [cremaButton setCenter_x:_tabBarImgView.center.x];
    [cremaButton setImage:[UIImage imageNamed:@"crema"] forState:UIControlStateNormal];
    [cremaButton addTarget:self action:@selector(takephotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarImgView addSubview:cremaButton];
    UIButton *btn = (UIButton *)[_tabBarImgView viewWithTag:100];
    btn.selected = YES;
}

-(void)takephotoAction:(UIButton *)btn{
//    if ([self isCameraAvailable]) {
//        if (_imagePicker == nil) {
//            _imagePicker =  [[UIImagePickerController alloc] init];
//        }
//        _imagePicker.delegate = (id)self;
//        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        _imagePicker.showsCameraControls = YES;
//        _imagePicker.allowsEditing = YES;
//        [self presentViewController:_imagePicker animated:YES completion:nil];
//        
//    }
    [MobClick event:@"paizhao"];
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *cameraUnable = [[UIAlertView alloc] initWithTitle:@"无法启动相机" message:@"请为乐忆开放相机权限:设置-隐私-相机-乐忆时光-打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [cameraUnable show];
        return;
        
    }
    NSInteger index = _selectedIndex;
    UIViewController *vc = viewControllers[index];
    CameraViewController *caremaVC = [[CameraViewController alloc] init];
//    [vc.navigationController pushViewController:caremaVC animated:YES];
//    BaseViewController *caremaVC1 = [[BaseViewController alloc] init];
//    BaseNaviagtionViewController *caremaVC = [[BaseNaviagtionViewController alloc] initWithRootViewController:caremaVC1];
    [self presentViewController:caremaVC animated:YES completion:^{
    
    }];
//    for (UIViewController *vc in viewControllers) {
//        if (vc.view.window && vc.isViewLoaded) {
//            [vc presentViewController:caremaVC animated:YES completion:nil];
//            break;
//        }else{
//            [self presentViewController:caremaVC animated:YES completion:nil];
//            break;
//        }
//    }

}

-(void)clickAction:(UIButton *)btn{
    UIButton *btn0 = (UIButton *)[_tabBarImgView viewWithTag:100];
    UIButton *btn1 = (UIButton *)[_tabBarImgView viewWithTag:101];
    UIButton *btn2 = (UIButton *)[_tabBarImgView viewWithTag:102];
    UIButton *btn3 = (UIButton *)[_tabBarImgView viewWithTag:103];
    btn0.selected = NO;
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    btn.selected = YES;
    self.selectedIndex = btn.tag-100;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex != _selectedIndex) {
        //需要把上一个控制器的视图从父视图上移除才会调用上一个控制器的viewWillDisappear:方法，才能禁止mmdraw
        UIViewController *lastVC = [self.childViewControllers objectAtIndex:_selectedIndex];
//        if (_selectedIndex == 0) {
            [lastVC.view removeFromSuperview];
//        }
        UIButton *btn0 = (UIButton *)[_tabBarImgView viewWithTag:100];
        UIButton *btn1 = (UIButton *)[_tabBarImgView viewWithTag:101];
        UIButton *btn2 = (UIButton *)[_tabBarImgView viewWithTag:102];
        UIButton *btn3 = (UIButton *)[_tabBarImgView viewWithTag:103];
        
        btn0.selected = NO;
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        switch (selectedIndex+100)
        {
            case 100:
            {
                btn0.selected = YES;
            }
                break;
            case 101:
            {
                btn1.selected = YES;
            }
                break;
            case 102:
            {
                btn2.selected = YES;
                [MobClick event:@"gushijilu"];
            }
                break;
            case 103:
            {
                btn3.selected = YES;
            }
                break;
                
            default:
                break;
        }
        UIViewController *currentVC = [self.childViewControllers objectAtIndex:selectedIndex];
//        [self.view bringSubviewToFront:currentVC.view];
        [self.view insertSubview:currentVC.view belowSubview:_tabBarImgView];
//        }];
        _selectedIndex = selectedIndex;
        
    }
}

-(void)_initViewControllers{
//    IndexViewController *indexVC = [[IndexViewController alloc] init];
    RecordViewController *indexVC = [[RecordViewController alloc] init];
    PressViewController *pressVC = [[PressViewController alloc] init];
    DiscoveryViewController *discoveryVC = [[DiscoveryViewController alloc] init];
//    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    PSPhotoController *photoVC = [[PSPhotoController alloc] init];
    viewControllers = @[photoVC,pressVC,indexVC,discoveryVC];
    for (UIViewController *VC in viewControllers) {
        BaseNaviagtionViewController *nav = [[BaseNaviagtionViewController alloc] initWithRootViewController:VC];
        [self addChildViewController:nav];
        float height = ios7?KScreenHeight-49:KScreenHeight-49-20;
        nav.view.frame = CGRectMake(0, 0, KScreenWidth, height+49);
    }
    UIViewController *firstVC = [self.childViewControllers objectAtIndex:0];
    [self.view insertSubview:firstVC.view belowSubview:_tabBarImgView];
}

#pragma mark - UIImagePickerControllerDelegate
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

@end
