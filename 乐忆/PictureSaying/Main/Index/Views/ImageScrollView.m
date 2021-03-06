//
//  ImageScrollView.m
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "ImageScrollView.h"
#import "BigImageController.h"


@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 3;
        [self addSubview:_imageView];
        
        av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        av.frame = CGRectMake((KScreenWidth-60)/2, 200, 60, 60);
        [_imageView addSubview:av];
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 2;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1:)];
        [self addGestureRecognizer:tap1];
        [tap1 requireGestureRecognizerToFail:tap];
        
    }
    return self;
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.zoomScale > 1) {
        [self setZoomScale:1 animated:YES];
    }else if (self.zoomScale < 1){
        [self setZoomScale:1 animated:YES];
    }else{
        [self setZoomScale:3 animated:YES];
    }
}

-(void)tapAction1:(UITapGestureRecognizer *)tap{
    BigImageController *lookingVC = [self getLookingVC];
    [lookingVC showOrHiddenNavigationBarAndStatusBar];
}

-(BigImageController *)getLookingVC{
    UIResponder *nextResponder = self.nextResponder;
    do {
        if ([nextResponder isMemberOfClass:[BigImageController class]]) {
            return (BigImageController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    } while (nextResponder);
    return Nil;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

-(void)setImgUrl:(NSURL *)imgUrl{
    if (_imgUrl != imgUrl) {
        _imgUrl = imgUrl;
        [av startAnimating];
        //        [_imageView sd_setImageWithURL:_imgUrl];
        [_imageView sd_setImageWithURL:_imgUrl placeholderImage:nil options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            float progress = (float)receivedSize/expectedSize;
//            NSLog(@"progress == %f",progress);
//            NSLog(@"receivedSize == %d",receivedSize);
//            NSLog(@"expectedSize == %d",expectedSize);
//            _mrProgress.hidden = NO;
//            [_mrProgress setProgress:progress animated:YES];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [av stopAnimating];
            //            [_mrProgress show:NO];
            //            _mrProgress.mode = MRProgressOverlayViewModeCheckmark;
            //            _mrProgress.titleLabelText = @"Succeed";
//            _mrProgress.hidden = YES;
        }];
    }
}

@end
