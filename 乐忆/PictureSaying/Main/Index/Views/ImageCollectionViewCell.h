//
//  ImageCollectionViewCell.h
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageScrollView;

@interface ImageCollectionViewCell : UICollectionViewCell
{
    ImageScrollView *_photoSV;
    UIImageView *_labBG;
    UILabel *_descLabel;
    UILabel *_eventDesc;
}
@property(nonatomic, retain)NSDictionary *url;
@property(nonatomic, strong)ImageScrollView *photoSV;
@property(nonatomic, assign)NSInteger row;
@property(nonatomic, copy)NSString *title;
@end
