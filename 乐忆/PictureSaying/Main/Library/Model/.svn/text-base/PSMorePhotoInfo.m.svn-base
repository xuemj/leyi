//
//  PSMorePhotoInfo.m
//  PictureSaying
//
//  Created by tutu on 15/1/7.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "PSMorePhotoInfo.h"

@implementation PSMorePhotoInfo

- (instancetype)initWithMorePhotosDic:(NSDictionary *)photoDic
{
    self = [super init];
    if (self) {
        self.time = photoDic[kTime];
        self.photos = [PSPhotoItem photoItemsWithPhotoDicArray:photoDic[kPhotos]];
    }
    return self;
}

+(NSMutableArray *)morePhotosWithMorePhotoDicArray:(NSArray *)dicArray
{
    NSMutableArray *morePhotos = [NSMutableArray arrayWithCapacity:dicArray.count];
    for (NSDictionary *dic in dicArray)
    {
        PSMorePhotoInfo *morePhotoInfo = [[PSMorePhotoInfo alloc] initWithMorePhotosDic:dic];
        [morePhotos addObject:morePhotoInfo];
    }
    return morePhotos;
}

@end
