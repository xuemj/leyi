//
//  PhotoScrollView.h
//  PictureSaying
//
//  Created by tutu on 15/1/4.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRProgressOverlayView.h"

@interface PhotoScrollView :UIScrollView<UIScrollViewDelegate>
{
    UIActivityIndicatorView *av;
    UIImageView *_imageView;
    //    NSInteger indexPage;
    MRProgressOverlayView *_mrProgress;
    
}

@property(nonatomic, retain)NSURL *imgUrl;


@end
