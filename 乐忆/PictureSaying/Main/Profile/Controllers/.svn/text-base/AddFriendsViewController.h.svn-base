//
//  AddFriendsViewController.h
//  PictureSaying
//
//  Created by tutu on 14/12/30.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseViewController.h"

@protocol returnDelegate<NSObject>
-(void)sendToname:(NSString*)name;
-(void)sendToimage:(NSString*)image;
-(void)sendTocount:(NSInteger)count1;
-(void)sendToid:(NSString*)sid;
-(void)refreshUserInfoWithDictionary:(NSMutableDictionary *)userInfoDic withReplaceDictionary:(NSDictionary *)replaceDic;
@end

@interface AddFriendsViewController : BaseViewController<UINavigationControllerDelegate>
{
    NSDictionary *friendInfo;
    NSString *addFriend;
}
@property(nonatomic,copy)NSString *s1;
@property(nonatomic,copy)NSString *s2;
@property(nonatomic,assign)NSInteger addCount;
@property(nonatomic,weak)id<returnDelegate>delegate;
@property(nonatomic,strong)NSMutableDictionary *userInfoDic;
@property(nonatomic,strong)NSDictionary        *tapFriendInfoDic;

@end
