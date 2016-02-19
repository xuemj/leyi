//
//  ImagePickerViewController.h
//  ImageViewPickerTest
//
//  Created by zsy on 15/1/5.
//  Copyright (c) 2015年 zsy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImagePickerControllerAdjustViewController.h"

@protocol ImagePickerViewControllerDelegateDefine;

@interface ImagePickerViewController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerControllerAdjustViewControllerDelegate>

//@property (nonatomic, strong) UIImagePickerController *invokeCamera;
//@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
@property (nonatomic, copy)NSString *isAva;
@property (nonatomic, assign) id<ImagePickerViewControllerDelegateDefine> delegateDefine;

@end

@protocol ImagePickerViewControllerDelegateDefine <NSObject>

@optional
- (void)imagePickerDidCancel:(ImagePickerViewController *)imagePickerViewController;
- (void)imagePickerDidChooseImage:(ImagePickerViewController *)imagePickerViewController withImage:(UIImage *)image;

@end