//
//  WanShanSingerInfermaionViewController.h
//  PictureSaying
//
//  Created by fulei on 15/1/26.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface WanShanSingerInfermaionViewController : BaseViewController<UINavigationBarDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{

    UIView *geRenView;
    UIButton *TouxiangButton;
    UILabel *shangChuanLable;
    UILabel *NichenLable;
    UITextField *text;
    UIButton *QuedingAction;
    UIView *BianjiView;
    UILabel *TouxianLable;
    UIButton *MingZiButton;
    UILabel *MingziLable;
    NSData *userAvaData;
    UIButton *imageBtton;
    UIImageView *image;
    UILabel *JieshouName;
    UIImage *stuCard;
    UIImage *clubImage;
    NSString *strr;
    UIImagePickerController *controller;
    UIImage *avaImage;
}
@property(nonatomic, retain)UIImage *ig;
@property(nonatomic,retain)NSString *ShoujiTele;
@end
