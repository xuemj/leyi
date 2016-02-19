//
//  PSPhotoInfo.h
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPhotoItem.h"

@interface PSPhotoInfo : NSObject

@property (nonatomic,strong) NSString   *photoId;
@property (nonatomic,strong) NSString   *title;
@property (nonatomic,strong) NSString   *accountUsn;
@property (nonatomic,strong) NSString   *accountNickName;
@property (nonatomic) NSInteger         photoNum;
@property (nonatomic,strong) NSArray    *photoItemArray;

- (instancetype)initWithDic:(NSDictionary *)dic;

+(NSMutableArray *)photoInfosWithPhotoDicArray:(NSArray *)dicArray;

@end
