//
//  ImagePickerControllerAdjustViewController.m
//  ImageViewPickerTest
//
//  Created by zsy on 15/1/5.
//  Copyright (c) 2015年 zsy. All rights reserved.
//

#import "ImagePickerControllerAdjustViewController.h"
#define toolbarHeight 44.f
#define ios7 [[UIDevice currentDevice] systemVersion].doubleValue >= 7.0
#define KScreen [[UIScreen mainScreen] bounds]

@interface ImagePickerControllerAdjustViewController ()

@end

@implementation ImagePickerControllerAdjustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //1、创建imgView和scrollView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height-20)];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    _imageView.clipsToBounds = YES;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    _adjustedImage = _sourceImage;
    [_imageView setImage:_adjustedImage];
    [self.view addSubview:_scrollView];
    
    UIView *buttonBg = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-80, KScreenWidth, 60)];
    buttonBg.backgroundColor = [UIColor blackColor];
    [self.view addSubview:buttonBg];
    //2、创建取消、确定按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(KScreenWidth-100, 20, 80, 30);
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"使用图片" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBg addSubview:doneButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, 20, 80, 30);
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBg addSubview:cancelButton];
    
    //3、创建maskView
    _maskView = [[ImagePickerMaskView alloc] initWithFrame:_scrollView.frame withType:self.isAva];
    _maskView.userInteractionEnabled = NO;
    _scrollView.backgroundColor = [UIColor blackColor];
    
    //4、上、左、下、右的内容填充
    _scrollView.contentInset = UIEdgeInsetsMake((_scrollView.frame.size.height - _maskView.cicleRect.size.height)/2 - 20, (_scrollView.frame.size.width-_maskView.cicleRect.size.width)/2, (_scrollView.frame.size.height - _maskView.cicleRect.size.height)/2, (_scrollView.frame.size.width-_maskView.cicleRect.size.width)/2);
    [self.view addSubview:_maskView];
    
    //5、计算最小的缩放比例
    //保持和图片的宽高一样
    _imageView.frame = CGRectMake(0, 0, _adjustedImage.size.width, _adjustedImage.size.height);
    
    CGFloat widthScale = _adjustedImage.size.width/_maskView.cicleRect.size.width;//图片和圆圈的宽比例
    CGFloat heightScale = _adjustedImage.size.height/_maskView.cicleRect.size.height;//图片和圆圈的高比例
    
    _scrollView.maximumZoomScale = 10;
    _scrollView.minimumZoomScale = widthScale < heightScale ? 1/widthScale : 1/heightScale;
    if (_scrollView.minimumZoomScale > _scrollView.maximumZoomScale) {
        _scrollView.maximumZoomScale = _scrollView.minimumZoomScale * 2;
    }
    //刚进入这个页面显示最小比例的缩放图片
    _scrollView.zoomScale = _scrollView.minimumZoomScale *1.2;
    _imageView.backgroundColor = [UIColor blueColor];
    
    
    //6、调整让图片居中显示
    CGFloat contentOffSetX = fabs((_imageView.frame.size.width - _maskView.cicleRect.size.width)/2);
    CGFloat contentOffSetY = fabs((_imageView.frame.size.height - _maskView.cicleRect.size.height)/2);
    
    CGPoint pointContentOffset = CGPointMake(_scrollView.contentOffset.x + contentOffSetX , _scrollView.contentOffset.y + contentOffSetY);
    _scrollView.contentOffset = pointContentOffset;
    
//    [self initNavigationBar];
}

-(void)initNavigationBar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreen.size.width, 64)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    //返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 100, 25)];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"editBack"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    //移动和缩放
    UIImageView *moveAndScaleImg = [[UIImageView alloc]initWithFrame:CGRectMake((view.frame.size.width - 94) / 2, 20 + (44 - 18)/2, 94, 18)];
    [moveAndScaleImg setImage:[UIImage imageNamed:@"moveAndScale"]];
    backBtn.center = CGPointMake(backBtn.center.x, moveAndScaleImg.center.y);
    
    [view addSubview:backBtn];
    [view addSubview:moveAndScaleImg];
    [self.view addSubview:view];
}


//调整电池条为白色和透明
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    //为了适配导航栏为白色，此句话不能少
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}


#pragma  mark - buttonClickAction
- (void)btnDone:(UIButton *)Sender {
    //如果图片放大，则_maskView转换之后的宽和高也会变大
//    
//    CGRect circleRect = [_maskView convertRect:_maskView.frame toView:_imageView];
//    CGRect imgRect = CGRectMake(circleRect.origin.x + _maskView.cicleRect.origin.x, circleRect.origin.y + _maskView.cicleRect.origin.y, _maskView.cicleRect.size.width, _maskView.cicleRect.size.height);
//     CGImageRef cgImage = CGImageCreateWithImageInRect([_imageView.image CGImage], imgRect);
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    
    CGFloat scale = [[_scrollView window] screen].scale;
    
    UIImage *scrollViewToImage = [_scrollView viewToImage:scale];
    CGRect bounds = _maskView.bounds;
    
    CGRect circleRect = CGRectMake(CGRectGetMidX(bounds) - _maskView.cicleRect.size.width / 2,
                                         CGRectGetMidY(bounds) - _maskView.cicleRect.size.width / 2,
                                        _maskView.cicleRect.size.width, _maskView.cicleRect.size.width);
    
    circleRect.origin.x *= scale;
    circleRect.origin.y *= scale;
    circleRect.size.width *= scale;
    circleRect.size.height *= scale;
    
    CGImageRef cgImage = CGImageCreateWithImageInRect([scrollViewToImage CGImage], circleRect);
    _adjustedImage = [UIImage imageWithCGImage:cgImage];
    
    if([_delegate respondsToSelector:@selector(imagePickerAdjustDidChooseImage:withImage:)])
        [_delegate imagePickerAdjustDidChooseImage:self withImage:_adjustedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnCancel:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
