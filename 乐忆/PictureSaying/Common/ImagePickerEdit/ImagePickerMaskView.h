//
//  ImagePickerMaskView.h
//  ImageViewPickerTest
//
//  Created by zsy on 15/1/5.
//  Copyright (c) 2015年 zsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerMaskView : UIView

@property (nonatomic, assign) CGRect cicleRect;
@property (nonatomic, copy)NSString *isAva;
- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type;
@end
