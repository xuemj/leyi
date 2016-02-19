//
//  PSPhotoCell.h
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPhotoItem.h"
#import "PSPhotoInfo.h"
#import "PSMorePhotoInfo.h"

@protocol PSPhotoBrowserDelegate <NSObject>

-(void)photoBrowserShowWithPhotoInfo:(PSPhotoInfo *)photoInfo withCurrentIndex:(NSInteger)currentIndex withSrcImageView:(UIImageView *)srcImageView;

-(void)photoBrowserShowWithMorePhotoInfo:(PSMorePhotoInfo *)photoInfo withCurrentIndex:(NSInteger)currentIndex withSrcImageView:(UIImageView *)srcImageView;

@end

@class PSPhotoController;
@interface PSPhotoCell : UITableViewCell
{
    IBOutlet UIImageView    *_leftImageView;
    IBOutlet UIImageView    *_middleImageView;
    IBOutlet UIImageView    *_rightImageView;
    PSPhotoInfo             *_photoInfo;
    PSMorePhotoInfo         *_morePhotoInfo;
    NSInteger               _baseIndex;
    BOOL                    _isHaveMore;
}

@property (nonatomic,assign) id<PSPhotoBrowserDelegate> superVC;

-(void)setLeftItem:(PSPhotoItem *)leftItem withMiddleItem:(PSPhotoItem *)middleItem withRightItem:(PSPhotoItem *)rightItem isSectionTwo:(BOOL)isSectionTwo superVC:(id)superVC belongtoPhotoInfo:(id)photoInfo;

+(float)getHeight;

-(NSArray *)getImageViews;

@end
