//
//  PSMorePhotoController.h
//  PictureSaying
//
//  Created by tutu on 15/1/7.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PSMorePhotoInfo.h"

@interface PSMorePhotoController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_mainTableView;
    
    UIImageView     *_leftTopImageView;
    UIImageView     *_middleTopImageView;
    UIImageView     *_rightTopImageView;

    UIImageView     *_leftBottomImageView;
    UIImageView     *_middleBottomImageView;
    UIImageView     *_rightBottomImageView;
}

@property (nonatomic,strong) NSMutableArray     *morePhotoInfoArray;
@property (nonatomic,strong) NSString           *photoId;

-(void)photoBrowserShowWithMorePhotoInfo:(PSMorePhotoInfo *)photoInfo withCurrentIndex:(NSInteger)currentIndex withSrcImageView:(UIImageView *)srcImageView;

@end
