//
//  CommentViewCell.m
//  Comment
//
//  Created by tutu on 14/12/11.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "CommentViewCell.h"
#import "AppDelegate.h"
#import "UIViewExt.h"

#import "CommentViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+HB.h"
#import "PSConfigs.h"
#import "UIView+Additions.h"
#import "NSString+Additions.h"

@implementation CommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initViews];
}

-(void)initViews{
    //评论人头像
    self.userImage.backgroundColor = [UIColor lightGrayColor];
    self.userImage.layer.cornerRadius = 20;
    self.userImage.layer.masksToBounds = YES;
    [self.userImage.layer setBorderWidth:0.5];
    [self.userImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    self.labelName.textColor = CommonBlue;
    [self.commentBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    _lineView = [PSConfigs lineViewWithWidth:320 withY:0];
   
    self.lineView.backgroundColor = rgb(221,221, 221, 1);
    
}

-(void)setComment:(comment *)comment{
    if (_comment != comment) {
        _comment = comment;
    }

}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.SeComment setFrame_width:200];
    //评论高度
    CGSize size1 = [_comment.comments sizeWithFont:self.labelInfo.font constrainedToSize:CGSizeMake(KScreenWidth-self.userImage.right+10-50, 1000)];
    self.userImage.frame = CGRectMake(10, 10, 40, 40);
    self.labelName.frame = CGRectMake(60,10,100,20);
    //评论内容
    self.labelInfo.frame = CGRectMake(60, self.labelName.bottom, KScreenWidth-self.userImage.right+10-50, size1.height+10);
    
    NSString *replyName = nil;
    if ([_comment.replyName isKindOfClass:[NSString class]] && [_comment.replyName length] > 0)
    {
        replyName = _comment.replyName;
    }
    else
    {
        
        replyName = @"游客";
    }
    
    NSString *replyContent = nil;
    if ([_comment.replyContent isKindOfClass:[NSString class]] && [_comment.replyContent length] > 0)
    {
        replyContent = _comment.replyContent;
    }
    else
    {
        replyContent = @"";
    }
    
    NSString *replyComments = [NSString stringWithFormat:@"回复%@:%@",replyName,replyContent];
    self.SeComment.text = replyComments;
    
    long from = [@"回复" length];
    long length = [[[replyComments componentsSeparatedByString:@":"] firstObject] length]-from;
    [_SeComment setColor:CommonBlue fromIndex:from length:length];
   
    //回复评论高度
    CGSize size2 = [replyComments sizeWithFont:self.SeComment.font constrainedToSize:CGSizeMake(KScreenWidth-self.userImage.right+10-50-12, 1000)];
    //回复的背景图
    if (!_comment.replyName && !_comment.replyContent) {
        self.MyCiew.hidden = YES;
        self.MyCiew.frame = CGRectMake(60, self.labelName.bottom+size1.height+6, KScreenWidth-self.userImage.right+10-50, 0);
        
    
    }else{
        self.MyCiew.hidden = NO;
        self.MyCiew.frame = CGRectMake(60, self.labelName.bottom+size1.height+6, KScreenWidth-self.userImage.right+10-50, size2.height+20);
   
    }
    
    self.MyCiew.image = [UIImage resizableImage:@"replyBg.png" leftRatio:0.8 topRatio:0.5];
    
    //回复内容
    self.SeComment.frame = CGRectMake(_MyCiew.left+5,_MyCiew.top+3, self.MyCiew.frame.size.width-12, self.MyCiew.frame.size.height-3);
    
    self.time.frame = CGRectMake(60,_MyCiew.bottom+5, self.frame.size.width*0.5, 20);
    self.time.text = _comment.time;
    self.lineView.frame = CGRectMake(0,self.time.bottom+5, KScreenWidth, 0.5);
    //Model源赋值
    self.labelName.text = _comment.userName;
    if([_comment.userImageStr isKindOfClass:[NSString class]] && [_comment.userImageStr rangeOfString:@"jpeg"].location!=NSNotFound)
    {
        NSString *compressionString = kCompression_180;
        if ([PSConfigs getIphoneType] <= IphoneType_6)
        {
            
            
            compressionString = kCompression_180;
        }
        else if ([PSConfigs getIphoneType] <= IphoneType_6plus)
        {
            compressionString = kCompression_282;
        }
        
        
        NSString *imagePath = [[PSConfigs getImageUrlPrefixWithSourcePath:_comment.userImageStr] stringByAppendingString:compressionString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userImage sd_setImageWithURL:[NSURL URLWithString:imagePath]];
        });
     
    }
    else
    {
        self.userImage.image = [UIImage imageNamed:@"defaultAva"];
    }
    self.labelInfo.text = _comment.comments;
 //   self.time.text = _comment.time;
    self.commentBtn.tag = self.myrow;
    
    
}

+(CGFloat)getCellHeightWithComment:(comment *)commentuser
{
    //评论长度
    CGSize size1 = [commentuser.comments sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(KScreenWidth-53+10-50, 1000)];
    //回复长度
    NSString *replyComments = [NSString stringWithFormat:@"回复%@:%@",commentuser.replyName,commentuser.replyContent];
    CGSize size2 = [replyComments sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(KScreenWidth-53+10-50-12, 1000)];
    
    if (commentuser.replyName.length <= 0 && commentuser.replyContent.length <= 0) {
        return size1.height+size2.height+58;
    }else{
      
        return size1.height+size2.height+90;
    }
}
-(void)comment:(UIButton*)sender
{
    [self.viewController.tf becomeFirstResponder];
    self.viewController.tf.text = nil;
    self.viewController.isReply = YES;
    NSString *name = [NSString stringWithFormat:@"@%@:",_comment.userName];
    self.viewController.placeHodel.text = name;
    self.viewController.myid = (int)(sender.tag)-100;
}
-(CommentViewController*)viewController
{
    UIResponder *next = self.nextResponder;
    do{
        if ([next isKindOfClass:[CommentViewController class]]) {
            return (CommentViewController *)next;
        }
        next = next.nextResponder;
    
    }while (next != nil);
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
