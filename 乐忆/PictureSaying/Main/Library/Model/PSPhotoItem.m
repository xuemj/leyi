//
//  PSPhotoItem.m
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "PSPhotoItem.h"

@implementation PSPhotoItem

- (instancetype)initWithPhotoDic:(NSDictionary *)photoDic
{
    self = [super init];
    if (self) {
        self.itemId = photoDic[kId];
        self.path = photoDic[kPath];
    }
    return self;
}

+(NSMutableArray *)photoItemsWithPhotoDicArray:(NSArray *)dicArray
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:dicArray.count];
    for (NSDictionary *dic in dicArray)
    {
        PSPhotoItem *item = [[PSPhotoItem alloc] initWithPhotoDic:dic];
        [items addObject:item];
    }
    return items;
}

@end
