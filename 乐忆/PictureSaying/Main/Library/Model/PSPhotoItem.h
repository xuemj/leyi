//
//  PSPhotoItem.h
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSPhotoItem : NSObject

@property (nonatomic,strong) NSString   *itemId;
@property (nonatomic,strong) NSString   *path;

- (instancetype)initWithPhotoDic:(NSDictionary *)photoDic;

+(NSMutableArray *)photoItemsWithPhotoDicArray:(NSArray *)dicArray;

@end
