//
//  ZoomIamgeView.h
//  PictureSaying
//
//  Created by tutu on 14-10-5.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomIamgeView;
@protocol ZoomImageViewDelegate <NSObject>

@optional
//1.图片将要/已经放大
-(void)imageWillZoomIn:(ZoomIamgeView *)imageView;
- (void)imageDidZoomIn:(ZoomIamgeView *)imageView;

//2.图片将要/已经缩小
- (void)imageWillZoomOut:(ZoomIamgeView *)imageView;
- (void)imageDidZoomOut:(ZoomIamgeView *)imageView;

@end

@interface ZoomIamgeView : UIImageView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    double _length;
}

@property(nonatomic , assign)id<ZoomImageViewDelegate>delegate;
@end
