//
//  EventModel.m
//  PictureSaying
//
//  Created by tutu on 14/12/18.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "EventModel.h"

@implementation EventModel

-(void)setAttributes:(NSDictionary *)jsonDic{
    [super setAttributes:jsonDic];
    self.eventId = [jsonDic objectForKey:@"id"];
    self.favNum = [[jsonDic objectForKey:@"favNum"] stringValue];
    self.commentNum = [[jsonDic objectForKey:@"commentNum"] stringValue];
    self.writeAble = [[jsonDic objectForKey:@"writeAble"] stringValue];
    self.isZan = [jsonDic objectForKey:@"exitFav"];
    self.descrip = [jsonDic objectForKey:@"description"];
}

@end
