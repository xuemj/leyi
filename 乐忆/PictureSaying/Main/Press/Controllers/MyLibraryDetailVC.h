//
//  MyLibraryDetailVC.h
//  PictureSaying
//
//  Created by tutu on 14/12/30.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseViewController.h"

@interface MyLibraryDetailVC : BaseViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIAlertViewDelegate,
UIActionSheetDelegate>
{
    UICollectionView *collectionViewXiang;
    UIView *bianjiView;
    
    UIButton *QuanxuanButton;
    UIButton *TianjiaButton;
    UIButton *ShanChuButton;
    UIImagePickerController *controller;
    NSMutableArray *dicArray;
    //返回多少相册头
    NSDictionary *dicccTionnTime;
    NSString *shijianShuju;
    NSDictionary *ddddCtionary;
    BOOL cls[10000];
    BOOL writeAble;
    
    NSArray *selectedImages;
    NSInteger index;
    NSInteger indextt;
    NSMutableArray *photoDelet;
    NSMutableArray *PhotoIdAll;
    NSString *isAll;
    
}
@property(nonatomic,copy)NSString *Jieshou;
@property(nonatomic,copy)NSString *albumName;
@property(nonatomic,copy)NSString *kongZhi;
@end
