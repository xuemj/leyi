//
//  ZoomIamgeView.m
//  PictureSaying
//
//  Created by tutu on 14-10-5.
//  Copyright (c) 2014年 tutu. All rights reserved.
//
#import "ZoomIamgeView.h"

@implementation ZoomIamgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initTap];
    }
    return self;
}

-(id)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        [self _initTap];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self _initTap];
}

-(void)_initTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInAction:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void)zoomInAction:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    [self _createView];
    //放大动画效果
    CGRect frame = [self convertRect:self.bounds toView:self.window];       //把self的bounds转换到相对于window的
    _fullImageView.frame = frame;

    [UIView animateWithDuration:0.3
                     animations:^{
                         _fullImageView.frame = [UIScreen mainScreen].bounds;
                     }
                     completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                         _scrollView.backgroundColor = [UIColor blackColor];
                         if ([self.delegate respondsToSelector:@selector(imageDidZoomIn:)]) {
                             [self.delegate imageDidZoomIn:self];
                         }
                         
                     }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenStatusBar" object:Nil];
}

-(void)_createView{
    if (_scrollView == Nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale = 1;
        [self.window addSubview:_scrollView];
    }
    //添加缩小手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutAction)];
    [_scrollView addGestureRecognizer:tap];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    longPress.minimumPressDuration = 1;
//    longPress.allowableMovement = 50;
//    [_scrollView addGestureRecognizer:longPress];
//    [tap requireGestureRecognizerToFail:longPress];
    
    //创建全屏显示的图片
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
    }
}

-(void)zoomOutAction{
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    //缩小的动画效果
    [UIView animateWithDuration:.3
                     animations:^{
                         _fullImageView.frame = [self convertRect:self.bounds toView:self.window];
                     }
                     completion:^(BOOL finished) {
                         [_scrollView removeFromSuperview];
                         //释放视图
                         _scrollView = nil;
                         _fullImageView = nil;
                         if ([self.delegate respondsToSelector:@selector(imageDidZoomOut:)]) {
                             [self.delegate imageDidZoomOut:self];
                         }
                     }];
}

//数据加载完成之后调用
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    //将数据转成UIImage
//    UIImage *image = [UIImage imageWithData:_data];
//    
//    _fullImageView.image = image;
//    
//    //处理图片的尺寸
//    //图片在当前设备屏幕中的高度
//    CGFloat height = image.size.height/image.size.width * KScreenWidth;
//    if (height < KScreenHeight) {//高度小雨屏幕的高度，剧中显示
//        _fullImageView.top = (KScreenHeight - height)/2;
//    }
//    _fullImageView.height = height;
//    _scrollView.contentSize = CGSizeMake(KScreenWidth, height);
//    
//}

#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _fullImageView;
}

-(UIViewController *)viewContorller{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != Nil);
    return Nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //返回状态栏的样式
}

//设置是否隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end
