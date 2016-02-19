//
//  FLbianjiViewController.h
//  GerenshezhiCenter
//
//  Created by tutu on 14-12-9.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FLQiMingZiViewController.h"
@interface FLbianjiViewController : BaseViewController<UIAlertViewDelegate>
{

    UIView *BianjiView;
    UIButton *TouxiangButton;
    UILabel *TouxianLable;
  
    UIButton *MingZiButton;
    UILabel *MingziLable;
    UILabel *sexDetail;
    UILabel *areaDetail;
    NSData *userAvaData;
    
    UIButton *imageBtton;
    UIImageView *image;
    
    UIImageView *jianTou;
    UIImageView *jianTou1;
    FLQiMingZiViewController *fl;
    UILabel *JieshouName;
    
    UIImage *stuCard;
    UIImage *clubImage;
    
    NSString *strr;
    UIImagePickerController *controller;
    UIImage *avaImage;
}

@property(nonatomic, retain)UIImage *ig;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, copy)NSString *userAva;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *phone;
@end
