//
//  CommonAlert.m
//  PictureSaying
//
//  Created by tutu on 15/1/30.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "CommonAlert.h"

@implementation CommonAlert

+(UIAlertView *)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message withDelegate:(BOOL)isDelegate withCancelButton:(NSString *)cancel withSure:(NSString *)sure withOwner:(NSObject *)obj{
    __block UIAlertView *alert;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isDelegate) {
            alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:obj cancelButtonTitle:cancel otherButtonTitles:sure, nil];
            [alert show];
        }else{
            alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:sure, nil];
            [alert show];
        }
    });
    return alert;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
