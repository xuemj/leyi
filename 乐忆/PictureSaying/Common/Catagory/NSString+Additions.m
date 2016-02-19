//
//  NSString+Additions.m
//  chat
//
//  Created by 王方帅 on 14-6-11.
//  Copyright (c) 2014年 王方帅. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

-(NSString *)PSsubstringToIndex:(NSUInteger)to
{
    if (to < self.length)
    {
        return [self substringToIndex:to];
    }
    else
    {
        return nil;
    }
}

@end
