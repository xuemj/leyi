//
//  ImageScrollView.h
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *_imageView;
    UIActivityIndicatorView *av;
    //    NSInteger indexPage;
//    MRProgressOverlayView *_mrProgress;
    
}

@property(nonatomic, retain)NSURL *imgUrl;

@end
