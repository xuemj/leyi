//
//  Constant.h
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#ifndef PictureSaying_Constant_h
#define PictureSaying_Constant_h

#define kId         @"id"
#define kAccountUsn @"accountUsn"
#define kAccountNickName @"accountNickName"
#define kPhotoNum   @"photoNum"
#define kPhotos     @"photos"
#define kPath       @"path"
#define kTitle      @"title"
#define kTime       @"time"
#define kMyUserInfo @"MyUserInfo"
#define kUsn        @"usn"
#define kNickname   @"nickname"
#define kImage      @"image"
#define kFromAccountNickName           @"fromAccountNickName"
#define kText       @"text"

#define kPush       @"push"
#define kBack       @"back"

#define kCompression_180    @"_compression_180_180.jpeg"
#define kCompression_188    @"_compression_150_150.jpeg"
//#define kCompression_0    @".jpeg"
//#define kCompression_188    @"_compression_188_188.jpeg"
#define kCompression_282    @"_compression_282_282.jpeg"
//#define kCompression_720    @"_compression_600_600.jpeg"
#define kCompression_720    @"_compression_1280_720.jpeg"
#define kCompression_1080   @"_compression_1920_1080.jpeg"

#define kHeaderTag  1545
#define kFooterTag1  1465
#define kFooterTag2  1765
#define kShareSuperViewTag   5334
#define kShareViewTag   5114

#define CONTENT NSLocalizedString(@"我正在使用乐忆分享,很方便,你也试试吧", @"www.wetime.cn")

#define kFriendRemark   @"friendRemark"
#define kFriendUsn      @"friendUsn"
#define NEED_OUT_SEX 1
//#if NEED_OUT_SEX
#define DDLog(xx, ...)                      NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DDLog(xx, ...)

#endif
