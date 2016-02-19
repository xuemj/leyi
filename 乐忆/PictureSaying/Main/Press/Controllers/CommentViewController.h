//
//  CommentViewController.h
//  Comment
//
//  Created by tutu on 14/12/10.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MainModel.h"
#import "EventModel.h"

@protocol CommentViewControllerDelegate <NSObject>

-(void)commentCountRefresh;
-(void)likeStatusRefresh:(id)like;

@end

@interface CommentViewController : BaseViewController
{
    UIButton *_sendButton;
}
@property(nonatomic,strong)UILabel *placeHodel;
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic) BOOL                isReply;
@property(nonatomic)int myid;
@property(nonatomic, copy)NSString *isStory;
@property(nonatomic, copy)NSString *storyId;
@property(nonatomic, copy)NSString *eventId;
@property(nonatomic, retain)MainModel *imodel;
@property(nonatomic, retain)EventModel *emodel;
@property(nonatomic,strong)NSArray *chuanzhi;
@property(nonatomic,strong)NSArray *eventdata;
@property(nonatomic,copy)NSString *num;
@property (nonatomic, copy)NSString *isMine;
@property (nonatomic, copy)NSString *fromEvent;

@property (nonatomic) id<CommentViewControllerDelegate> delegate;

@end
