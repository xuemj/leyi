//
//  PSPhotoInfo.m
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "PSPhotoInfo.h"

@implementation PSPhotoInfo

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.photoId = dic[kId];
        self.title = dic[kTitle];
        self.accountUsn = dic[kAccountUsn];
        self.accountNickName = dic[kAccountNickName];
        self.photoNum = [dic[kPhotoNum] integerValue];
        self.photoItemArray = [PSPhotoItem photoItemsWithPhotoDicArray:dic[kPhotos]];
    }
    return self;
}

+(NSMutableArray *)photoInfosWithPhotoDicArray:(NSArray *)dicArray
{
    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:dicArray.count];
    for (NSDictionary *dic in dicArray)
    {
        PSPhotoInfo *info = [[PSPhotoInfo alloc] initWithDic:dic];
        [infos addObject:info];
    }
    return infos;
}

@end
