//
//  CommentViewCell.h
//  Comment
//
//  Created by tutu on 14/12/11.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "comment.h"
#import "AttributedLabel.h"
@interface CommentViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *MyCiew;
@property (weak, nonatomic) IBOutlet AttributedLabel *SeComment;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property(nonatomic, assign)int myrow;


@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property(nonatomic,retain)comment *comment;

+(CGFloat)getCellHeightWithComment:(comment *)commentuser;

@end
