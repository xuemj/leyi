//
//  GuideView.m
//  PictureSaying
//
//  Created by tutu on 15/1/10.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "GuideView.h"
#import "FLViewController.h"

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.width = KScreenWidth;
        self.height = KScreenHeight;
        self.backgroundColor = [UIColor clearColor];
        [self _initViews];
    }
    return self;
}

-(void)_initViews{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/firstSetUp.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (dic == Nil) {
        dic = @{@"first": @YES};
        [dic writeToFile:path atomically:YES];
        [self _initFirstAnimationView];
    }else{
        [self _commonAnimationView];
    }
    
    //    [self _initFirstAnimationView];
    
}

-(void)_initFirstAnimationView{
    //创建滑动视图
    NSArray *imageNames;
    if (KScreenHeight == 480) {
        imageNames = @[@"guide4s1.png",@"guide4s2.png",@"guide4s3.png"];
    }else{
        imageNames = @[@"guideCommon1.png",@"guideCommon2.png",@"guideCommon3.png"];
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate =self;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = rgb(240, 240, 240, 1);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(KScreenWidth * (imageNames.count+1), KScreenHeight);
    [self addSubview:scrollView];

    for (int i = 0; i<imageNames.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight)];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        [scrollView addSubview:imageView];
        if (i==2) {
            imageView.userInteractionEnabled = YES;
            UIButton *inApp = [UIButton buttonWithType:UIButtonTypeCustom];
            inApp.frame = CGRectMake((KScreenWidth-((KScreenWidth-20)/2))/2, KScreenHeight-75, (KScreenWidth-20)/2, 44);
            [inApp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            inApp.titleLabel.font = [UIFont systemFontOfSize:22.0];
            [inApp setTitle:@"立即开始" forState:UIControlStateNormal];
            [inApp setBackgroundColor:CommonBlue];
            [inApp addTarget:self action:@selector(inApp:) forControlEvents:UIControlEventTouchUpInside];
            inApp.layer.cornerRadius = 5;
            inApp.layer.masksToBounds = YES;
            [imageView addSubview:inApp];
        }
    }
    
    //------------------创建页码------------------
    NSArray *pageImageNames = @[@"guideProgressCommon1.png",@"guideProgressCommon2.png",@"guideProgressCommon3.png"];
    pageImgs = [[NSMutableArray alloc] init];
    for (NSString *name in pageImageNames) {
        UIImage *img = [UIImage imageNamed:name];
        [pageImgs addObject:img];
    }
    
    pageImgView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth-60)/2, KScreenHeight-105, 60, 8)];
    pageImgView.image = pageImgs[0];
    [self addSubview:pageImgView];
}

-(void)inApp:(UIButton *)sender{
    [self performSelector:@selector(removeFromSuperview) withObject:Nil afterDelay:.6];
    [self performSelector:@selector(showNavAndStutas) withObject:Nil afterDelay:0.5];
}

-(void)_commonAnimationView{
    NSString *bgImgName = KScreenHeight == 480?@"start4S.png":@"startCommon.png";
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImgView.image = [UIImage imageNamed:bgImgName];
    [self addSubview:bgImgView];

    
    [UIView animateWithDuration:4.0 animations:^{
        CGAffineTransform transform = self.transform;
        self.transform = CGAffineTransformScale(transform,1.3, 1.3);
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
    
    [self performSelector:@selector(showNavAndStutas) withObject:Nil afterDelay:4];
}

-(void)showAnimationImg{
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationDuration:.15];
    //    int value = arc4random()%24;
    //    UIImageView *imageView = imgViews[value];
    UIImageView *imageView = imgViews[index];
    imageView.alpha = 1;
    [UIView commitAnimations];
    index++;
    if (index < imgViews.count) {
        [self performSelector:@selector(showAnimationImg) withObject:Nil afterDelay:0.08];
      
    }else{
        
        [self performSelector:@selector(removeFromSuperview) withObject:Nil afterDelay:0.4];
        [self performSelector:@selector(showNavAndStutas) withObject:Nil afterDelay:0.3];
        
    }
    
}

-(void)showNavAndStutas{
    [[UIApplication sharedApplication]setStatusBarHidden:NO animated:YES];
    self.viewController.navigationController.navigationBarHidden = NO;
    [self.viewController.telPhone becomeFirstResponder];
}

-(FLViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[FLViewController class]]) {
            return (FLViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger pageIndex = scrollView.contentOffset.x/KScreenWidth;
    if (pageIndex < pageImgs.count) {
        pageImgView.image = pageImgs[pageIndex];
    }else{
        [self performSelector:@selector(removeFromSuperview) withObject:Nil afterDelay:.4];
        [self performSelector:@selector(showNavAndStutas) withObject:Nil afterDelay:.3];
    }
    
    if (pageIndex>0) {
        scrollView.backgroundColor = [UIColor clearColor];
    }else{
        scrollView.backgroundColor = rgb(240, 240, 240, 1);
    }
    
    if (scrollView.contentOffset.x > scrollView.contentSize.width-(KScreenWidth*2)) {
        float beyondWidth = scrollView.contentOffset.x - (scrollView.contentSize.width-(KScreenWidth*2));
        float pageImgWidth = (KScreenWidth - 86.5)/2;
        pageImgView.left = pageImgWidth - beyondWidth;
    }
}

@end
