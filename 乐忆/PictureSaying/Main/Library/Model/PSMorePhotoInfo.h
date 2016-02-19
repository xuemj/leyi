//
//  PSMorePhotoInfo.h
//  PictureSaying
//
//  Created by tutu on 15/1/7.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPhotoItem.h"

@interface PSMorePhotoInfo : NSObject

@property (nonatomic,strong) NSString   *time;
@property (nonatomic,strong) NSMutableArray    *photos;

- (instancetype)initWithMorePhotosDic:(NSDictionary *)photoDic;

+(NSMutableArray *)morePhotosWithMorePhotoDicArray:(NSArray *)dicArray;

@end
