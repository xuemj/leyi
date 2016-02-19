//
//  MainModel.m
//  PictureSaying
//
//  Created by tutu on 15/1/28.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
-(void)setAttributes:(NSDictionary *)jsonDic{
    [super setAttributes:jsonDic];
    self.sid = [jsonDic objectForKey:@"id"];
    
    id time = [jsonDic objectForKey:@"time"];
    if (![time isKindOfClass:[NSNull class]]) {
        self.originalTime = [jsonDic objectForKey:@"time"];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        if ([time isKindOfClass:[NSString class]]) {
            NSDate *date = [formatter1 dateFromString:time];
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [formatter2 stringFromDate:date];
            self.time = dateStr;
        }
        if ([time isKindOfClass:[NSNumber class]]) {
        }
    }
    if (_pics.count>0) {
        self.image = [_pics[0] objectForKey:@"path"];
        self.itemId = [jsonDic objectForKey:@"id"];
        self.usn = [jsonDic objectForKey:@"accountUsn"];
    }
}
@end
