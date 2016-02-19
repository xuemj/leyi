//
//  MainModel.h
//  PictureSaying
//
//  Created by tutu on 15/1/28.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "BaseModel.h"

@interface MainModel : BaseModel
@property(nonatomic, copy)NSString *sid;    //id
@property(nonatomic, copy)NSString *usn;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic, copy)NSString *content;       //故事或事件内容
@property(nonatomic, copy)NSString *dateString;    //日期
@property(nonatomic, copy)NSString *zanCount;      //点赞数
@property(nonatomic, copy)NSString *commentCount;  //评论数
@property(nonatomic, copy)NSString *isOdd;
@property(nonatomic, copy)NSString *isZan;    //是否点赞
//@property(nonatomic, copy)NSString *isOne;
@property(nonatomic, copy)NSString *title;
//@property(nonatomic, copy)NSString *templateId;
@property(nonatomic, copy)NSString *storyId;    //故事id
@property(nonatomic, copy)NSString *time;
@property(nonatomic, copy)NSString *originalTime;
@property(nonatomic, copy)NSString *descrip;    //故事或事件描述
@property(nonatomic, copy)NSString *image;      //封面或事件的第一张图片
@property(nonatomic, copy)NSString *accountAva; //头像
@property(nonatomic, copy)NSString *accountNickName;    //昵称
@property(nonatomic, copy)NSString *itemId;    //故事id
@property(nonatomic, copy)NSString *isSub;
@property(nonatomic, retain)NSArray *pics;
@property(nonatomic,retain)NSNumber *visible;

@end
