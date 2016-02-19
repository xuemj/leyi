//
//  ImagePickerControllerAdjustViewController.h
//  ImageViewPickerTest
//
//  Created by zsy on 15/1/5.
//  Copyright (c) 2015年 zsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+Image.h"

#import "ImagePickerMaskView.h"

@class ImagePickerMaskView;

@protocol ImagePickerControllerAdjustViewControllerDelegate;

@interface ImagePickerControllerAdjustViewController : UIViewController <UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>

@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, strong) UIImage *adjustedImage;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSString *isAva;

@property (nonatomic, strong) ImagePickerMaskView *maskView;

@property (nonatomic, assign) id<ImagePickerControllerAdjustViewControllerDelegate> delegate;

@end


@protocol ImagePickerControllerAdjustViewControllerDelegate <NSObject>

@optional
- (void)imagePickerAdjustDidChooseImage:(ImagePickerControllerAdjustViewController *)imagePickerControllerAdjustViewController withImage:(UIImage *)image;

@end
